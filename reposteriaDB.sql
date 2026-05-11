CREATE DATABASE reposteria;
USE reposteria;

-- =========================================
-- TABLA: EMPLEADOS
-- =========================================

CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    puesto VARCHAR(50) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- TABLA: CATEGORIAS
-- =========================================

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- =========================================
-- TABLA: PRODUCTOS
-- =========================================

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    imagen VARCHAR(255),
    estado ENUM('disponible', 'no disponible') DEFAULT 'disponible',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- TABLA: RECETAS
-- =========================================

CREATE TABLE recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    elaboracion TEXT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_receta_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- TABLA: INGREDIENTES
-- =========================================

CREATE TABLE ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    unidad_medida VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE ingredientes
ADD imagen VARCHAR(255);

-- =========================================
-- TABLA: RELACION RECETAS - INGREDIENTES
-- =========================================

CREATE TABLE receta_ingredientes (
    id_receta INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_receta, id_ingrediente),

    CONSTRAINT fk_receta
        FOREIGN KEY (id_receta)
        REFERENCES recetas(id_receta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_ingrediente
        FOREIGN KEY (id_ingrediente)
        REFERENCES ingredientes(id_ingrediente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- TABLA: DISTRIBUIDORES
-- =========================================

CREATE TABLE distribuidores (
    id_distribuidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    correo VARCHAR(100),
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- TABLA: STOCK
-- =========================================

CREATE TABLE stock (
    id_stock INT AUTO_INCREMENT PRIMARY KEY,
    id_ingrediente INT NOT NULL,
    id_distribuidor INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_stock_ingrediente
        FOREIGN KEY (id_ingrediente)
        REFERENCES ingredientes(id_ingrediente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_stock_distribuidor
        FOREIGN KEY (id_distribuidor)
        REFERENCES distribuidores(id_distribuidor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- TABLA: VENTAS
-- =========================================

CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    total DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    hora_venta TIME NOT NULL,
    id_empleado INT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_venta_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES empleados(id_empleado)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- TABLA: DETALLE VENTAS
-- =========================================

CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (id_venta)
        REFERENCES ventas(id_venta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO empleados
(
    matricula,
    nombre,
    puesto,
    correo,
    password
)
VALUES
(
    'ADMIN001',
    'Administrador General',
    'Administrador',
    'admin@gmail.com',
    '$2b$12$HSXeRwi5Me52pCSQwYVvOuQYVY25CeFQ0FHH9v9XEQW1lLxjQJCPe'
);

INSERT INTO ingredientes
(nombre, unidad_medida, imagen)
VALUES
('Harina', 'kg', 'harina.jpg');

INSERT INTO distribuidores
(nombre, direccion, correo, telefono)
VALUES
('Maseca', 'Juarez', 'maseca@gmail.com', '6561111111'),
('Bimbo', 'Juarez', 'bimbo@gmail.com', '6562222222');

INSERT INTO stock
(id_ingrediente, id_distribuidor, precio, cantidad)
VALUES
(1, 1, 300, 5);

INSERT INTO categorias
(nombre, descripcion)
VALUES
('Pastel', 'Pasteles completos y personalizados'),

('Pan', 'Pan dulce y pan tradicional'),

('Galleta', 'Galletas artesanales y decoradas'),

('Cupcake', 'Cupcakes individuales de diferentes sabores'),

('Postre', 'Postres fríos y especiales'),

('Bebida', 'Bebidas frías y calientes'),

('Gelatina', 'Gelatinas de distintos sabores'),

('Pay', 'Pays dulces y tradicionales'),

('Rosca', 'Roscas y panes grandes'),

('Temporada', 'Productos especiales de temporada');

SELECT * FROM empleados;
SELECT * FROM productos;