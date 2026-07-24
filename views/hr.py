from flask import Blueprint, render_template, session, redirect, request
from database.db_config import get_db_connection

hr_bp = Blueprint('hr', __name__)

@hr_bp.route('/hr/dashboard')
def hr_dashboard():
    if 'user_id' not in session:
        return redirect('/login')

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    try:
        # Get department ID (for filtering if needed in future)
        cur.execute("""
            SELECT e.dept_id
            FROM users u
            JOIN employees e ON u.employee_id = e.emp_id
            WHERE u.user_id = %s
        """, (user_id,))
        dept_row = cur.fetchone()
        dept_id = dept_row['dept_id'] if dept_row else None

        # ✅ Employee directory from hr_view
        cur.execute("SELECT * FROM hr_view")
        employees = cur.fetchall()

        # ✅ Access requests from pending_requests_view
        cur.execute("""
            SELECT ar.*, u.username 
            FROM access_requests ar
            JOIN users u ON ar.user_id = u.user_id
            ORDER BY ar.timestamp DESC
        """)
        access_requests = cur.fetchall()

        # ✅ Salary recommendations
        cur.execute("""
            SELECT 
            sr.*,
            e.salary AS old_salary,
            e_user.username AS emp_username,
            m_user.username AS manager_username
        FROM salary_recommendations sr
        JOIN employees e ON sr.emp_id = e.emp_id
        JOIN users e_user ON e.emp_id = e_user.employee_id
        JOIN employees m ON sr.manager_id = m.emp_id
        JOIN users m_user ON m.emp_id = m_user.employee_id
        ORDER BY sr.timestamp DESC
        """)
        salary_recos = cur.fetchall()

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

    return render_template('hr_dashboard.html',
                           employees=employees,
                           access_requests=access_requests,
                           salary_recos=salary_recos,
                           profile=profile)


@hr_bp.route('/hr/handle_access/<int:request_id>', methods=['POST'])
def handle_access_decision(request_id):
    print("user_id:", session.get("user_id"))
    print("role:", session.get("role"))
    if 'user_id' not in session:
        return redirect('/login')

    action = request.form.get('action')  # 'approve' or 'deny'
    reviewer_id = session['user_id']

    new_status = 'approved' if action == 'approve' else 'denied'

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        UPDATE access_requests 
        SET status = %s, reviewer_id = %s 
        WHERE request_id = %s
    """, (new_status, reviewer_id, request_id))
    conn.commit()
    cur.close()
    conn.close()
    return redirect('/hr/dashboard')

@hr_bp.route('/hr/handle_salary/<int:rec_id>', methods=['POST'])
def handle_salary_reco(rec_id):
    if 'user_id' not in session:
        return redirect('/login')

    action = request.form.get('action')
    print("Submitted action:", action)
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        if action == 'approve':
            cur.execute("UPDATE salary_recommendations SET status = 'approved' WHERE rec_id = %s", (rec_id,))
        elif action == 'deny':
            cur.execute("UPDATE salary_recommendations SET status = 'denied' WHERE rec_id = %s", (rec_id,))
        conn.commit()
    except Exception as e:
        print("Salary Decision Error:", str(e))
        conn.rollback()
    finally:
        cur.close()
        conn.close()

    return redirect('/hr/dashboard')


@hr_bp.route('/hr/receive_salary_recommendation', methods=['POST'])
def receive_salary_recommendation():
    if 'user_id' not in session:
        return redirect('/login')

    emp_id = request.form.get('emp_id')
    proposed_salary = request.form.get('proposed_salary')
    reason = request.form.get('reason')
    manager_id = session.get('employee_id')  # From logged-in manager
    hr_id = request.form.get('hr_id')  # selected from dropdown

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO salary_recommendations (emp_id, manager_id, proposed_salary, reason)
            VALUES (%s, %s, %s, %s)
        """, (emp_id, manager_id, proposed_salary, reason))
        conn.commit()
        print("✅ Salary Recommendation Submitted")
    except Exception as e:
        print("❌ Insert Error:", e)
        conn.rollback()
    finally:
        cur.close()
        conn.close()

    return redirect('/manager/dashboard?success=true')

