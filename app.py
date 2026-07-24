from flask import Flask, render_template, session, redirect, url_for
from views.admin import admin_bp
from views.hr import hr_bp
from views.manager import manager_bp
from views.intern import intern_bp
from views.auditor import auditor_bp
from views.auth import auth_bp
from dotenv import load_dotenv
load_dotenv()
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY')

# Register blueprints
app.register_blueprint(admin_bp)
app.register_blueprint(hr_bp)
app.register_blueprint(manager_bp)
app.register_blueprint(intern_bp)
app.register_blueprint(auditor_bp)
app.register_blueprint(auth_bp)

@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login')
def login():
    return render_template('login.html')  # placeholder

if __name__ == '__main__':
    app.run(debug=True)

