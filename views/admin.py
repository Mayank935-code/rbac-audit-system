from flask import Blueprint, render_template, session, redirect, url_for, request, flash, jsonify
from database.db_config import get_db_connection

admin_bp = Blueprint('admin', __name__)

@admin_bp.route('/admin/dashboard')
def admin_dashboard():
    if 'user_id' not in session: 
        return redirect('/login')

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)  # ✅ dictionary=True is better

    # Now this will work
    cur.execute("""
        SELECT e.dept_id
        FROM users u
        JOIN employees e ON u.employee_id = e.emp_id
        WHERE u.user_id = %s
    """, (user_id,))
    admin_dept_id = cur.fetchone()

    # Employees table from admin_view (joined)
    cur.execute("SELECT * FROM admin_view")
    employees = cur.fetchall()

    # Departments
    cur.execute("SELECT * FROM departments")
    departments = cur.fetchall()

    # Users
    cur.execute("""
        SELECT u.user_id, u.employee_id, u.username, r.role_name
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
    """)
    users = cur.fetchall()

    # Audit logs
    cur.execute("SELECT * FROM audit_logs")
    audit_logs = cur.fetchall()

    # Pending signup requests
    cur.execute("""
        SELECT sr.request_id, sr.name, sr.email, sr.role, d.dept_name, sr.doj, sr.salary, sr.status
        FROM signup_requests sr
        JOIN departments d ON sr.dept_id = d.dept_id
        WHERE sr.dept_id = %s
        ORDER BY sr.timestamp DESC      
    """, (admin_dept_id['dept_id'],))   #extra

    signup_requests = cur.fetchall()

    # Profile info
    cur.execute("""
        SELECT e.emp_id, e.name, e.email, e.doj, e.salary, d.dept_name, u.username, r.role_name
        FROM employees e
        JOIN users u ON e.emp_id = u.employee_id
        JOIN departments d ON e.dept_id = d.dept_id
        JOIN roles r ON u.role_id = r.role_id
        WHERE u.user_id = %s
    """, (user_id,))
    profile = cur.fetchone()


    cur.close()
    conn.close()

    return render_template('admin_dashboard.html',
                           employees=employees,
                           departments=departments,
                           users=users,
                           audit_logs=audit_logs,
                           signup_requests=signup_requests,
                           profile=profile)


@admin_bp.route('/admin/handle_signup/<int:request_id>', methods=['POST'])
def handle_signup_request(request_id):
    if 'user_id' not in session:
        return redirect('/login')

    action = request.form.get('action')
    print("Received action:", action)

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    try:
        if action == 'approve':
            # Step 1: Fetch signup request
            cur.execute("""
                SELECT sr.*, d.dept_name 
                FROM signup_requests sr 
                JOIN departments d ON sr.dept_id = d.dept_id 
                WHERE sr.request_id = %s
            """, (request_id,))
            signup = cur.fetchone()
            print("Signup fetched:", signup)

            if not signup:
                flash("Signup request not found.")
                return redirect('/admin/dashboard')

            name = signup['name']
            email = signup['email']
            role = signup['role']
            dept_id = signup['dept_id']
            dept_name = signup['dept_name']
            doj = signup['doj']
            salary = signup['salary']
            password_hash = signup['password_hash']

            # Determine manager_id only if intern or auditor
            if role.lower() in ['intern', 'auditor']:
                cur.execute("""
                    SELECT e.emp_id
                    FROM employees e
                    JOIN users u ON e.emp_id = u.employee_id
                    JOIN roles r ON u.role_id = r.role_id
                    WHERE r.role_name = 'manager' AND e.dept_id = %s
                """, (dept_id,))
                managers = cur.fetchall()
                
                if managers:
                    import random
                    assigned_manager_id = random.choice(managers)['emp_id']
                else:
                    assigned_manager_id = None
            else:
                assigned_manager_id = None


            # Step 2: Insert into employees
            if assigned_manager_id:
                cur.execute("""
                    INSERT INTO employees (name, email, dept_id, doj, salary, manager_id)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, (name, email, dept_id, doj, salary, assigned_manager_id))
            else:
                cur.execute("""
                    INSERT INTO employees (name, email, dept_id, doj, salary)
                    VALUES (%s, %s, %s, %s, %s)
                """, (name, email, dept_id, doj, salary))

            conn.commit()
            emp_id = cur.lastrowid

            # Step 3: Generate username
            username = f"{name.split()[0].lower()}_{role.lower()}_{dept_name.lower().replace(' ', '')}_{emp_id}"

            # Step 4: Insert into users table
            role_map = {"admin": 1, "hr": 2, "manager": 3, "intern": 4, "auditor": 5}
            role_id = role_map.get(role.lower(), 5)  # default to auditor if unmatched

            cur.execute("""
                INSERT INTO users (username, password_hash, role_id, employee_id)
                VALUES (%s, %s, %s, %s)
            """, (username, password_hash, role_id, emp_id))

            # Step 5: Update signup_requests status
            cur.execute("UPDATE signup_requests SET status = 'approved' WHERE request_id = %s", (request_id,))
            conn.commit()

            flash(f"✅ Signup Approved. Username: {username}")

        elif action == 'reject':
            # Just mark the request as rejected
            cur.execute("UPDATE signup_requests SET status = 'rejected' WHERE request_id = %s", (request_id,))
            conn.commit()
            flash("❌ Signup request rejected.")

    except Exception as e:
        print("Signup Approval Error:", str(e))
        conn.rollback()
        flash("Something went wrong.")

    finally:
        cur.close()
        conn.close()

    return redirect('/admin/dashboard')

@admin_bp.route('/admin/delete_employee/<int:emp_id>', methods=['POST'])
def delete_employee(emp_id):
    if 'user_id' not in session:
        return redirect('/login')

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        # Delete from users first (FK constraint)
        cur.execute("DELETE FROM users WHERE employee_id = %s", (emp_id,))
        # Then delete from employees
        cur.execute("DELETE FROM employees WHERE emp_id = %s", (emp_id,))
        conn.commit()
        flash("Employee deleted successfully.")
    except Exception as e:
        conn.rollback()
        print("Delete Error:", str(e))
        flash("Error deleting employee.")
    finally:
        cur.close()
        conn.close()
    return redirect('/admin/dashboard')

@admin_bp.route('/admin/get_employee/<int:emp_id>')
def get_employee(emp_id):
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT * FROM employees WHERE emp_id = %s", (emp_id,))
    emp = cur.fetchone()
    cur.close()
    conn.close()
    return jsonify(emp) if emp else jsonify({})


@admin_bp.route('/admin/edit_employee/<int:emp_id>', methods=['POST'])
def edit_employee(emp_id):
    name = request.form['name']
    email = request.form['email']
    salary = request.form['salary']
    doj = request.form['doj']

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        cur.execute("""
            UPDATE employees 
            SET name = %s, email = %s, salary = %s, doj = %s 
            WHERE emp_id = %s
        """, (name, email, salary, doj, emp_id))
        conn.commit()
        flash("Employee updated successfully.")
    except Exception as e:
        conn.rollback()
        flash("Error updating employee.")
        print("Edit Error:", str(e))
    finally:
        cur.close()
        conn.close()

    return redirect('/admin/dashboard')