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

INSERT INTO categorias (nombre, descripcion)
VALUES ('Pedidos personalizados', 'Productos elaborados bajo pedido y adaptados a eventos especiales');

INSERT INTO productos
(id_categoria, nombre, descripcion, precio, cantidad, imagen, estado)
VALUES
(1, 'Pastel Red Velvet', 'Pastel suave de cocoa con betún de queso crema, ideal para celebraciones.', 420.00, 8, 'pastel_red_velvet.jpg', 'disponible'),
(1, 'Pastel de Chocolate Belga', 'Pastel de chocolate intenso con cobertura cremosa y decoración artesanal.', 450.00, 6, 'pastel_chocolate_belga.jpg', 'disponible'),
(1, 'Pastel de Tres Leches', 'Pastel clásico bañado en mezcla de tres leches con crema batida.', 390.00, 10, 'pastel_tres_leches.jpg', 'disponible'),
(1, 'Pastel de Fresas con Crema', 'Pastel esponjoso relleno de fresas naturales y crema dulce.', 430.00, 7, 'pastel_fresas_crema.jpg', 'disponible'),

(2, 'Conchas de Vainilla', 'Pan dulce tradicional con cubierta sabor vainilla.', 18.00, 35, 'conchas_vainilla.jpg', 'disponible'),
(2, 'Roles de Canela', 'Pan suave enrollado con canela y glaseado dulce.', 32.00, 24, 'roles_canela.jpg', 'disponible'),
(2, 'Pan de Elote', 'Pan artesanal elaborado con elote natural y textura suave.', 35.00, 18, 'pan_elote.jpg', 'disponible'),
(2, 'Cuernitos de Mantequilla', 'Pan hojaldrado con sabor a mantequilla, ideal para acompañar café.', 22.00, 28, 'cuernitos_mantequilla.jpg', 'disponible'),
(2, 'Donas Glaseadas', 'Donas suaves con cobertura glaseada tradicional.', 20.00, 30, 'donas_glaseadas.jpg', 'disponible'),
(2, 'Orejas de Hojaldre', 'Pan crujiente de hojaldre con azúcar caramelizada.', 18.00, 25, 'orejas_hojaldre.jpg', 'disponible'),
(2, 'Bolillo Artesanal', 'Pan tradicional de corteza crujiente y miga suave.', 8.00, 40, 'bolillo_artesanal.jpg', 'disponible'),

(3, 'Galletas de Chispas de Chocolate', 'Galletas artesanales con chispas de chocolate semiamargo.', 25.00, 32, 'galletas_chispas.jpg', 'disponible'),
(3, 'Galletas Decoradas de Vainilla', 'Galletas de vainilla decoradas a mano con temática especial.', 30.00, 20, 'galletas_decoradas.jpg', 'disponible'),
(3, 'Galletas de Avena y Nuez', 'Galletas horneadas con avena natural y trozos de nuez.', 24.00, 26, 'galletas_avena_nuez.jpg', 'disponible'),
(3, 'Galletas Rellenas de Cajeta', 'Galletas suaves rellenas de cajeta cremosa.', 28.00, 22, 'galletas_cajeta.jpg', 'disponible'),

(4, 'Cupcake de Chocolate', 'Cupcake de chocolate con betún cremoso y decoración sencilla.', 35.00, 18, 'cupcake_chocolate.jpg', 'disponible'),
(4, 'Cupcake de Vainilla con Fresa', 'Cupcake de vainilla con topping de crema y fresa natural.', 38.00, 16, 'cupcake_vainilla_fresa.jpg', 'disponible'),
(4, 'Cupcake Red Velvet', 'Cupcake estilo red velvet con betún de queso crema.', 40.00, 15, 'cupcake_red_velvet.jpg', 'disponible'),
(4, 'Cupcake de Limón', 'Cupcake de limón con cobertura ligera y sabor fresco.', 36.00, 14, 'cupcake_limon.jpg', 'disponible'),

(5, 'Cheesecake de Frutos Rojos', 'Postre frío con base de galleta y cobertura de frutos rojos.', 65.00, 12, 'cheesecake_frutos_rojos.jpg', 'disponible'),
(5, 'Tiramisú Artesanal', 'Postre italiano con café, crema y cacao.', 70.00, 10, 'tiramisu_artesanal.jpg', 'disponible'),
(5, 'Mousse de Chocolate', 'Postre cremoso de chocolate con textura ligera.', 55.00, 15, 'mousse_chocolate.jpg', 'disponible'),
(5, 'Carlota de Limón', 'Postre frío de limón con capas de galleta y crema.', 50.00, 18, 'carlota_limon.jpg', 'disponible'),

(6, 'Café Latte', 'Bebida caliente preparada con espresso y leche vaporizada.', 45.00, 20, 'cafe_latte.jpg', 'disponible'),
(6, 'Chocolate Caliente', 'Bebida caliente de chocolate cremoso.', 42.00, 18, 'chocolate_caliente.jpg', 'disponible'),
(6, 'Frappé de Moka', 'Bebida fría sabor moka con crema batida.', 58.00, 14, 'frappe_moka.jpg', 'disponible'),
(6, 'Té Chai Helado', 'Bebida fría especiada con leche y hielo.', 50.00, 12, 'te_chai_helado.jpg', 'disponible'),

(7, 'Gelatina Mosaico', 'Gelatina colorida con cubos de diferentes sabores en base cremosa.', 35.00, 20, 'gelatina_mosaico.jpg', 'disponible'),
(7, 'Gelatina de Fresa con Crema', 'Gelatina sabor fresa con mezcla cremosa.', 32.00, 18, 'gelatina_fresa_crema.jpg', 'disponible'),

(8, 'Pay de Limón', 'Pay frío de limón con base crujiente de galleta.', 280.00, 6, 'pay_limon.jpg', 'disponible'),
(8, 'Pay de Nuez', 'Pay tradicional con relleno de nuez y textura suave.', 320.00, 5, 'pay_nuez.jpg', 'disponible'),

(9, 'Rosca de Canela Glaseada', 'Rosca suave con canela y glaseado dulce.', 260.00, 7, 'rosca_canela.jpg', 'disponible'),

(10, 'Cupcakes Navideños Decorados', 'Cupcakes decorados con temática navideña.', 45.00, 20, 'cupcakes_navidenos.jpg', 'disponible'),
(10, 'Rosca de Reyes', 'Rosca tradicional de temporada decorada con fruta cristalizada.', 380.00, 8, 'rosca_reyes.jpg', 'disponible'),
(10, 'Pan de Muerto', 'Pan tradicional de temporada con azúcar y aroma a azahar.', 35.00, 25, 'pan_muerto.jpg', 'disponible'),

(11, 'Pastel Pequeño Personalizado', 'Pastel personalizado para eventos pequeños, con diseño a elección del cliente.', 350.00, 10, 'pastel_pequeno_personalizado.jpg', 'disponible'),
(11, 'Pastel Mediano Personalizado', 'Pastel personalizado de tamaño mediano para celebraciones especiales.', 550.00, 8, 'pastel_mediano_personalizado.jpg', 'disponible'),
(11, 'Pastel Grande Personalizado', 'Pastel personalizado grande para eventos y reuniones familiares.', 750.00, 5, 'pastel_grande_personalizado.jpg', 'disponible'),
(11, 'Docena de Cupcakes Personalizados', 'Caja con 12 cupcakes decorados según la temática solicitada.', 420.00, 12, 'docena_cupcakes_personalizados.jpg', 'disponible'),
(11, 'Pastel de Cupcakes Personalizado', 'Arreglo de cupcakes diseñado en forma de pastel para eventos especiales.', 480.00, 7, 'pastel_cupcakes_personalizado.jpg', 'disponible');

SELECT * FROM empleados;
SELECT * FROM productos;