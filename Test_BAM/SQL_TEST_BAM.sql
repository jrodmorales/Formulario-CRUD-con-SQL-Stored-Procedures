/*
USE master
GO
DROP DATABASE DB_TEST_BAM
GO
*/
CREATE DATABASE DB_TEST_BAM
GO
USE DB_TEST_BAM
GO


CREATE TABLE Usuario (
	ID integer PRIMARY KEY NOT NULL,
	nombre NVARCHAR(50),
	edad integer,
	direccion NVARCHAR(250)
)

GO


/* PROCEDIMIENTO ALMACENADO QUE RECIBE MÚLTIPLES PARÁMETROS (no se utiliza en el programa),

el segundo procedimiento, CRUD_Usuario2, recibe únicamente un parámetro y es el que utiliza el sistema*/

--DROP PROCEDURE CRUD_Usuario 
GO
CREATE PROCEDURE CRUD_Usuario
	@accion nvarchar(50),
	@ID integer,
	@nombre nvarchar(50),
	@edad integer,
	@direccion nvarchar(250)
AS
	IF (@accion = 'Crear') 
		INSERT INTO Usuario(ID,nombre,edad,direccion)
			VALUES (@ID, @nombre, @edad, @direccion)
	ELSE 
	IF (@accion = 'Editar') 
		UPDATE Usuario SET nombre=@nombre, edad=@edad, direccion=@direccion
			WHERE ID=@ID 
	ELSE
	IF (@accion = 'Eliminar')
		DELETE FROM Usuario 
			WHERE ID = @ID
	ELSE
	IF (@accion = 'Buscar')
		IF (@ID IS null 
			AND @nombre IS null  
			AND @edad IS null 
			AND @direccion IS null )
			SELECT * FROM Usuario
		ELSE 
			SELECT * FROM Usuario
			WHERE 
				ID = @ID 
				OR
				nombre LIKE '%'+@nombre+'%'
				OR
				edad = @edad
				OR 
				direccion LIKE '%'+@direccion+'%'	
	ELSE 
	IF (@accion = 'Ver todos')
		SELECT * FROM Usuario
	ELSE
		SELECT * FROM Usuario
GO


EXEC CRUD_Usuario 'Crear',1,'Rodrigo',24,'Ciudad'
GO
EXEC CRUD_Usuario 'Crear',2,'Ana',30,'Xela'
GO

EXEC CRUD_Usuario 'Buscar',null,null,null,null
GO
EXEC CRUD_Usuario 'Buscar',null,'A',null,null
GO

EXEC CRUD_Usuario 'Editar',1,'Rodrigo','25','Ciudad'
GO

EXEC CRUD_Usuario 'Eliminar',2,null,null,null
GO

EXEC CRUD_Usuario 'Ver todos',null,null,null,null
GO

/*
	FUNCIÓN Separador SE UTILIZA PARA SEPARAR EL PARÁMETRO ENVIADO A CRUD_Usuario2, 
	Con esta función recorremos el string que envía el formulario, y separamos por comas cada palabra.

	Este sistema es vulnerable a inyección de SQL.
*/

--drop function Separador
go
CREATE FUNCTION Separador (
	@InputString nvarchar(max)
)
RETURNS @Items TABLE (
	Item nvarchar(max),
	posicion integer
	
)
AS 
BEGIN

	DECLARE	@Delimitador nvarchar(50) = ','

	DECLARE @item nvarchar(max)
		DECLARE @posicionIdentificador int = 1
      DECLARE @ItemList       nvarchar(max)
      DECLARE @DelimIndex     int

      SET @ItemList = @InputString
      SET @DelimIndex = CHARINDEX(@Delimitador, @ItemList, 0)
      WHILE (@DelimIndex != 0)
      BEGIN
            SET @Item = SUBSTRING(@ItemList, 0, @DelimIndex)
            INSERT INTO @Items VALUES (@Item,@posicionIdentificador)
			SET @posicionIdentificador = @posicionIdentificador+1

            SET @ItemList = SUBSTRING(@ItemList, @DelimIndex+1, LEN(@ItemList)-@DelimIndex)
            SET @DelimIndex = CHARINDEX(@Delimitador, @ItemList, 0)
      END -- WHILE

      IF @Item IS NOT NULL -- Al menos un delimitador se encontró (para búsquedas de usuarios)
	  BEGIN
            SET @Item = @ItemList
            INSERT INTO @Items VALUES (@Item,5)
      END

      -- ningun delimitador se encontró, solo retornamos @InputString
      ELSE INSERT INTO @Items VALUES (@InputString,5)
		
	RETURN
END
GO

SELECT * FROM separador('Ver todos,,,,')
GO


/* PROCEDIMIENTO CRUD_Usuario2 RECIBE UN SOLO PARÁMETRO 

ESTE ES EL PROCEDIMIENTO QUE UTILIZA EL SISTEMA PARA SUS CONSULTAS*/



--DROP PROCEDURE CRUD_Usuario2
GO


CREATE PROCEDURE CRUD_Usuario2
	@cadena nvarchar(max)
AS
DECLARE
	@accion nvarchar(max),
	@ID integer,
	@nombre nvarchar(max),
	@edad integer,
	@direccion nvarchar(max)

	SELECT @accion = Item FROM separador(@cadena) where posicion=1
	SELECT @ID = Item FROM separador(@cadena) where posicion=2
	SELECT @nombre = Item FROM separador(@cadena) where posicion=3
	SELECT @edad = Item FROM separador(@cadena) where posicion=4
	SELECT @direccion = Item FROM separador(@cadena) where posicion=5
	

	IF (@accion = 'Crear') 
		INSERT INTO Usuario(ID,nombre,edad,direccion)
			VALUES (@ID, @nombre, @edad, @direccion)
	ELSE 
	IF (@accion = 'Editar') 
		UPDATE Usuario SET nombre=@nombre, edad=@edad, direccion=@direccion
			WHERE ID=@ID 
	ELSE
	IF (@accion = 'Eliminar')
		DELETE FROM Usuario 
			WHERE ID = @ID
	ELSE
	IF (@accion = 'Buscar')
		IF (@ID IS null 
			AND @nombre IS null  
			AND @edad IS null 
			AND @direccion IS null )
			SELECT * FROM Usuario
		ELSE 
			SELECT * FROM Usuario
			WHERE 
				ID = @ID 
				OR
				nombre LIKE '%'+@nombre+'%'
				OR
				edad = @edad
				OR 
				direccion LIKE '%'+@direccion+'%'	
	ELSE 
	IF (@accion = 'Ver todos')
		SELECT * FROM Usuario
GO

EXEC CRUD_Usuario2 'Ver todos,,,,'

EXEC CRUD_Usuario2 'Crear,3,Demi,26,Guatemala'

EXEC CRUD_Usuario2 'Ver todos,,,,'
EXEC CRUD_Usuario2 'Ver todos,,,,'
EXEC CRUD_Usuario2 'Ver todos,,,,'





-- *********************************
--*******SECCIÓN DE PRUEBAS**********
--***********************************

DECLARE 
	@cadena varchar(max) = 'Ver todos,3,Demi,26,Guatemala'
DECLARE
	@accion nvarchar(max),
	@ID integer,
	@nombre nvarchar(max),
	@edad integer,
	@direccion nvarchar(max)

	SELECT @accion = Item FROM Separador(@cadena) where posicion=1

	
	SELECT @accion,@ID, @nombre,@edad,@direccion

--PRUEBA
--PRUEBA
EXEC CRUD_Usuario2 'Ver todos,,,,'
GO

DECLARE @variable NVARCHAR(max)

--SET @variable = SELECT TOP Item FROM separador('Ver todos,,,,') where posicion=1

SELECT @variable = Item FROM separador('Ver todos,ASDF,BBBB,CCCC,DDDD') where posicion=3

select @variable as 'si se puede'