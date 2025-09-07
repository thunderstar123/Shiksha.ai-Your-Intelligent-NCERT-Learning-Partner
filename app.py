# app.py
import sqlite3
from chatbot import ChatBot

def init_db():
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            role TEXT NOT NULL CHECK(role IN ('user', 'admin'))
        )
    ''')
    # Insert an admin user
    cursor.execute('''
        INSERT OR IGNORE INTO users (name, email, username, password, role)
        VALUES (?, ?, ?, ?, ?)
    ''', ('Admin User', 'admin@example.com', 'admin', 'adminpass', 'admin'))
    conn.commit()
    conn.close()

if __name__ == '__main__':
    init_db()


# app.py (continued)
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes
bot = ChatBot()

def get_user(username, password):
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute('SELECT name, role FROM users WHERE username=? AND password=?', (username, password))
    user = cursor.fetchone()
    conn.close()
    return user

def add_user(name, email, username, password, role):
    try:
        conn = sqlite3.connect('users.db')
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO users (name, email, username, password, role)
            VALUES (?, ?, ?, ?, ?)
        ''', (name, email, username, password, role))
        conn.commit()
        conn.close()
        return True
    except sqlite3.IntegrityError:
        return False

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    print(password)
    user = get_user(username, password)
    if user:
        return jsonify({'status': 'success', 'name': user[0], 'role': user[1]})
    else:
        return jsonify({'status': 'failure', 'message': 'Invalid credentials'}), 401

@app.route('/add_user', methods=['POST'])
def api_add_user():
    data = request.get_json()
    admin_username = data.get('admin_username')
    admin_password = data.get('admin_password')
    print("admin_username")
    # Authenticate admin
    admin = get_user(admin_username, admin_password)
    if not admin or admin[1] != 'admin':
        return jsonify({'status': 'failure', 'message': 'Unauthorized'}), 403
    
    # Get new user details
    name = data.get('name')
    email = data.get('email')
    username = data.get('username')
    password = data.get('password')
    role = data.get('role', 'user')  # Default role is 'user'
    
    if add_user(name, email, username, password, role):
        return jsonify({'status': 'success', 'message': 'User added successfully'})
    else:
        return jsonify({'status': 'failure', 'message': 'Username or email already exists'}), 400
    

@app.route('/chat', methods=['POST'])
def chat():
    print("HII")
    user_query = request.json.get('query')
    print(user_query)
    response = bot.get_response(user_query)
    return jsonify({'response': response})

if __name__ == '__main__':
    init_db()
    app.run(debug=False,host='0.0.0.0', port=5000)
    