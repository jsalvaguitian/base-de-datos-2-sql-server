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

/* EJERCICIO N°3
Listar los productos cuya descripción comience con D*/
SELECT Name AS Descripcion
FROM Production.Product
WHERE Name LIKE 'D%';

/*EJERCICIO N°4
Listar las descripciones de los productos cuyo número finalice
con 8 */
SELECT Name AS Descripcion
FROM Production.Product
WHERE ProductNumber LIKE '%8';

/*EJERCICIO N°5
Listar aquellos productos que posean un color asignado. Se
deberán excluir todos aquellos que no posean ningún valor*/

SELECT *
FROM Production.Product
WHERE Color IS NOT NULL;

/*EJERCICIO N°6
Listar el código y descripción de los productos de color Black
(Negro) y que posean el nivel de stock en 500.*/

SELECT ProductNumber AS Codigo, Name AS Descripcion
FROM Production.Product
WHERE Color = 'Black' AND  SafetyStockLevel = 500;


/*EJERCICIO N°7
Listar los productos que sean de color Black (Negro) ó Silver
(Plateado).*/
/*Opcion 1*/
SELECT *
FROM Production.Product
WHERE Color = 'Black' OR Color = 'Silver';

/*Opcion 2*/
SELECT *
FROM Production.Product
WHERE Color IN ('Black', 'Silver');


/*EJERCICIO N°8 
Listar los diferentes colores que posean asignados los
productos. Sólo se deben listar los colores.*/
SELECT DISTINCT Color
FROM Production.Product;

/*EJERCICIO N°9
Contar la cantidad de categorías que se encuentren cargadas
en la base. (Ayuda: count)*/
SELECT COUNT(*) AS CantidadCategorias
FROM Production.ProductCategory;

/*EJERCICIO N°10
Contar la cantidad de subcategorías que posee asignada la
categoría 2.*/
SELECT COUNT(*) AS CantidadSubcategoria
FROM Production.ProductSubcategory
WHERE ProductCategoryID= 2;

/*EJERCICIO N°11
Listar la cantidad de productos que existan por cada uno de los
colores.*/
SELECT Color, COUNT(*) AS CantidadProducto
FROM Production.Product
GROUP BY Color;

/*EJERCICIO N°12 
Sumar todos los niveles de stocks aceptables que deben existir
para los productos con color Black. (Ayuda: sum)*/
SELECT SUM(SafetyStockLevel) AS SumaStockAceptables
FROM Production.Product
WHERE Color = 'Black';

/*13- Calcular el promedio de stock que se debe tener de todos los
productos cuyo código se encuentre entre el 316 y 320.
(Ayuda: avg)
14- Listar el nombre del producto y descripción de la subcategoría
que posea asignada. (Ayuda: inner join)
15- Listar todas las categorías que poseen asignado al menos una
subcategoría. Se deberán excluir aquellas que no posean
ninguna.
16- Listar el código y descripción de los productos que posean fotos
asignadas. (Ayuda: Production.ProductPhoto)
17- Listar la cantidad de productos que existan por cada una de las
Clases (Ayuda: campo Class)
18- Listar la descripción de los productos y su respectivo color. Sólo
nos interesa caracterizar al color con los valores: Black, Silver
u Otro. Por lo cual si no es ni silver ni black se debe indicar
Otro. (Ayuda: utilizar case).
Listar el nombre de la categoría, el nombre de la subcategoría
y la descripción del producto. (Ayuda: join)
20- Listar la cantidad de subcategorías que posean asignado los
productos. (Ayuda: distinct).*/
