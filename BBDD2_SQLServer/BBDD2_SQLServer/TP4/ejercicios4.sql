IF NOT EXISTS (
    SELECT *
    FROM sys.databases
    WHERE name = 'MusicaDB'
)
BEGIN

    CREATE DATABASE MusicaDB
    ON PRIMARY
    (
        NAME = 'Musica',
        FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER1\MSSQL\DATA\Musica.mdf',
        SIZE = 4096KB,
        MAXSIZE = 20480KB,
        FILEGROWTH = 1024KB
    )
    LOG ON
    (
        NAME = 'Musica_log',
        FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER1\MSSQL\DATA\Musica_log.ldf',
        SIZE = 2048KB,
        MAXSIZE = 10240KB,
        FILEGROWTH = 10%
    );

END
GO

use MusicaDB;

/*
2.1. ¿Qué se ha definido como política de retención de log?
No se especificó explícitamente una política de recuperación, por lo tanto SQL Server usa por defecto FULL
*/
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'MusicaDB';

/*
2.2. ¿Se crearán estadísticas automáticamente?
Sí. Por defecto SQL Server tiene activada la opción: AUTO_CREATE_STATISTICS = ON
*/
SELECT name, is_auto_create_stats_on
FROM sys.databases
WHERE name = 'MusicaDB';


/*
2.3 ¿Será compatible con SQL Server 2000?
No completamente. Las versiones modernas usan un nivel de compatibilidad superior.
*/

/*
2.4 ¿Cuál es el juego de caracteres?
El juego de caracteres utilizado es:
Modern_Spanish_CI_AS

Su significado es:

- Modern_Spanish → utiliza reglas de ordenamiento y comparación del español moderno.
- CI (Case Insensitive) → no distingue entre mayúsculas y minúsculas.
  Ejemplo: 'HOLA' = 'hola'
- AS (Accent Sensitive) → distingue acentos.
*/
SELECT DATABASEPROPERTYEX('MusicaDB', 'Collation') AS Collation;

/*3. Crear el esquema discos.
*/
IF NOT EXISTS (
    SELECT *
    FROM sys.schemas
    WHERE name = 'Discos'
)
BEGIN
    EXEC('CREATE SCHEMA Discos')
END

/*4.Se desea crear el siguiente modelo relacional. Recordar que se deben crear
cada una de las tablas involucradas y de sus relaciones.
*/
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Artista'
)
BEGIN
CREATE TABLE Discos.Artista(
    artno smallint NOT NULL,
    nombre varchar(50) NULL,
    clasificacion char(1) NULL,
    bio text NULL,
    foto image NULL,

    CONSTRAINT PK_Artista
    PRIMARY KEY CLUSTERED (artno)
);
END
GO

IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Album'
)
BEGIN
CREATE TABLE Discos.Album(
    titulo varchar(50) NULL,
    artno smallint NOT NULL,
    itemno smallint NOT NULL,

    CONSTRAINT PK_Album
    PRIMARY KEY CLUSTERED (itemno),

    CONSTRAINT FK_Album_Artista
    FOREIGN KEY (artno)
    REFERENCES Discos.Artista(artno)
);
END
GO

IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Concierto'
)
BEGIN
CREATE TABLE Discos.Concierto(
    artno smallint NOT NULL,
    fecha datetime NOT NULL,
    ciudad varchar(25) NULL,

    CONSTRAINT PK_Concierto
    PRIMARY KEY CLUSTERED (artno, fecha),

    CONSTRAINT FK_Concierto_Artista
    FOREIGN KEY (artno)
    REFERENCES Discos.Artista(artno)
);
END
GO

IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Stock'
)
BEGIN
	CREATE TABLE Discos.Stock(
		itemno smallint NOT NULL,
		tipo char(1) NULL,
		precio decimal(5,2) NULL,
		cantidad int NULL,

		CONSTRAINT PK_Stock
		PRIMARY KEY CLUSTERED (itemno),

		CONSTRAINT FK_Stock_Album
		FOREIGN KEY (itemno)
		REFERENCES Discos.Album(itemno)
	);
END
GO

IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Orden'
)
BEGIN
CREATE TABLE Discos.Orden(
    itemno smallint NOT NULL,
    timestamp_row rowversion,

    CONSTRAINT PK_Orden
    PRIMARY KEY CLUSTERED (itemno),

    CONSTRAINT FK_Orden_Stock
    FOREIGN KEY (itemno)
    REFERENCES Discos.Stock(itemno)
);
END
GO

/*5.Crear un diagrama con el modelo relacional generado
*/


/*
6. Realizar los siguientes cambios en el modelo:
6.1. Cambiar el tamaño de campo ciudad en la tabla ciudad para que sea de
30 en lugar de 25.
6.2. En la tabla de Stock, colocar el precio con un valor por defecto en 0
(cero).
6.3. En la tabla de álbumes el nombre del título no puede ser nulo.
*/

ALTER TABLE Discos.Concierto
ALTER COLUMN ciudad varchar(30);

IF NOT EXISTS (
    SELECT *
    FROM sys.default_constraints
    WHERE name = 'DF_Stock_Precio'
)
BEGIN
	ALTER TABLE Discos.Stock
	ADD CONSTRAINT DF_Stock_Precio
	DEFAULT 0 FOR precio;
END
GO
ALTER TABLE Discos.Album
ALTER COLUMN titulo varchar(50) NOT NULL;


/*Para verificar al ejecutar todo*/
DELETE FROM Discos.Orden;
DELETE FROM Discos.Stock;
DELETE FROM Discos.Album;
DELETE FROM Discos.Concierto;
DELETE FROM Discos.Artista;

/*7. Agregar los siguientes registros dentro de la base de datos creada:
- 3 artistas
- 2 conciertos por cada uno de los artistas en diferentes fechas y ciudades
- 2 álbumes por cada uno de los artistas
- Stock sólo de 2 álbumes de diferentes artistas
*/
INSERT INTO Discos.Artista
VALUES
(1, 'Soda Stereo', 'A', 'Rock nacional', NULL),
(2, 'Queen', 'A', 'Rock', NULL),
(3, 'Jungle', 'A', 'Indie Pop Electro', NULL);

INSERT INTO Discos.Concierto
VALUES
(1, '2025-01-10', 'Buenos Aires'),
(1, '2025-02-15', 'Cordoba'),

(2, '2025-03-20', 'Londres'),
(2, '2025-04-25', 'Manchester'),

(3, '2025-05-18', 'Berlin'),
(3, '2025-06-12', 'Barcelona');

INSERT INTO Discos.Album
VALUES
('Cancion Animal', 1, 101),
('Signos', 1, 102),

('A Night at the Opera', 2, 201),
('News of the World', 2, 202),

('Back On 74', 3, 301),
('Volcano', 3, 302);

INSERT INTO Discos.Stock
VALUES
(101, 'C', 100.5, 10),
(201, 'V', 200.5, 5);

INSERT INTO Discos.Orden(itemno)
VALUES
(101),
(201);

