import os

from flask import (
    Flask,
    render_template,
    request,
    redirect,
    url_for,
    session
)

from flask_bcrypt import Bcrypt

app = Flask(
    __name__,
    template_folder='client/templates'
)

app.secret_key = os.environ.get(
    'SECRET_KEY',
    'clave_super_secreta'
)

bcrypt = Bcrypt(app)

# ==================================================
# LOGIN REQUIRED
# ==================================================

def login_required(f):

    from functools import wraps

    @wraps(f)
    def decorated_function(*args, **kwargs):

        if not session.get('logged_in'):
            return redirect(url_for('login'))

        return f(*args, **kwargs)

    return decorated_function


# ==================================================
# PAGINAS PUBLICAS
# ==================================================

@app.route('/')
def home():

    return render_template(
        'index.html',
        tipo_nav='cliente'
    )


@app.route('/menu')
def menu():

    return render_template(
        'menu.html',
        tipo_nav='cliente'
    )


@app.route('/about')
def about():

    return render_template(
        'about.html',
        tipo_nav='cliente'
    )


# ==================================================
# LOGIN
# ==================================================

@app.route('/login', methods=['GET', 'POST'])
def login():

    # Si ya inició sesión
    if session.get('logged_in'):

        puesto = session.get('puesto')

        if puesto == 'Administrador':
            return redirect(url_for('employees'))

        elif puesto == 'Caja':
            return redirect(url_for('sales'))

        elif puesto == 'Almacen':
            return redirect(url_for('ingredients'))

        elif puesto == 'Cocina':
            return redirect(url_for('recipes'))

    # FORMULARIO LOGIN
    if request.method == 'POST':

        correo = request.form['correo']
        password = request.form['password']

        # ==========================================
        # EJEMPLO TEMPORAL
        # DESPUES AQUI IRA MYSQL
        # ==========================================

        usuarios = [

            {
                'correo': 'admin@gmail.com',
                'password': '1234',
                'puesto': 'Administrador'
            },

            {
                'correo': 'caja@gmail.com',
                'password': '1234',
                'puesto': 'Caja'
            },

            {
                'correo': 'almacen@gmail.com',
                'password': '1234',
                'puesto': 'Almacen'
            },

            {
                'correo': 'cocina@gmail.com',
                'password': '1234',
                'puesto': 'Cocina'
            }

        ]

        usuario_encontrado = None

        for usuario in usuarios:

            if (
                usuario['correo'] == correo
                and
                usuario['password'] == password
            ):

                usuario_encontrado = usuario
                break

        # LOGIN CORRECTO
        if usuario_encontrado:

            session['logged_in'] = True
            session['correo'] = usuario_encontrado['correo']
            session['puesto'] = usuario_encontrado['puesto']

            puesto = usuario_encontrado['puesto']

            # ======================================
            # REDIRECCION POR PUESTO
            # ======================================

            if puesto == 'Administrador':
                return redirect(url_for('employees'))

            elif puesto == 'Caja':
                return redirect(url_for('sales'))

            elif puesto == 'Almacen':
                return redirect(url_for('ingredients'))

            elif puesto == 'Cocina':
                return redirect(url_for('recipes'))

        # LOGIN INCORRECTO
        return render_template(
            'login.html',
            tipo_nav='cliente',
            error='Correo o contraseña incorrectos'
        )

    return render_template(
        'login.html',
        tipo_nav='cliente'
    )


# ==================================================
# LOGOUT
# ==================================================

@app.route('/logout')
def logout():

    session.clear()

    return redirect(url_for('home'))


# ==================================================
# EMPLEADOS
# SOLO ADMINISTRADOR
# ==================================================

@app.route('/employees')
@login_required
def employees():

    if session.get('puesto') != 'Administrador':
        return redirect(url_for('home'))

    return render_template(
        'auth/employees.html',
        tipo_nav='empleado'
    )


# ==================================================
# VENTAS
# SOLO CAJA
# ==================================================

@app.route('/sales')
@login_required
def sales():

    if session.get('puesto') != 'Caja':
        return redirect(url_for('home'))

    return render_template(
        'auth/sales.html',
        tipo_nav='empleado'
    )


# ==================================================
# INGREDIENTES
# SOLO ALMACEN
# ==================================================

@app.route('/ingredients')
@login_required
def ingredients():

    if session.get('puesto') != 'Almacen':
        return redirect(url_for('home'))

    return render_template(
        'auth/ingredients.html',
        tipo_nav='empleado'
    )


# ==================================================
# RECETAS
# SOLO COCINA
# ==================================================

@app.route('/recipes')
@login_required
def recipes():

    if session.get('puesto') != 'Cocina':
        return redirect(url_for('home'))

    return render_template(
        'auth/recipes.html',
        tipo_nav='empleado'
    )


# ==================================================
# MAIN
# ==================================================

if __name__ == '__main__':
    app.run(debug=True)