USE MIA_Practica1;

DELIMITER $$
    CREATE PROCEDURE SP_Consulta1()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        SELECT Proveedor._name as PROVEEDOR, Proveedor.phone as Telefono, Ordenes.idOrdenes as Orden,
        ROUND(SUM(Ordenes.cantidad*precio),2) as Total  FROM DetalleOrdenes
        INNER JOIN Ordenes ON DetalleOrdenes.idOrdenes = Ordenes.idOrdenes
        INNER JOIN Company ON DetalleOrdenes.idCompany = Company.idCompany
        INNER JOIN Proveedor ON DetalleOrdenes.idProveedor = Proveedor.idProveedor
        GROUP BY PROVEEDOR, Company._nameC
        ORDER BY Total DESC LIMIT 10; 
    END;
$$

DELIMITER $$
    CREATE PROCEDURE SP_Consulta2()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        SELECT Cliente.idCliente AS 'No. Cliente', Cliente._name as CLIENTE, SUM(Compras.cantidad)  as Total
        FROM DetalleCompras
        INNER JOIN Compras ON DetalleCompras.idCompras = Compras.idCompras
        INNER JOIN Company ON DetalleCompras.idCompany = Company.idCompany
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        GROUP BY CLIENTE
        ORDER BY Total DESC LIMIT 10;
    END;
$$

DELIMITER $$
    CREATE PROCEDURE SP_Consulta3()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        
        
        
        (SELECT Ubicacion.Direccion, Ubicacion.region, Ubicacion.Ciudad, Ubicacion.CodigoPostal,
        COUNT(Ubicacion.CodigoPostal) AS Total FROM
        
        (SELECT Proveedor.dateCreation AS Fecha, Company._nameC AS Nombre, Proveedor.address AS Direccion, Region.region AS Region, 
        Ciudad.ciudad AS Ciudad, CodigoPostal.codigoPostal AS CodigoPostal, COUNT(Proveedor.address) AS ResidenciasTotales
        FROM DetalleOrdenes
        INNER JOIN Ordenes ON DetalleOrdenes.idOrdenes = Ordenes.idOrdenes
        INNER JOIN Proveedor ON DetalleOrdenes.idProveedor = Proveedor.idProveedor
        INNER JOIN Company ON DetalleOrdenes.idCompany = Company.idCompany
        INNER JOIN Region ON Region.idRegion = Proveedor.idRegion
        INNER JOIN Ciudad ON Region.idCiudad = Ciudad.idCiudad
        INNER JOIN CodigoPostal ON Ciudad.idCodigoPostal = CodigoPostal.idCodigoPostal
        GROUP BY Proveedor.dateCreation, Company._nameC, Direccion, Region, Ciudad, CodigoPostal
        ORDER BY ResidenciasTotales DESC) as Ubicacion
		
        GROUP BY Ubicacion.Direccion, Ubicacion.Region, Ubicacion.Ciudad, Ubicacion.CodigoPostal
        ORDER BY Total DESC LIMIT 5)
        
        UNION 
        
       (SELECT Ubicacion.Direccion, Ubicacion.region, Ubicacion.Ciudad, Ubicacion.CodigoPostal,
        COUNT(Ubicacion.CodigoPostal) AS Total FROM
        
        (SELECT Proveedor.dateCreation AS Fecha, Company._nameC AS Nombre, Proveedor.address AS Direccion, Region.region AS Region, 
        Ciudad.ciudad AS Ciudad, CodigoPostal.codigoPostal AS CodigoPostal, COUNT(Proveedor.address) AS ResidenciasTotales
        FROM DetalleOrdenes
        INNER JOIN Ordenes ON DetalleOrdenes.idOrdenes = Ordenes.idOrdenes
        INNER JOIN Proveedor ON DetalleOrdenes.idProveedor = Proveedor.idProveedor
        INNER JOIN Company ON DetalleOrdenes.idCompany = Company.idCompany
        INNER JOIN Region ON Region.idRegion = Proveedor.idRegion
        INNER JOIN Ciudad ON Region.idCiudad = Ciudad.idCiudad
        INNER JOIN CodigoPostal ON Ciudad.idCodigoPostal = CodigoPostal.idCodigoPostal
        GROUP BY Proveedor.dateCreation, Company._nameC, Direccion, Region, Ciudad, CodigoPostal
        ORDER BY ResidenciasTotales DESC) as Ubicacion
		
        GROUP BY Ubicacion.Direccion, Ubicacion.Region, Ubicacion.Ciudad, Ubicacion.CodigoPostal
        ORDER BY Total ASC LIMIT 5);
        
    END;
$$


DELIMITER $$
	CREATE PROCEDURE SP_Consulta4()
    BEGIN
    SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
    
    SELECT queryaux.idCliente, queryaux._name, COUNT(queryaux._name) as Total_Orders, SUM(queryaux.total) as TotalPercio, SUM(queryaux.Cantidad) as TotalCantidad FROM 
	
    (SELECT Company._nameC, Cliente.dateCreation, Cliente.idCliente, Cliente._name, CategoryProduct.categoriaProducto,
	round((Compras.cantidad*precio),2) as total, SUM(Compras.cantidad) as Cantidad
	FROM DetalleCompras
	INNER JOIN Compras ON DetalleCompras.idCompras = Compras.idCompras
	INNER JOIN Product ON Compras.idProduct = Product.idProduct
	INNER JOIN CategoryProduct ON Compras.idCategoryProduct = CategoryProduct.idCategoryProduct
	INNER JOIN Company ON DetalleCompras.idCompany = Company.idCompany
	INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
	WHERE CategoryProduct.categoriaProducto = 'Cheese'
	GROUP BY Company._nameC, Cliente.dateCreation, Cliente.idCliente, Cliente._name, CategoryProduct.categoriaProducto
	ORDER BY total DESC) as queryaux 
	
    GROUP BY queryaux.idCliente, queryaux._name
	ORDER BY TotalCantidad DESC LIMIT 5;
    END;
$$




DELIMITER $$
    CREATE PROCEDURE SP_Consulta5()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        (SELECT EXTRACT(MONTH FROM Cliente.dateCreation) AS Mes, Cliente._name as CLIENTE, Count(*) as Cantidad
        FROM DetalleCompras
        INNER JOIN Company ON DetalleCompras.idCompany = Company.idCompany
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        GROUP BY Mes, Cliente
        ORDER BY Cantidad DESC LIMIT 5)
        UNION
        (SELECT EXTRACT(MONTH FROM Cliente.dateCreation) AS Mes, Cliente._name as CLIENTE, Count(*) as Cantidad
        FROM DetalleCompras
        INNER JOIN Company ON DetalleCompras.idCompany = Company.idCompany
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        GROUP BY Mes, Cliente
        ORDER BY Cantidad ASC LIMIT 5);
    END;
$$


DELIMITER $$
    CREATE PROCEDURE SP_Consulta6()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        (SELECT CategoryProduct.categoriaProducto as Category, ROUND(SUM(Compras.cantidad*precio),2) as Total
        FROM DetalleCompras
        INNER JOIN Compras ON DetalleCompras.idCompras = Compras.idCompras
	    INNER JOIN CategoryProduct ON Compras.idCategoryProduct = CategoryProduct.idCategoryProduct
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        GROUP BY Category
        ORDER BY Total DESC LIMIT 5)
        UNION
        (SELECT CategoryProduct.categoriaProducto as Category, ROUND(SUM(Compras.cantidad*precio),2) as Total
        FROM DetalleCompras
        INNER JOIN Compras ON DetalleCompras.idCompras = Compras.idCompras
	    INNER JOIN CategoryProduct ON Compras.idCategoryProduct = CategoryProduct.idCategoryProduct
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        GROUP BY Category
        ORDER BY Total ASC LIMIT 5)
        ;
    END;
$$

DELIMITER $$
    CREATE PROCEDURE SP_Consulta7()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        SELECT Proveedor._name as PROVEEDOR, Proveedor.email, Proveedor.address as Direccion, ROUND(SUM(Ordenes.cantidad*precio),2) as Total
        FROM DetalleOrdenes
        INNER JOIN Ordenes ON DetalleOrdenes.idOrdenes = Ordenes.idOrdenes
        INNER JOIN CategoryProduct ON Ordenes.idCategoryProduct = CategoryProduct.idCategoryProduct
        INNER JOIN Proveedor ON DetalleOrdenes.idProveedor = Proveedor.idProveedor
        WHERE CategoryProduct.categoriaProducto = 'Fresh Vegetables'
        GROUP BY Proveedor
        ORDER BY Total DESC LIMIT 5;
    END;
$$


DELIMITER $$
    CREATE PROCEDURE SP_Consulta8()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        (SELECT Cliente._name, Region.region, Ciudad.ciudad, CodigoPostal.codigoPostal, 
        ROUND(SUM(Compras.cantidad*precio),2) as Total 
        FROM DetalleCompras
        INNER JOIN Compras ON DetalleCompras.idCompras = Compras.idCompras
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        INNER JOIN Region ON Cliente.idRegion = Region.idRegion
        INNER JOIN Ciudad ON Region.idCiudad = Ciudad.idCiudad
        INNER JOIN CodigoPostal ON Ciudad.idCodigoPostal = CodigoPostal.idCodigoPostal
        GROUP BY Cliente._name
        ORDER BY Total DESC LIMIT 5)
        UNION
        (SELECT Cliente._name,Region.region, Ciudad.ciudad, CodigoPostal.codigoPostal, 
        ROUND(SUM(Compras.cantidad*precio),2) as Total 
        FROM DetalleCompras
        INNER JOIN Compras ON DetalleCompras.idCompras = Compras.idCompras
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        INNER JOIN Region ON Cliente.idRegion = Region.idRegion
        INNER JOIN Ciudad ON Region.idCiudad = Ciudad.idCiudad
        INNER JOIN CodigoPostal ON Ciudad.idCodigoPostal = CodigoPostal.idCodigoPostal
        GROUP BY Cliente._name
        ORDER BY Total ASC LIMIT 5);
    END;
$$

DELIMITER $$
    CREATE PROCEDURE SP_Consulta9()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
		SELECT  Pedidos.idDetalleOrdenes, Pedidos.dateCreation, Pedidos._name, Pedidos.phone, Pedidos.cantidad, Pedidos.Total
		FROM 
		(SELECT Proveedor._name, idDetalleOrdenes, Proveedor.dateCreation, Proveedor.phone, Company._nameC, COUNT(Proveedor.dateCreation) as TiempoTotal, Ordenes.cantidad, ROUND(SUM(Ordenes.cantidad*precio),2) as Total
		FROM DetalleOrdenes 
		INNER JOIN Ordenes ON DetalleOrdenes.idOrdenes = Ordenes.idOrdenes
		INNER JOIN Proveedor ON DetalleOrdenes.idProveedor = Proveedor.idProveedor
		INNER JOIN Company ON DetalleOrdenes.idCompany = Company.idCompany
		GROUP BY Proveedor.dateCreation, Proveedor._name, Proveedor.phone, Company._nameC
		ORDER BY TiempoTotal ASC) as Pedidos
		ORDER BY Pedidos.cantidad LIMIT 12;
    END;
$$




DELIMITER $$
    CREATE PROCEDURE SP_Consulta10()
    BEGIN
        SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
        SELECT Cliente._name as CLIENTE, Cliente.email AS Correo, Cliente.phone as Telefono, Cliente.dateCreation as Fecha, Cliente.address as Direccion,
        SUM(Compras.cantidad) cantidadTotal,
        COUNT(*) as CantidadProductosComprados
        FROM DetalleCompras
        INNER JOIN Compras ON DetalleCompras.idCompras = Compras.idCompras
        INNER JOIN CategoryProduct ON Compras.idCategoryProduct = CategoryProduct.idCategoryProduct
        INNER JOIN Cliente ON DetalleCompras.idCliente = Cliente.idCliente
        WHERE CategoryProduct.categoriaProducto = 'Seafood'
        GROUP BY CLIENTE
        ORDER BY cantidadTotal DESC LIMIT 10;
    END;
$$



CALL SP_Consulta1();
CALL SP_Consulta2();
CALL SP_Consulta3();
CALL SP_Consulta4();
CALL SP_Consulta5();
CALL SP_Consulta6();
CALL SP_Consulta7();
CALL SP_Consulta8();
CALL SP_Consulta9();
CALL SP_Consulta10();