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

from werkzeug.utils import secure_filename

from server.db import (

    agregar_empleado,
    obtener_empleado_por_correo,

    obtener_ingredientes,
    obtener_distribuidores,

    agregar_ingrediente,
    agregar_stock,

    agregar_producto,
    obtener_productos,
    obtener_categorias

)

# ==================================================
# CONFIGURACION FLASK
# ==================================================

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

    if request.method == 'POST':

        correo = request.form['correo']
        password = request.form['password']

        empleado = obtener_empleado_por_correo(correo)

        if empleado:

            if bcrypt.check_password_hash(
                empleado['password'],
                password
            ):

                session['logged_in'] = True

                session['id_empleado'] = empleado['id_empleado']

                session['nombre'] = empleado['nombre']

                session['puesto'] = empleado['puesto']

                puesto = empleado['puesto']

                # ============================
                # REDIRECCION POR PUESTO
                # ============================

                if puesto == 'Administrador':
                    return redirect(url_for('employees'))

                elif puesto == 'Caja':
                    return redirect(url_for('sales'))

                elif puesto == 'Almacen':
                    return redirect(url_for('ingredients'))

                elif puesto == 'Cocina':
                    return redirect(url_for('recipes'))

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

    return redirect(url_for('login'))

# ==================================================
# EMPLEADOS
# SOLO ADMINISTRADOR
# ==================================================

@app.route('/employees', methods=['GET', 'POST'])
@login_required
def employees():

    if session.get('puesto') != 'Administrador':
        return redirect(url_for('home'))

    # ======================================
    # AGREGAR EMPLEADO
    # ======================================

    if request.method == 'POST':

        matricula = request.form['matricula']

        nombre = request.form['nombre']

        puesto = request.form['puesto']

        correo = request.form['correo']

        password = request.form['password']

        # ==================================
        # ENCRIPTAR PASSWORD
        # ==================================

        password_hash = bcrypt.generate_password_hash(
            password
        ).decode('utf-8')

        # ==================================
        # GUARDAR EMPLEADO
        # ==================================

        agregar_empleado(
            matricula,
            nombre,
            puesto,
            correo,
            password_hash
        )

    return render_template(
        'auth/employees.html',
        tipo_nav='empleado'
    )

# ==================================================
# VENTAS
# ==================================================

@app.route('/sales')
@login_required
def sales():

    return render_template(
        'auth/sales.html',
        tipo_nav='empleado'
    )

# ==================================================
# PRODUCTOS
# ==================================================

@app.route('/products', methods=['GET', 'POST'])
@login_required
def products():

    # ======================================
    # GUARDAR PRODUCTO
    # ======================================

    if request.method == 'POST':

        nombre = request.form['nombre']
        descripcion = request.form['descripcion']
        precio = request.form['precio']
        categoria = request.form['categoria']

        imagen = request.files['imagen']

        nombre_imagen = secure_filename(
            imagen.filename
        )

        ruta_imagen = os.path.join(
            app.root_path,
            'client',
            'static',
            'img',
            'jpg',
            nombre_imagen
        )

        os.makedirs(
            os.path.dirname(ruta_imagen),
            exist_ok=True
        )

        imagen.save(ruta_imagen)

        agregar_producto(
            categoria,
            nombre,
            descripcion,
            precio,
            nombre_imagen
        )

        return redirect(url_for('products'))

    # ======================================
    # CONSULTAS
    # ======================================

    categorias = obtener_categorias()

    productos = obtener_productos()

    return render_template(
        'auth/products.html',
        tipo_nav='empleado',
        categorias=categorias,
        productos=productos
    )

# ==================================================
# INGREDIENTES
# ==================================================

@app.route('/ingredients', methods=['GET', 'POST'])
@login_required
def ingredients():

    # ======================================
    # GUARDAR INGREDIENTE
    # ======================================

    if request.method == 'POST':

        # SOLO ADMINISTRADOR
        if session.get('puesto') != 'Administrador':
            return redirect(url_for('ingredients'))

        nombre = request.form['nombre']

        unidad_medida = request.form[
            'unidad_medida'
        ]

        cantidad = request.form[
            'cantidad'
        ]

        distribuidor = request.form[
            'distribuidor'
        ]

        imagen = request.files['imagen']

        # ==================================
        # GUARDAR IMAGEN
        # ==================================

        nombre_imagen = secure_filename(
            imagen.filename
        )

        ruta_imagen = os.path.join(
            'static/img/jpg',
            nombre_imagen
        )

        imagen.save(ruta_imagen)

        # ==================================
        # INSERTAR INGREDIENTE
        # ==================================

        id_ingrediente = agregar_ingrediente(
            nombre,
            unidad_medida,
            nombre_imagen
        )

        # ==================================
        # INSERTAR STOCK
        # ==================================

        agregar_stock(
            id_ingrediente,
            distribuidor,
            cantidad
        )

        return redirect(url_for('ingredients'))

    # ======================================
    # CONSULTAR DATOS
    # ======================================

    ingredientes = obtener_ingredientes()

    distribuidores = obtener_distribuidores()

    return render_template(
        'auth/ingredients.html',
        tipo_nav='empleado',
        ingredientes=ingredientes,
        distribuidores=distribuidores
    )

# ==================================================
# RECETAS
# ==================================================

@app.route('/recipes')
@login_required
def recipes():

    return render_template(
        'auth/recipes.html',
        tipo_nav='empleado'
    )

# ==================================================
# MAIN
# ==================================================

if __name__ == '__main__':
    app.run(debug=True)