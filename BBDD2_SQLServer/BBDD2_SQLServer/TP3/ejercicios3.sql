/*Verifico la direccion de los archivos de todas las bbdd*/
SELECT name, physical_name
FROM sys.master_files;

/*
1. Realizar una consulta que permita devolver la fecha y hora actual
*/
SELECT GETDATE() AS FechaHoraActual;

/*2. Realizar una consulta que permita devolver únicamente el año y mes actual:
Año Mes
2010 6
*/
SELECT 
YEAR(GETDATE()) AS Año,
MONTH(GETDATE()) AS Mes;
/*
3. Realizar una consulta que permita saber cuántos días faltan para el día de la
primavera (21-Sep) (o el dia del estudiante xD)
*/
SELECT
DATEDIFF(
	DAY,
	GETDATE(),
	DATEFROMPARTS(YEAR(GETDATE()),9,21)
) AS DiasParaPrimavera;
/*
4. Realizar una consulta que permita redondear el número 385,86 con
únicamente 1 decimal.
*/
SELECT ROUND(385.86,1) AS NumeroRedondeado;
/*
5. Realizar una consulta permita saber cuánto es el mes actual al cuadrado. Por
ejemplo, si estamos en Junio, sería 62
*/
select
	POWER(MONTH(GETDATE()),2) AS MesAlCuadrado;
/*
6. Devolver cuál es el usuario que se encuentra conectado a la base de datos
*/
SELECT SYSTEM_USER AS UsuarioConectado;
/*
7. Realizar una consulta que permita conocer la edad de cada empleado
(Ayuda: HumanResources.Employee)
*/
select 
	BusinessEntityID,
	BirthDate,
	DATEDIFF(YEAR, BirthDate, GETDATE()) AS Edad
from HumanResources.Employee;
/*
8. Realizar una consulta que retorne la longitud de cada apellido de los
Contactos, ordenados por apellido. En el caso que se repita el apellido
devolver únicamente uno de ellos. Por ejemplo,
Apellido Longitud
Abel 4
*/
select distinct LastName as Apellido,
	LEN(Lastname) as Longitud
	from Person.Person
	order by LastName;

/*
9. Realizar una consulta que permita encontrar el apellido con mayor longitud.
*/
select TOP 1
	LastName AS Apellido,
	LEN(LastName) AS Longitud
from Person.Person
order by LEN(LastName) desc;

/*
10.Realizar una consulta que devuelva los nombres y apellidos de los contactos
que hayan sido modificados en los últimos 3 años.
*/
select 
	FirstName AS Nombre,
	LastName   AS Apellido
from Person.Person
where ModifiedDate >= DATEADD(YEAR, -3, GETDATE());
/*
11.Se quiere obtener los emails de todos los contactos, pero en mayúscula.
*/
select 
	UPPER(EmailAddress) AS EmailMayuscula
from Person.EmailAddress;

/*
12.Realizar una consulta que permita particionar el mail de cada contacto,
obteniendo lo siguiente:
IDContacto email nombre Dominio
1 juanp@ibm.com juanp ibm
*/
select
	BusinessEntityID as IDContacto,
	EmailAddress as Email,
	LEFT(EmailAddress, CHARINDEX('@', EmailAddress)-1) as Nombre,
	SUBSTRING(EmailAddress,CHARINDEX('@', EmailAddress)+1, CHARINDEX('.', EmailAddress) - CHARINDEX('@',EmailAddress)-1) AS Dominio
from Person.EmailAddress;

/*
13.Devolver los últimos 3 dígitos del NationalIDNumber de cada empleado
*/
select
	BusinessEntityID,
	RIGHT(NationalIDNumber,3) AS Ultimos3Digitos
from HumanResources.Employee;
/*
14.Se desea enmascarar el NationalIDNumbre de cada empleado, de la
siguiente forma ###-####-##:
ID Numero Enmascarado
36 113695504 113-6955-04
*/
select 
	BusinessEntityID AS ID,
	NationalIDNumber,
	STUFF(STUFF(NationalIDNumber,4,0,'-'),9,0,'-') AS NumeroEnmascarado
from HumanResources.Employee;
/*
15.Listar la dirección de cada empleado “supervisor” que haya nacido hace más
de 30 años. Listar todos los datos en mayúscula. Los datos a visualizar son:
nombre y apellido del empleado, dirección y ciudad.
*/
select
	UPPER(p.FirstName + ' ' + p.LastName) AS NombreCompleto,
    UPPER(a.AddressLine1) AS Direccion,
    UPPER(sp.Name) AS Ciudad
from HumanResources.Employee e

INNER JOIN Person.Person p
	ON e.BusinessEntityID = p.BusinessEntityID

INNER JOIN HumanResources.EmployeeDepartmentHistory edh
	ON e.BusinessEntityID = edh.BusinessEntityID

INNER JOIN Person.BusinessEntityAddress bea
	ON e.BusinessEntityID = bea.BusinessEntityID

INNER JOIN Person.Address a
    ON bea.AddressID = a.AddressID

INNER JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID

WHERE 
    e.OrganizationLevel IS NOT NULL
    AND DATEDIFF(YEAR, e.BirthDate, GETDATE()) > 30;


/*
16.Listar la cantidad de empleados hombres y mujeres, de la siguiente forma:
Sexo Cantidad
Femenino 47
Masculino 56
Nota: Debe decir, Femenino y Masculino de la misma forma que se muestra.
*/
SELECT 
    CASE 
        WHEN Gender = 'F' THEN 'Femenino'
        WHEN Gender = 'M' THEN 'Masculino'
    END AS Sexo,

    COUNT(*) AS Cantidad

FROM HumanResources.Employee

GROUP BY Gender;
/*
17.Categorizar a los empleados según la cantidad de horas de vacaciones,
según el siguiente formato:
Alto = más de 50 / medio= entre 20 y 50 / bajo = menos de 20
*/
SELECT 
    BusinessEntityID,

    VacationHours,

    CASE
        WHEN VacationHours > 50 THEN 'Alto'
        WHEN VacationHours BETWEEN 20 AND 50 THEN 'Medio'
        ELSE 'Bajo'
    END AS Categoria

FROM HumanResources.Employee;