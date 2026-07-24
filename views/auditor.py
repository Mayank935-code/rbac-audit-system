from flask import Blueprint, render_template, session, redirect
from database.db_config import get_db_connection

auditor_bp = Blueprint('auditor', __name__)

@auditor_bp.route('/auditor/dashboard')
def auditor_dashboard():
    if 'user_id' not in session:
        return redirect('/login')

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    try:
        # ✅ Audit Logs from audit_view
        cur.execute("SELECT * FROM audit_view ORDER BY timestamp DESC")
        audit_logs = cur.fetchall()

        # ✅ Employees full view (join manually)
        cur.execute("""
            SELECT e.emp_id, e.name, e.email, e.doj, e.salary, d.dept_name, r.role_name, u.username
            FROM employees e
            JOIN departments d ON e.dept_id = d.dept_id
            JOIN users u ON e.emp_id = u.employee_id
            JOIN roles r ON u.role_id = r.role_id
        """)
        employees = cur.fetchall()

        # ✅ Access Requests
        cur.execute("""
            SELECT ar.*, u.username 
            FROM access_requests ar
            JOIN users u ON ar.user_id = u.user_id
            ORDER BY ar.timestamp DESC
        """)
        access_requests = cur.fetchall()

        # ✅ Signup Requests
        cur.execute("SELECT * FROM signup_requests ORDER BY timestamp DESC")
        signup_requests = cur.fetchall()

        # ✅ Auditor Profile
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

    return render_template("auditor_dashboard.html",
                           audit_logs=audit_logs,
                           employees=employees,
                           access_requests=access_requests,
                           signup_requests=signup_requests,
                           profile=profile)
