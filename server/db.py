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