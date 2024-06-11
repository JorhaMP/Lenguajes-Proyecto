-- Crear una base de datos nueva
CREATE DATABASE Proyecto;
GO

USE Proyecto;
GO

/*DATOS:
Usuarios: Información de los usuarios.
Roles: Definir los roles de los usuarios (administradores, vendedores, clientes).
Productos: Información de los productos.
Categorías: Categorizar de productos.
Órdenes: Almacenar las órdenes de compra.
Detalles de Órdenes: Detallar los productos dentro de cada orden.
Carrito de Compras: Productos que los clientes agregan al carrito.
Direcciones: Almacenar las direcciones de entrega de los clientes.
Pagos: Almacenar información de pagos.
Ventas: Almacenar registros de ventas.
*/

-- Tabla para roles
CREATE TABLE Roles (
    RolID INT PRIMARY KEY IDENTITY,
    Nombre VARCHAR(50) NOT NULL UNIQUE
);
GO

-- Tabla de usuarios
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Contrasena VARCHAR(255) NOT NULL,
    RolID INT,
    CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (RolID) REFERENCES Roles(RolID)
);
GO

--Tabla de direcciones
CREATE TABLE Direcciones (
    DireccionID INT PRIMARY KEY IDENTITY,
    UsuarioID INT,
    Direccion VARCHAR(255) NOT NULL,
    Ciudad VARCHAR(100) NOT NULL,
    Estado VARCHAR(100) NOT NULL,
    CodigoPostal VARCHAR(10) NOT NULL,
    Pais VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Direcciones_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
GO

-- Tabla de categorias
CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY,
    Nombre VARCHAR(50) NOT NULL UNIQUE
);
GO

--Tabla de productos
CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY,
    Codigo VARCHAR(50) NOT NULL UNIQUE,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Cantidad INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    CategoriaID INT,
    ImagenURL VARCHAR(255),
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);
GO

--Tabla de ordenes
CREATE TABLE Ordenes (
    OrdenID INT PRIMARY KEY IDENTITY,
    UsuarioID INT,
    FechaOrden DATETIME NOT NULL DEFAULT GETDATE(),
    Total DECIMAL(10, 2) NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    DireccionID INT,
    CONSTRAINT FK_Ordenes_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    CONSTRAINT FK_Ordenes_Direcciones FOREIGN KEY (DireccionID) REFERENCES Direcciones(DireccionID)
);
GO

--Tabla de detalles de orden
CREATE TABLE DetallesOrdenes (
    DetalleID INT PRIMARY KEY IDENTITY,
    OrdenID INT,
    ProductoID INT,
    Cantidad INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_DetallesOrdenes_Ordenes FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID),
    CONSTRAINT FK_DetallesOrdenes_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
GO

-- Tabla del carrito
CREATE TABLE CarritoCompras (
    CarritoID INT PRIMARY KEY IDENTITY,
    UsuarioID INT,
    ProductoID INT,
    Cantidad INT NOT NULL,
    CONSTRAINT FK_CarritoCompras_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    CONSTRAINT FK_CarritoCompras_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
GO

--Tabla de pagos
CREATE TABLE Pagos (
    PagoID INT PRIMARY KEY IDENTITY,
    OrdenID INT,
    Monto DECIMAL(10, 2) NOT NULL,
    FechaPago DATETIME NOT NULL DEFAULT GETDATE(),
    MetodoPago VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Pagos_Ordenes FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID)
);
GO

--Tabla de ventas
CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY IDENTITY,
    OrdenID INT,
    UsuarioID INT,
    FechaVenta DATETIME NOT NULL DEFAULT GETDATE(),
    Monto DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Ventas_Ordenes FOREIGN KEY (OrdenID) REFERENCES Ordenes(OrdenID),
    CONSTRAINT FK_Ventas_Usuarios FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
GO

-- Inserta información base/ejemplo

INSERT INTO Roles (Nombre) VALUES ('Administrador');
GO
INSERT INTO Roles (Nombre) VALUES ('Vendedor');
GO
INSERT INTO Roles (Nombre) VALUES ('Cliente');
GO

INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasena, RolID) VALUES 
('Iker', 'Fallas', 'iker.fallas@gmail.com', '123', 1),
('Fabiola', 'Vargas', 'fabiola.vargas@gmail.com', '456', 2),
('Gabriel', 'Guzman', 'gabriel.guzman@gmail.com', '789', 3);
GO

INSERT INTO Categorias (Nombre) VALUES ('Frutas');
GO
INSERT INTO Categorias (Nombre) VALUES ('Verduras');
GO

INSERT INTO Productos (Codigo, Nombre, Descripcion, Cantidad, Precio, CategoriaID, ImagenURL) VALUES
('FR001', 'Manzana', 'Manzana roja fresca', 50, 0.50, 1, 'images/manzana.jpg'),
('VE001', 'Zanahoria', 'Zanahoria orgánica', 25, 0.30, 2, 'images/zanahoria.jpg');
GO

INSERT INTO Direcciones (UsuarioID, Direccion, Ciudad, Estado, CodigoPostal, Pais) VALUES
(3, '123 Calle Principal', 'Ciudad Ejemplo', 'Estado Ejemplo', '12345', 'País Ejemplo');
GO

INSERT INTO Ordenes (UsuarioID, Total, Estado, DireccionID) VALUES
(3, 11, 'En proceso', 1);
GO

INSERT INTO DetallesOrdenes (OrdenID, ProductoID, Cantidad, Precio) VALUES
(1, 1, 10, 0.50),
(1, 2, 20, 0.30);
GO

INSERT INTO CarritoCompras (UsuarioID, ProductoID, Cantidad) VALUES
(3, 1, 5),
(3, 2, 3);
GO

INSERT INTO Pagos (OrdenID, Monto, MetodoPago) VALUES
(1, 11, 'Tarjeta de Crédito');
GO

INSERT INTO Ventas (OrdenID, UsuarioID, Monto) VALUES
(1, 3, 11);
GO