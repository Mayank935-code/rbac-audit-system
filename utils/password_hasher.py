# utils/password_hasher.py

import hashlib

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def check_password(input_password, stored_hash):
    return hash_password(input_password) == stored_hash
