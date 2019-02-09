/****************************************************************************
Autor: Jader Gabriel Soares de Arruda
Data: 08-02-2019
Assunto: JSON with currency file from BCB
****************************************************************************/

--Read relational data from Json file 

		--Query Json using OPENROWSET
		SELECT * FROM OPENROWSET (BULK 'C:\Users\Jader\Desktop\JSON\Moedas.JSON', SINGLE_CLOB) AS j

		--Storing Json in a variable
		DECLARE @JSON VARCHAR(MAX)

		SELECT @JSON = BulkColumn FROM OPENROWSET (BULK 'C:\Users\Jader\Desktop\JSON\Moedas.JSON', SINGLE_CLOB) AS J


--Shows key, value and type of the file. Key is the key of the json, value is the value and type is the data type	
		SELECT * FROM OPENJSON(@JSON)
--0 null
--1 string
--2 number
--3 true/false
--4 array
--5 object

--Function IsJson
		SELECT ISJSON(@JSON) -- 1 sim 0 não


--Function OpenJason to query the file 
		--If deeper levels are needed, use '$.colname.deeperLevel' to find the data
		SELECT * FROM OPENJSON(@JSON,'$.value')
		WITH( 
		simbolo varchar(50) '$.simbolo'
		,nomeFormatado varchar(50) '$.nomeFormatado'
		,tipoMoeda varchar(50) '$.tipoMoeda'
		) AS Moedas

--Lax and strict are used to search a variable. Lax looks for an approximate and strict to a strict variable. Lax returns empty if not found and strict gives an error.		
		SELECT *
		FROM OPENJSON(@json,'lax $.Buyer');
		SELECT *
		FROM OPENJSON(@json,'strict $.Buyer');


--Functions json_value and json_query
		DECLARE @json AS NVARCHAR(MAX) = N'
		{
		"Customer":{
		"Id":1,
		"Name":"Customer NRZBB",
		"Order":{
		"Id":10692,
		"Date":"2015-10-03",
		"Delivery":null
		}
		}
		}';
		SELECT JSON_VALUE(@json, '$.Customer.Id') AS CustomerId,
		JSON_VALUE(@json, '$.Customer.Name') AS CustomerName,
		JSON_QUERY(@json, '$.Customer.Order') AS Orders;


--Query JSON using AUTO

		--Transform a table into a JSON file.
		SELECT * 
		FROM bcb.dbo.CEPEA_Indicador_Soja
		WHERE data >='2019-01-01'
		FOR JSON AUTO

--Query using JSON using AUTO
		--Transform a table into a JSON file.
		SELECT * 
		FROM bcb.dbo.CEPEA_Indicador_Soja
		WHERE data >='2019-01-01'
		FOR JSON PATH

--function without array wrapper
		SELECT * 
		FROM bcb.dbo.CEPEA_Indicador_Soja
		WHERE data >='2019-01-01'
		FOR JSON PATH,
		WITHOUT_ARRAY_WRAPPER 

--function include a root
		SELECT * 
		FROM bcb.dbo.CEPEA_Indicador_Soja
		WHERE data >='2019-01-01'
		FOR JSON PATH,
		ROOT ('CEPEA')

--function include null values
		SELECT * 
		FROM bcb.dbo.CEPEA_Indicador_Soja
		WHERE data >='2019-01-01'
		FOR JSON PATH,
		INCLUDE_NULL_VALUES

--Function json_modify. Insert, modify and delete rows
		DECLARE @json AS NVARCHAR(MAX) = N'
		{
		"Customer":{
		"Id":1,
		"Name":"Customer NRZBB",
		"Order":{
		"Id":10692,
		"Date":"2015-10-03",
		"Delivery":null
		}
		}
		}';

		-- Update name
		SET @json = JSON_MODIFY(@json, '$.Customer.Name', 'Modified first name');
		-- Delete Id
		SET @json = JSON_MODIFY(@json, '$.Customer.Id', NULL)
		-- Insert last name
		SET @json = JSON_MODIFY(@json, '$.Customer.LastName', 'Added last name')
		PRINT @json;
