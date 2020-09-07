/****************************************************************************
Autor: Jader Gabriel Soares de Arruda
Data: 15-04-2019
Assunto: DataMasking
This example shows how datamasking works to hide columns to unpermited users
update, insert,delete and join are allowed on the table as long as the user has
permission, but nevertless he will not be allowed to see the data
Execute part by part slowly
****************************************************************************/

--Create and populate table
		CREATE schema Examples
		GO


		CREATE TABLE Examples.DataMasking
		(
		FirstName nvarchar(50) NULL,
		LastName nvarchar(50) NOT NULL,
		PersonNumber char(10) NOT NULL,
		Status varchar(10), 
		EmailAddress nvarchar(50) NULL,
		BirthDate date NOT NULL, 
		CarCount tinyint NOT NULL 
		);


		INSERT INTO Examples.DataMasking(FirstName,LastName,PersonNumber, Status,
		EmailAddress, BirthDate, CarCount)
		VALUES('Jay','Hamlin','0000000014','Active','jay@litwareinc.com','1979-01-12',0),
		('Darya','Popkova','0000000032','Active','darya.p@proseware.net','1980-05-22', 1),
		('Tomasz','Bochenek','0000000102','Active',NULL, '1959-03-30', 1),
		('Jader','Arruda','0000000136','Active','jader.arruda@hotmail.com', '1990-08-23', 1);


--Create user to test and grant select and update
		CREATE USER UserMaskedView WITHOUT LOGIN;
 
		GRANT SELECT,UPDATE ON Examples.DataMasking TO UserMaskedView;


--There are four types of DataMasking, Default(),Email(),Partial(n,"***",n) and Random(n,n)
		ALTER TABLE Examples.DataMasking ALTER COLUMN FirstName
		ADD MASKED WITH (FUNCTION='Default()');

		ALTER TABLE Examples.DataMasking ALTER COLUMN BirthDate
		ADD MASKED WITH (FUNCTION='Default()');

		ALTER TABLE Examples.DataMasking ALTER COLUMN EmailAddress
		ADD MASKED WITH (FUNCTION='Email()');

		ALTER TABLE Examples.DataMasking ALTER COLUMN PersonNumber
		ADD MASKED WITH (FUNCTION='Partial(2,"******",1)');

		ALTER TABLE Examples.DataMasking ALTER COLUMN LastName
		ADD MASKED WITH(FUNCTION='partial(3,"____",2)');

		ALTER TABLE Examples.DataMasking ALTER COLUMN Status
		ADD MASKED WITH(FUNCTION='partial(0,"Unknown",0)');

		ALTER TABLE Examples.DataMasking ALTER COLUMN CarCount
		ADD MASKED WITH(FUNCTION='Random(0,9)');


--Select with user with unmasked permission to show how the table looks like
		SELECT * FROM Examples.DataMasking 


--Select the table with user created without permission to show how the data is hidden
		EXECUTE AS USER = 'UserMaskedView';
		SELECT * FROM Examples.DataMasking; 


--Update with user without permission. The user can update but can't see the underlying data
		UPDATE Examples.DataMasking
		SET FirstName ='Jones'
		,LastName='Hopkins'
		WHERE PersonNumber = '0000000014'


--Drop masked data on column
		ALTER TABLE Examples.DataMasking
		ALTER COLUMN LastName
		DROP MASKED 


--Select the result still with the created for this purpose user
		SELECT * FROM Examples.DataMasking; 


--Revert to former user and  
		REVERT;
		SELECT * FROM Examples.DataMasking; 

