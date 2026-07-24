from flask import Blueprint, render_template, session, redirect, request, flash
from database.db_config import get_db_connection
from datetime import datetime

manager_bp = Blueprint('manager', __name__)

@manager_bp.route('/manager/dashboard')
def manager_dashboard():
    if 'user_id' not in session:
        return redirect('/login')

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    try:
        # ✅ Get logged-in manager's emp_id and dept_id
        cur.execute("""
            SELECT e.emp_id, e.dept_id 
            FROM users u 
            JOIN employees e ON u.employee_id = e.emp_id 
            WHERE u.user_id = %s
        """, (user_id,))
        manager_data = cur.fetchone()
        manager_emp_id = manager_data['emp_id']
        dept_id = manager_data['dept_id']

        # ✅ Get interns & auditors under this manager (team view)
        cur.execute("""
            SELECT e.emp_id, e.name, e.email, e.salary, e.doj, d.dept_name, r.role_name, u.username 
            FROM employees e 
            JOIN departments d ON e.dept_id = d.dept_id 
            JOIN users u ON e.emp_id = u.employee_id 
            JOIN roles r ON u.role_id = r.role_id 
            WHERE e.manager_id = %s
        """, (manager_emp_id,))
        team_members = cur.fetchall()

        # ✅ Get all HRs in the same department for dropdown
        cur.execute("""
            SELECT u.user_id, u.username 
            FROM users u 
            JOIN employees e ON u.employee_id = e.emp_id 
            WHERE u.role_id = (SELECT role_id FROM roles WHERE role_name = 'HR') 
              AND e.dept_id = %s
        """, (dept_id,))
        available_hrs = cur.fetchall()

        # ✅ Profile Info
        cur.execute("""
            SELECT e.emp_id, e.name, e.email, e.doj, e.salary, d.dept_name, u.username, r.role_name
            FROM employees e
            JOIN departments d ON e.dept_id = d.dept_id
            JOIN users u ON e.emp_id = u.employee_id
            JOIN roles r ON u.role_id = r.role_id
            WHERE u.user_id = %s
        """, (user_id,))
        profile = cur.fetchone()

    finally:
        cur.close()
        conn.close()

    return render_template('manager_dashboard.html',
                           team_members=team_members,
                           available_hrs=available_hrs,
                           profile=profile)

@manager_bp.route('/manager/salary_recommendations', methods=['POST'])
def submit_salary_recommendation():
    if 'user_id' not in session:
        return redirect('/login')

    emp_id = request.form.get('emp_id')
    proposed_salary = request.form.get('proposed_salary')
    reason = request.form.get('reason')
    hr_user_id = request.form.get('hr_user_id')

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # ✅ Get logged-in manager's emp_id
        cur.execute("""
            SELECT e.emp_id 
            FROM users u 
            JOIN employees e ON u.employee_id = e.emp_id 
            WHERE u.user_id = %s
        """, (session['user_id'],))
        row = cur.fetchone()
        manager_emp_id = row[0] if row else None

        # ✅ Get current salary of employee
        cur.execute("SELECT salary FROM employees WHERE emp_id = %s", (emp_id,))
        old_salary_row = cur.fetchone()
        old_salary = old_salary_row[0] if old_salary_row else None

        # ✅ Insert into salary_recommendations
        cur.execute("""
            INSERT INTO salary_recommendations (emp_id, manager_id, old_salary, proposed_salary, reason, status)
            VALUES (%s, %s, %s, %s, %s, 'pending')
        """, (emp_id, manager_emp_id, old_salary, proposed_salary, reason))
        conn.commit()

        flash("✅ Salary recommendation submitted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash("❌ Failed to submit salary recommendation.", "danger")
        print("Manager Salary Form Error:", str(e))

    finally:
        cur.close()
        conn.close()

    return redirect('/manager/dashboard')

