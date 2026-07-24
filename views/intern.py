#“As an intern, I may be assigned to assist in analyzing logs or validating support cases.
#Through the RBAC Audit system, I can formally raise access requests for production logs or 
#customer analytics dashboards — which are approved by HR/Admin. This way, access is traceable, temporary, and policy-compliant.”


from flask import Blueprint, render_template, session, redirect, request, flash
from database.db_config import get_db_connection

intern_bp = Blueprint('intern', __name__)

@intern_bp.route('/intern/dashboard')
def intern_dashboard():
    if 'user_id' not in session:
        return redirect('/login')

    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    try:
        # ✅ Get intern's employee_id and manager_id
        cur.execute("""
            SELECT e.emp_id, e.manager_id
            FROM users u
            JOIN employees e ON u.employee_id = e.emp_id
            WHERE u.user_id = %s
        """, (user_id,))
        intern_data = cur.fetchone()
        intern_emp_id = intern_data['emp_id']
        manager_id = intern_data['manager_id']

        # ✅ Profile section
        cur.execute("""
            SELECT e.emp_id, e.name, e.email, e.doj, e.salary, d.dept_name, u.username, r.role_name
            FROM employees e
            JOIN departments d ON e.dept_id = d.dept_id
            JOIN users u ON e.emp_id = u.employee_id
            JOIN roles r ON u.role_id = r.role_id
            WHERE u.user_id = %s
        """, (user_id,))
        profile = cur.fetchone()

        # ✅ Team View - all employees under same manager
        cur.execute("""
            SELECT e.emp_id, e.name, e.email, e.salary, e.doj, d.dept_name, r.role_name, u.username
            FROM employees e
            JOIN departments d ON e.dept_id = d.dept_id
            JOIN users u ON e.emp_id = u.employee_id
            JOIN roles r ON u.role_id = r.role_id
            WHERE e.manager_id = %s
        """, (manager_id,))
        team_members = cur.fetchall()

    finally:
        cur.close()
        conn.close()

    return render_template('intern_dashboard.html',
                           profile=profile,
                           team_members=team_members)


@intern_bp.route('/intern/request_access', methods=['POST'])
def request_access():
    if 'user_id' not in session:
        return redirect('/login')

    user_id = session['user_id']
    target_table = request.form.get('target_table')
    target_id = request.form.get('target_id') or None
    action_attempted = request.form.get('action_attempted')
    reason = request.form.get('reason')

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO access_requests (user_id, target_table, target_id, action_attempted, reason, status)
            VALUES (%s, %s, %s, %s, %s, 'pending')
        """, (user_id, target_table, target_id, action_attempted, reason))
        conn.commit()
        flash("✅ Access request submitted successfully.", "success")
    except Exception as e:
        print("Access Request Error:", str(e))
        flash("❌ Failed to submit access request.", "danger")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

    return redirect('/intern/dashboard?success=true')
