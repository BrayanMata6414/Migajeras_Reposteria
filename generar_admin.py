from flask_bcrypt import Bcrypt

bcrypt = Bcrypt()

password = bcrypt.generate_password_hash(
    '1234'
).decode('utf-8')

print(password)