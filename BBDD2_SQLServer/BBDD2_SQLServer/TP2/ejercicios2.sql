/*
	TRABAJO PRACTICO N°2
	Alumna: Jesica Belen Salva

	Temas:
	- Insert /Delete /Update
	- Inner Join / Left Join / Right Join / Full Join / Cross Join
	- Exists / In / not exists / not in
	- Group by / Having

*/

/*EJERCICIO N°1 
Listar los nombres de los productos y el nombre del modelo
que posee asignado. Solo listar aquellos que tengan asignado
algún modelo.
*/
SELECT p.Name AS Nombre, m.Name AS Modelo
FROM Production.Product p
INNER JOIN Production.ProductModel m
ON p.ProductModelID = m.ProductModelID;

/*----------------------------------------------------------*/

/*EJERCICIO N°2
Mostrar “todos” los productos junto con el modelo que tenga
asignado. En el caso que no tenga asignado ningún modelo,
mostrar su nulidad.
*/
SELECT p.Name AS Producto, m.Name AS Modelo
FROM Production.Product p
LEFT JOIN Production.ProductModel m
ON p.ProductModelID = m.ProductModelID;

/*----------------------------------------------------------*/

/*EJERCICIO N°3
Ídem Ejercicio2, pero en lugar de mostrar nulidad, mostrar la
palabra “Sin Modelo” para indicar que el producto no posee un
modelo asignado.
*/
SELECT p.Name AS Producto,
    ISNULL(m.Name, 'Sin Modelo') AS Modelo
FROM Production.Product p
LEFT JOIN Production.ProductModel m
    ON p.ProductModelID = m.ProductModelID;

/*----------------------------------------------------------*/

/*EJERCICIO N°4
Contar la cantidad de Productos que poseen asignado cada
uno de los modelos.
*/
SELECT m.Name AS Modelo,
COUNT(*) AS CantidadProducto
FROM Production.Product p
INNER JOIN Production.ProductModel m
ON p.ProductModelID = m.ProductModelID
GROUP BY m.Name;

/*----------------------------------------------------------*/

/*EJERCICIO N°5
Contar la cantidad de Productos que poseen asignado cada
uno de los modelos, pero mostrar solo aquellos modelos que
posean asignados 2 o más productos.
*/
SELECT m.Name AS Modelo,
COUNT(*) AS CantidadProducto
FROM Production.Product p
INNER JOIN Production.ProductModel m
ON p.ProductModelID = m.ProductModelID
GROUP BY m.Name
HAVING COUNT(*)>=2;

/*----------------------------------------------------------*/

/*EJERCICIO N°6
Contar la cantidad de Productos que poseen asignado un
modelo valido, es decir, que se encuentre cargado en la tabla
de modelos. Realizar este ejercicio de 3 formas posibles:
“exists” / “in” / “inner join”.*/

/*Opcion 1: Inner join*/
SELECT COUNT(*) AS CantidadProductos
FROM Production.Product p 
INNER JOIN Production.ProductModel m
ON p.ProductModelID = m.ProductModelID;

/*Opcion 2:In*/
select count(*) as cantidadProductos
from Production.Product
where ProductModelID in(
select ProductModelID
from Production.ProductModel);

/*Opcion 3: Exists*/
SELECT COUNT(*) AS CantidadProductos
FROM Production.Product p
WHERE EXISTS (
    SELECT *
    FROM Production.ProductModel pm
    WHERE pm.ProductModelID = p.ProductModelID
);

/*----------------------------------------------------------*/

/*EJERCICIO N°7
Contar cuantos productos poseen asignado cada uno de los
modelos, es decir, se quiere visualizar el nombre del modelo y
la cantidad de productos asignados. Si algún modelo no posee
asignado ningún producto, se quiere visualizar 0 (cero).
*/
SELECT m.Name AS Modelo,
    COUNT(p.ProductID) AS CantidadProductos
FROM Production.ProductModel m
LEFT JOIN Production.Product p
    ON m.ProductModelID = p.ProductModelID
GROUP BY m.Name;
/*----------------------------------------------------------*/

/*EJERCICIO N°8
Se quiere visualizar, el nombre del producto, el nombre
modelo que posee asignado, la ilustración que posee asignada
y la fecha de última modificación de dicha ilustración y el
diagrama que tiene asignado la ilustración. Solo nos interesan
los productos que cuesten más de $150 y que posean algún
color asignado.
*/

SELECT 
    p.Name AS NombreProducto,
    pm.Name AS NombreModelo,
    i.IllustrationID AS Ilustracion,
    i.ModifiedDate AS FechaModificacion,
    i.Diagram
FROM Production.Product p
INNER JOIN Production.ProductModel pm
    ON p.ProductModelID = pm.ProductModelID
INNER JOIN Production.ProductModelIllustration pmi
    ON pm.ProductModelID = pmi.ProductModelID
INNER JOIN Production.Illustration i
    ON pmi.IllustrationID = i.IllustrationID
WHERE p.ListPrice > 150
AND p.Color IS NOT NULL;
/*----------------------------------------------------------*/


/*EJERCICIO N°9
Mostrar aquellas culturas que no están asignadas a ningún
producto/modelo.
(Production.ProductModelProductDescriptionCulture)
*/
SELECT 
    c.CultureID,
    c.Name
FROM Production.Culture c
WHERE NOT EXISTS (
    SELECT *
    FROM Production.ProductModelProductDescriptionCulture pmpdc
    WHERE pmpdc.CultureID = c.CultureID
);
/*----------------------------------------------------------*/


/*EJERCICIO N°10
Agregar a la base de datos el tipo de contacto “Ejecutivo de
Cuentas” (Person.ContactType)
*/
INSERT INTO Person.ContactType (Name, ModifiedDate)
VALUES ('Ejecutivo de Cuentas', GETDATE());
/*----------------------------------------------------------*/


/*EJERCICIO N°11
Agregar la cultura llamada “nn” – “Cultura Moderna”.
*/
INSERT INTO Production.Culture (CultureID, Name, ModifiedDate)
VALUES ('nn', 'Cultura Moderna', GETDATE());
/*----------------------------------------------------------*/


/*EJERCICIO N°12
Cambiar la fecha de modificación de las culturas Spanish,
French y Thai para indicar que fueron modificadas hoy.
*/
UPDATE Production.Culture
SET ModifiedDate = GETDATE()
WHERE Name IN ('Spanish', 'French', 'Thai');
/*----------------------------------------------------------*/

/*EJERCICIO N°13
En la tabla Production.CultureHis agregar todas las culturas
que fueron modificadas hoy. (Insert/Select).
*/
SELECT *
INTO Production.CultureHis
FROM Production.Culture
WHERE 1 = 0;

INSERT INTO Production.CultureHis
SELECT *
FROM Production.Culture
WHERE CAST(ModifiedDate AS DATE) = CAST(GETDATE() AS DATE);
/*----------------------------------------------------------*/

/*EJERCICIO N°14
Al contacto con ID 10 colocarle como nombre “Juan Perez”.
*/
UPDATE Person.Person
SET FirstName = 'Juan',
    LastName = 'Perez'
WHERE BusinessEntityID = 10;
/*----------------------------------------------------------*/

/*EJERCICIO N°15
Agregar la moneda “Peso Argentino” con el código “PAR”
(Sales.Currency)
*/
INSERT INTO Sales.Currency (CurrencyCode, Name, ModifiedDate)
VALUES ('PAR', 'Peso Argentino', GETDATE());
/*----------------------------------------------------------*/

/*EJERCICIO N°16
¿Qué sucede si tratamos de eliminar el código ARS
correspondiente al Peso Argentino? ¿Por qué?
*/
/*Si tratamos eliminar el codigo ARS no nos permitira SQL server porque hay registros relacionados con
claves foraneas*/
/*----------------------------------------------------------*/

/*EJERCICIO N°17
Realice los borrados necesarios para que nos permita eliminar
el registro de la moneda con código ARS.
*/
DELETE FROM Sales.CountryRegionCurrency
WHERE CurrencyCode = 'ARS';

DELETE FROM Sales.CurrencyRate
WHERE FromCurrencyCode = 'ARS'
   OR ToCurrencyCode = 'ARS';

DELETE FROM Sales.Currency
WHERE CurrencyCode = 'ARS';
/*----------------------------------------------------------*/

/*EJERCICIO N°18
 Eliminar aquellas culturas que no estén asignadas a ningún
producto (Production.ProductModelProductDescriptionCulture)
*/
DELETE FROM Production.Culture
WHERE NOT EXISTS (
    SELECT *
    FROM Production.ProductModelProductDescriptionCulture pmpdc
    WHERE pmpdc.CultureID = Production.Culture.CultureID
);
/*----------------------------------------------------------*/







