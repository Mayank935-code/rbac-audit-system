from flask import Blueprint, request, session, redirect, jsonify, render_template
from database.db_config import get_db_connection
import hashlib

auth_bp = Blueprint('auth', __name__)

# --- Signup Pages ---
@auth_bp.route('/signup', methods=['GET'])
def signup_page():
    return render_template('signup.html')

@auth_bp.route('/signup', methods=['POST'])
def handle_signup():
    data = request.get_json()

    name = data.get('name')
    email = data.get('email')
    role = data.get('role')
    department = data.get('department')
    doj = data.get('doj')
    salary = data.get('salary')
    password = data.get('password')

    if not all([name, email, role, department, doj, salary, password]):
        return jsonify({'success': False, 'message': 'Missing required fields'})

    try:
        hashed_password = hashlib.sha256(password.encode()).hexdigest()

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("SELECT dept_id FROM departments WHERE dept_name = %s", (department,))
        dept_result = cur.fetchone()
        if not dept_result:
            return jsonify({'success': False, 'message': 'Invalid department selected'})
        dept_id = dept_result[0]

        cur.execute("""
            INSERT INTO signup_requests 
            (name, email, role, dept_id, doj, salary, password_hash)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (name, email, role, dept_id, doj, salary, hashed_password))

        conn.commit()
        cur.close()
        conn.close()

        return jsonify({'success': True})
    
    except Exception as e:
        print("Signup Error:", str(e))
        return jsonify({'success': False, 'message': 'Internal Server Error'})

# --- Login Pages ---
@auth_bp.route('/login', methods=['GET'])
def login_page():
    return render_template('login.html')

@auth_bp.route('/login', methods=['POST'])
def handle_login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'success': False, 'message': 'Missing credentials'})

    hashed_password = hashlib.sha256(password.encode()).hexdigest()

    try:
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)

        cur.execute("SELECT * FROM users WHERE username = %s AND password_hash = %s", (username, hashed_password))
        user = cur.fetchone()
        cur.close()
        conn.close()

        if not user:
            return jsonify({'success': False})

        # Save user session
        session['user_id'] = user['user_id']
        session['username'] = user['username']
        session['role_id'] = user['role_id']
        session['employee_id'] = user['employee_id']

        # Role-based redirect
        role_id = user['role_id']
        redirect_url = (
            "/admin/dashboard" if role_id == 1 else
            "/hr/dashboard" if role_id == 2 else
            "/manager/dashboard" if role_id == 3 else
            "/intern/dashboard" if role_id == 4 else
            "/auditor/dashboard" if role_id == 5 else
            "/dashboard"
        )

        return jsonify({'success': True, 'redirect': redirect_url})


    except Exception as e:
        print("Login Error:", str(e))
        return jsonify({'success': False, 'message': 'Internal Server Error'})
