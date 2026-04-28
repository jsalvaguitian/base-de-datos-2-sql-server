/* EJERCICIO N°1
Listar los códigos y descripciones de todos los productos
*/
SELECT	ProductNumber AS Codigo,
		Name AS Descripcion
FROM Production.Product;

/* EJERCICIO N°2
Listar los datos de la subcategoría número 17 (Ayuda: Production.ProductSubCategory)
*/
SELECT *
FROM Production.ProductSubcategory
WHERE ProductSubcategoryID = 17;
