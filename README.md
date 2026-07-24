# RBAC Audit System

A Flask + MySQL based Role-Based Access Control (RBAC) system with full audit logging. Built to simulate how a company might manage employee access, approvals, and salary recommendations across departments — with every sensitive action tracked.

## Features
- 5 roles: **Admin, HR, Manager, Intern, Auditor** — each with a dedicated dashboard
- Signup requests with Admin approval flow (auto-assigns manager based on department)
- Access requests (view/edit/delete) with HR/Admin approval
- Manager-submitted salary recommendations routed to HR for approval
- Full audit logging on employee updates/deletes (via MySQL triggers)
- Session-based authentication with SHA-256 password hashing

## Tech Stack
- **Backend:** Flask (Python)
- **Database:** MySQL
- **Frontend:** HTML, Bootstrap

## Setup

### 1. Clone the repo
```bash
git clone https://github.com/Mayank935-code/rbac-audit-system.git
cd rbac-audit-system
```

### 2. Install dependencies
```bash
pip install flask mysql-connector-python python-dotenv
```

### 3. Set up the database
Create a MySQL database and import the schema + demo data:
```bash
mysql -u root -p -e "CREATE DATABASE company_rbac_audit;"
mysql -u root -p company_rbac_audit < database/rbac_db.sql
```

### 4. Configure environment variables
Copy `.env.example` to `.env` and fill in your own values:
```bash
cp .env.example .env
```
```
SECRET_KEY=generate-your-own-random-string
DB_HOST=localhost
DB_NAME=company_rbac_audit
DB_USER=root
DB_PASSWORD=your-mysql-password
```

### 5. Run the app
```bash
python app.py
```
Visit `http://127.0.0.1:5000`

## Demo Login
See [`credentials.txt`](./credentials.txt) for demo usernames/passwords across all 5 roles — try logging in as a Manager or Intern to see role-based views in action.

## Project Structure
```
├── app.py                 # Entry point, blueprint registration
├── config.py               # Loads secrets from environment
├── database/
│   ├── db_config.py        # DB connection helper
│   └── rbac_db.sql          # Schema + demo seed data
├── views/                  # Route handlers per role
├── templates/              # HTML templates
└── utils/                  # Password hashing, mailer helpers
```

## Note
This is a college project built for learning RBAC and audit-logging concepts. Demo data and credentials are intentionally public for reviewers — do not reuse this password pattern in any real system.
