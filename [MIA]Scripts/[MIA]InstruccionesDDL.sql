USE MIA_Practica1;

SELECT * FROM DetalleCompras;
select * FROM DetalleOrdenes;
SELECT * FROM Compras; 
SELECT * FROM Ordenes;
SELECT * FROM CategoryProduct;
SELECT * FROM Cliente;
SELECT * FROM Proveedor; 
SELECT * FROM CodigoPostal;
SELECT * FROM Ciudad;
SELECT * FROM Region;
SELECT * FROM Product;
SELECT * FROM Company;

DELIMITER $$
CREATE PROCEDURE SP_CrearModeloPropuesto()
	BEGIN
		SET SQL_SAFE_UPDATES = 0;
		DELETE t1 from TablaTemporal t1 
		INNER JOIN TablaTemporal t2
		WHERE 
		t1.idTemporal < t2.idTemporal AND
		t1.nombre_compania = t2.nombre_compania AND
		t1.contacto_compania = t2.contacto_compania AND 
		t1.correo_compania = t2.correo_compania AND 
		t1.telefono_compania = t2.telefono_compania AND 
		t1.tipo = t2.tipo AND 
		t1.nombre = t2.nombre AND 
		t1.correo = t2.correo AND 
		t1.telefono = t2.telefono AND 
        t1.fecha_registro = t2.fecha_registro AND 
        t1.direccion = t2.direccion AND 
        t1.producto = t2.producto AND
        t1.ciudad = t2.ciudad  AND 
        t1.codigo_postal = t2.codigo_postal AND 
        t1.region = t2.region AND 
        t1.categoria_producto = t2.categoria_producto AND 
        t1.cantidad = t2.cantidad AND
        t1.precio_unitario = t2.precio_unitario		
        ;

		CREATE TABLE IF NOT EXISTS CodigoPostal(
			idCodigoPostal INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			codigoPostal BIGINT(10) NOT NULL
		);

		INSERT INTO CodigoPostal(codigoPostal)
		SELECT DISTINCT
		codigo_postal FROM TablaTemporal;
		
		CREATE TABLE IF NOT EXISTS Ciudad(
			idCiudad INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			ciudad VARCHAR(60) NOT NULL,
			idCodigoPostal INT NOT NULL,
			FOREIGN KEY (idCodigoPostal) REFERENCES CodigoPostal(idCodigoPostal)
			ON DELETE CASCADE 
			ON UPDATE CASCADE
		);

		INSERT INTO Ciudad(ciudad, idCodigoPostal)
		SELECT DISTINCT
		tm.ciudad, cp.idCodigoPostal FROM
		TablaTemporal tm, CodigoPostal cp
		WHERE tm.codigo_postal = cp.codigoPostal;

		CREATE TABLE IF NOT EXISTS Region(
			idRegion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			region VARCHAR(60) NOT NULL,
			idCiudad INT NOT NULL,
			FOREIGN KEY (idCiudad) REFERENCES Ciudad(idCiudad)
			ON DELETE CASCADE 
			ON UPDATE CASCADE
		);
		
		INSERT INTO Region(region, idCiudad) 
		SELECT DISTINCT
		tm.region, c.idCiudad FROM TablaTemporal tm, Ciudad c
		INNER JOIN CodigoPostal ON c.idCodigoPostal = CodigoPostal.idCodigoPostal
		WHERE tm.ciudad = c.ciudad AND
		tm.codigo_postal = CodigoPostal.codigoPostal; 

	

		CREATE TABLE IF NOT EXISTS Cliente(
		idCliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		_name varchar(200) not null,
		email varchar(200) not null,
		phone varchar(15) not null, 
		dateCreation datetime not null,
		address VARCHAR(200) NOT NULL,
		idRegion INT NOT NULL, 
		FOREIGN KEY (idRegion) REFERENCES Region(idRegion)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
		);

		INSERT INTO Cliente(_name, email, phone, dateCreation,address, idRegion) 
		SELECT DISTINCT tm.nombre, tm.correo, tm.telefono, tm.fecha_registro, tm.direccion	, r.idRegion from TablaTemporal tm, Region r 
		INNER JOIN Ciudad ON r.idCiudad = Ciudad.idCiudad
		INNER JOIN CodigoPostal ON Ciudad.idCodigoPostal = CodigoPostal.idCodigoPostal
		where tm.ciudad= Ciudad.ciudad AND 
        tm.codigo_postal = CodigoPostal.codigoPostal AND 
        tm.region = r.region AND 
		tm.tipo = 'C';

		CREATE TABLE IF NOT EXISTS Proveedor(
			idProveedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			_name varchar(200) not null,
			email varchar(200) not null,
			phone varchar(15) not null, 
			dateCreation datetime not null,
			address VARCHAR(200) NOT NULL,
			idRegion INT NOT NULL, 
			FOREIGN KEY (idRegion) REFERENCES Region(idRegion)
			ON DELETE CASCADE 
			ON UPDATE CASCADE
		);

		INSERT INTO Proveedor(_name, email, phone, dateCreation, address, idRegion) 
		SELECT DISTINCT tm.nombre, tm.correo, tm.telefono, tm.fecha_registro, tm.direccion, r.idRegion from TablaTemporal tm, Region r 
		INNER JOIN Ciudad ON r.idCiudad = Ciudad.idCiudad
		INNER JOIN CodigoPostal ON Ciudad.idCodigoPostal = CodigoPostal.idCodigoPostal
		where tm.ciudad= Ciudad.ciudad AND 
        tm.codigo_postal = CodigoPostal.codigoPostal AND 
        tm.region = r.region AND 
		tm.tipo = 'P';


		CREATE TABLE IF NOT EXISTS Company(
		idCompany INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		_nameC varchar(200) not null,
		contactC varchar(120) not null, 
		emailC varchar(200) not null,
		phoneC varchar(15) not null
		);

		INSERT INTO Company(_nameC,contactC,emailC,phoneC) 
		SELECt DISTINCT nombre_compania, contacto_compania, correo_compania, telefono_compania
		FROM TablaTemporal;
		

		CREATE TABLE IF NOT EXISTS Product(
		idProduct INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		producto varchar(80) not null
		);

		INSERT INTO Product(producto)
		SELECT DISTINCT tm.producto
		FROM TablaTemporal tm;

		CREATE TABLE IF NOT EXISTS CategoryProduct(
			idCategoryProduct INT NOT NUll AUTO_INCREMENT PRIMARY KEY,
			categoriaProducto VARCHAR(200) NOT NULL
		);

		INSERT INTO CategoryProduct(categoriaProducto)
		SELECT DISTINCT tm.categoria_producto
		FROM TablaTemporal tm;

		CREATE TABLE IF NOT EXISTS Compras(
			idCompras INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			cantidad INT NOT NULL,
			idCategoryProduct INT NOT NULL,
			idProduct INT NOT NULL,
			FOREIGN KEY (idCategoryProduct) REFERENCES CategoryProduct(idCategoryProduct)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
			FOREIGN KEY (idProduct) REFERENCES Product(idProduct)
			ON DELETE CASCADE
			ON UPDATE CASCADE
		);
		INSERT INTO Compras(cantidad,idCategoryProduct,idProduct) 
		SELECT DISTINCT tm.cantidad, cp.idCategoryProduct, pr.idProduct
		FROM TablaTemporal tm, CategoryProduct cp, Product pr
		WHERE tm.categoria_producto = cp.categoriaProducto AND
		tm.producto = pr.producto AND 
		tm.tipo = 'C';

		CREATE TABLE IF NOT EXISTS DetalleCompras(
			idDetalleCompras INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			idCliente INT NOT NULL,
			idCompany INT NOT NULL,
			idCompras INT NOT NULL,
			precio DOUBLE NOT NULL,
			FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
			FOREIGN KEY (idCompany) REFERENCES Company(idCompany)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
			FOREIGN KEY (idCompras) REFERENCES Compras(idCompras)
			ON DELETE CASCADE
			ON UPDATE CASCADE
		);

		INSERT INTO DetalleCompras(idCliente, idCompany, idCompras,precio)
		SELECT DISTINCT c.idCliente, com.idCompany, cr.idCompras, tm.precio_unitario
		FROM TablaTemporal tm, Cliente c, Company com, Compras cr
		INNER JOIN Product ON cr.idProduct = Product.idProduct
		INNER JOIN CategoryProduct ON cr.idCategoryProduct = CategoryProduct.idCategoryProduct
		WHERE tm.nombre =  c._name AND
		tm.correo = c.email  AND
		tm.telefono = c.phone AND
		tm.fecha_registro = c.dateCreation  AND
		tm.nombre_compania = com._nameC AND
		tm.contacto_compania = com.contactC AND
		tm.correo_compania = com.emailC AND
		tm.telefono_compania  = com.phoneC AND
		tm.cantidad = cr.cantidad AND
		tm.producto = Product.producto AND
		tm.categoria_producto = CategoryProduct.categoriaProducto;

		CREATE TABLE IF NOT EXISTS Ordenes(
			idOrdenes INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			cantidad INT NOT NULL,
			idCategoryProduct INT NOT NULL,
			idProduct INT NOT NULL,
			FOREIGN KEY (idCategoryProduct) REFERENCES CategoryProduct(idCategoryProduct)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
			FOREIGN KEY (idProduct) REFERENCES Product(idProduct)
			ON DELETE CASCADE
			ON UPDATE CASCADE
		);

		INSERT INTO Ordenes(cantidad,idCategoryProduct,idProduct) 
		SELECT DISTINCT tm.cantidad, cp.idCategoryProduct, pr.idProduct
		FROM TablaTemporal tm, CategoryProduct cp, Product pr
		WHERE tm.categoria_producto = cp.categoriaProducto AND
		tm.producto = pr.producto AND 
		tm.tipo = 'P';

		CREATE TABLE IF NOT EXISTS DetalleOrdenes(
			idDetalleOrdenes INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			idProveedor INT NOT NULL,
			idCompany INT NOT NULL,
			idOrdenes INT NOT NULL,
			precio DOUBLE NOT NULL,
			FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
			FOREIGN KEY (idCompany) REFERENCES Company(idCompany)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
			FOREIGN KEY (idOrdenes) REFERENCES Ordenes(idOrdenes)
			ON DELETE CASCADE
			ON UPDATE CASCADE
		);

		INSERT INTO DetalleOrdenes(idProveedor, idCompany, idOrdenes,precio)
		SELECT  p.idProveedor, com.idCompany, cr.idOrdenes, tm.precio_unitario
		FROM TablaTemporal tm, Proveedor p, Company com, Ordenes cr
		INNER JOIN Product ON cr.idProduct = Product.idProduct
		INNER JOIN CategoryProduct ON cr.idCategoryProduct = CategoryProduct.idCategoryProduct
		WHERE tm.nombre =  p._name AND
		tm.correo = p.email  AND
		tm.telefono = p.phone AND
		tm.fecha_registro = p.dateCreation  AND
		tm.nombre_compania = com._nameC AND
		tm.contacto_compania = com.contactC AND
		tm.correo_compania = com.emailC AND
		tm.telefono_compania  = com.phoneC AND
		tm.cantidad = cr.cantidad AND
		tm.producto = Product.producto AND
		tm.categoria_producto = CategoryProduct.categoriaProducto;

    END;
$$

CALL SP_CrearModeloPropuesto();
DELIMITER $$
CREATE PROCEDURE SP_EliminarModeloPropuesto()
	BEGIN
	
	DROP TABLE IF EXISTS DetalleCompras;
	DROP TABLE IF EXISTS DetalleOrdenes;
	DROP TABLE IF EXISTS Compras;
	DROP TABLE IF EXISTS Ordenes;
	DROP TABLE IF EXISTS CategoryProduct;
	DROP TABLE IF EXISTS Product;
	DROP TABLE IF exists Cliente;
	DROP TABLE IF EXISTS Proveedor;
	DROP TABLE IF EXISTS Company;
	DROP TABLE IF EXISTS Region;
    DROP TABLE IF EXISTS Ciudad;
    DROP TABLE IF EXISTS CodigoPostal;
	END;
$$
