import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()

db_config = {

    'host': os.getenv('HOST'),
    'user': os.getenv('USER'),
    'password': os.getenv('PASSWORD'),
    'database': os.getenv('DATABASE')

}


# =========================================
# CONEXION
# =========================================

def conectar():

    conexion = mysql.connector.connect(**db_config)

    return conexion


# =========================================
# AGREGAR EMPLEADO
# =========================================

def agregar_empleado(
    matricula,
    nombre,
    puesto,
    correo,
    password
):

    conexion = conectar()

    cursor = conexion.cursor()

    sql = """
    INSERT INTO empleados
    (
        matricula,
        nombre,
        puesto,
        correo,
        password
    )
    VALUES
    (%s, %s, %s, %s, %s)
    """

    valores = (
        matricula,
        nombre,
        puesto,
        correo,
        password
    )

    cursor.execute(sql, valores)

    conexion.commit()

    cursor.close()
    conexion.close()


# =========================================
# OBTENER EMPLEADO POR CORREO
# =========================================

def obtener_empleado_por_correo(correo):

    conexion = conectar()

    cursor = conexion.cursor(dictionary=True)

    sql = """
    SELECT *
    FROM empleados
    WHERE correo = %s
    """

    cursor.execute(sql, (correo,))

    empleado = cursor.fetchone()

    cursor.close()
    conexion.close()

    return empleado

# =========================================
# OBTENER INGREDIENTES
# =========================================

def obtener_ingredientes():

    conexion = conectar()

    cursor = conexion.cursor(dictionary=True)

    sql = """
    SELECT

        ingredientes.nombre AS ingrediente,
        ingredientes.imagen,
        stock.cantidad,
        distribuidores.nombre AS distribuidor

    FROM stock

    INNER JOIN ingredientes
        ON stock.id_ingrediente = ingredientes.id_ingrediente

    INNER JOIN distribuidores
        ON stock.id_distribuidor = distribuidores.id_distribuidor

    ORDER BY stock.cantidad ASC
    """

    cursor.execute(sql)

    ingredientes = cursor.fetchall()

    cursor.close()
    conexion.close()

    return ingredientes

# =========================================
# AGREGAR INGREDIENTE
# =========================================

def agregar_ingrediente(
    nombre,
    unidad_medida,
    imagen
):

    conexion = conectar()

    cursor = conexion.cursor()

    sql = """
    INSERT INTO ingredientes
    (
        nombre,
        unidad_medida,
        imagen
    )
    VALUES
    (
        %s,
        %s,
        %s
    )
    """

    valores = (
        nombre,
        unidad_medida,
        imagen
    )

    cursor.execute(sql, valores)

    conexion.commit()

    id_ingrediente = cursor.lastrowid

    cursor.close()
    conexion.close()

    return id_ingrediente


# =========================================
# AGREGAR STOCK
# =========================================

def agregar_stock(
    id_ingrediente,
    id_distribuidor,
    cantidad
):

    conexion = conectar()

    cursor = conexion.cursor()

    sql = """
    INSERT INTO stock
    (
        id_ingrediente,
        id_distribuidor,
        precio,
        cantidad
    )
    VALUES
    (
        %s,
        %s,
        %s,
        %s
    )
    """

    valores = (
        id_ingrediente,
        id_distribuidor,
        0,
        cantidad
    )

    cursor.execute(sql, valores)

    conexion.commit()

    cursor.close()
    conexion.close()

# =========================================
# OBTENER DISTRIBUIDORES
# =========================================

def obtener_distribuidores():

    conexion = conectar()

    cursor = conexion.cursor(dictionary=True)

    sql = """
    SELECT *
    FROM distribuidores
    """

    cursor.execute(sql)

    distribuidores = cursor.fetchall()

    cursor.close()
    conexion.close()

    return distribuidores

# =========================================
# OBTENER PRODUCTOS
# =========================================

def obtener_productos():

    conexion = mysql.connector.connect(
        **db_config
    )

    cursor = conexion.cursor(
        dictionary=True
    )

    query = """
        SELECT
            productos.*,

            recetas.id_receta

        FROM productos

        LEFT JOIN recetas
            ON productos.id_producto = recetas.id_producto

        ORDER BY productos.cantidad ASC
    """

    cursor.execute(query)

    productos = cursor.fetchall()

    cursor.close()
    conexion.close()

    return productos


# =========================================
# AGREGAR PRODUCTOS
# =========================================

def agregar_producto(
    id_categoria,
    nombre,
    descripcion,
    precio,
    imagen
):

    conexion = mysql.connector.connect(**db_config)

    cursor = conexion.cursor()

    query = """
        INSERT INTO productos
        (
            id_categoria,
            nombre,
            descripcion,
            precio,
            imagen
        )
        VALUES
        (%s, %s, %s, %s, %s)
    """

    valores = (
        id_categoria,
        nombre,
        descripcion,
        precio,
        imagen
    )

    cursor.execute(query, valores)

    conexion.commit()

    cursor.close()
    conexion.close()

# =========================================
# AGREGAR PRODUCTOS
# =========================================

def obtener_categorias():

    conexion = mysql.connector.connect(**db_config)

    cursor = conexion.cursor(dictionary=True)

    query = """
        SELECT *
        FROM categorias
        ORDER BY nombre ASC
    """

    cursor.execute(query)

    categorias = cursor.fetchall()

    cursor.close()
    conexion.close()

    return categorias