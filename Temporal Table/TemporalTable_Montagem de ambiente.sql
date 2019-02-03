/****************************************************************************
Autor: Jader Gabriel Soares de Arruda
Data: 02-02-2019
Assunto: tabela temporal com cota��o di�ria do Dolar desde 2000
****************************************************************************/

--CRIAR BANCO DE TESTE
--	CREATE DATABASE BCB
	--GO
	--USE BCB
	GO
	IF OBJECT_ID('CotacaoDolar_Stg','U') IS NOT NULL DROP TABLE CotacaoDolar_Stg
	IF OBJECT_ID('vw_CotacaoDolar_Stg','V') IS NOT NULL DROP VIEW vw_CotacaoDolar_Stg
	IF OBJECT_ID('CotacaoDolar','U') IS NOT NULL 	
			ALTER TABLE [dbo].[CotacaoDolar] SET ( SYSTEM_VERSIONING = OFF)
			GO
			DROP TABLE [dbo].[CotacaoDolar]
	IF OBJECT_ID('CotacaoDolar_HISTORICO','U') IS NOT NULL 	DROP TABLE [dbo].[CotacaoDolar_Historico]

--Criar tabela de stage para importa��o de CSV incluindo ID identity
	GO
	CREATE TABLE CotacaoDolar_Stg
	(	
		ID INT IDENTITY(1,1) NOT NULL
		,Codigo	VARCHAR(50)
		,cotacaoCompra	VARCHAR(50)
		,cotacaoVenda	VARCHAR(50)
		,dataHoraCotacao VARCHAR(50)
	)


--Criar view para poder dar um bulk insert na tabela de stage
	GO
	CREATE VIEW vw_CotacaoDolar_Stg
	AS
	(
		SELECT Codigo
		, CotacaoCompra
		, CotacaoVenda
		, dataHoraCotacao
		FROM CotacaoDolar_Stg
	)

go
--Bulk insert na tabela de stage para tratamento
	BULK INSERT [vw_CotacaoDolar_Stg] 
	FROM 'C:\Users\Jader\Desktop\Temporal Table\Cota��o do D�lar por per�odo.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR=';',
		ROWTERMINATOR='0x0a'
	)


--Cria��o da tabela temporal principal
	GO
	CREATE TABLE CotacaoDolar
	(
		ID INT NOT NULL 
		CONSTRAINT pk_CotacaoDolar_ID PRIMARY KEY (ID)
		,Moeda CHAR(3) DEFAULT 'USD'
		,Codigo TINYINT	
		,cotacaoCompra	SMALLINT
		,cotacaoVenda	DECIMAL(8,4)
		,dataHoraCotacao DATETIME2(3)
		,ValidoDe DATETIME2(3) NOT NULL
		,ValidoAte DATETIME2(3) NOT NULL
	)


--Cria��o de tabela hist�rico
	GO
	CREATE TABLE CotacaoDolar_Historico
	(
		ID INT NOT NULL
		,Moeda CHAR(3) DEFAULT 'USD'
		,Codigo TINYINT	
		,cotacaoCompra	SMALLINT
		,cotacaoVenda	DECIMAL(8,4)
		,dataHoraCotacao DATETIME2(3)
		,ValidoDe DATETIME2(3) NOT NULL
		,ValidoAte DATETIME2(3) NOT NULL
		,INDEX ix_ProductsHistory CLUSTERED(validoAte, validoDe)
		WITH (DATA_COMPRESSION = PAGE)
	)
	GO
--Inser��o de registro na tabela CotacaoDolar. Apenas o v�lido de hoje
	INSERT INTO CotacaoDolar(ID, Codigo, CotacaoCompra, CotacaoVenda, DataHoraCotacao,ValidoDe,ValidoAte)
	SELECT ID, Codigo
		, CotacaoCompra
		, REPLACE(CotacaoVenda,',','.') CotacaoVenda
		, CAST(LEFT(DataHoraCotacao,10) AS DATETIME2(3)) AS DataHoraCotacao
		, CAST(LEFT(DataHoraCotacao,10) AS DATETIME2(3)) AS ValidoDe
		, '9999-12-31 23:59:59.999' AS ValidoAte
	FROM CotacaoDolar_Stg
	WHERE dataHoraCotacao = (SELECT MAX(DataHoraCotacao) FROM CotacaoDolar_Stg)


--Inser��o de registro na tabela CotacaoDolar_Historico. Todo o hist�rico e inser��o manual de Valido de at� valido at� para simula��o
	INSERT INTO CotacaoDolar_Historico(ID, Codigo, CotacaoCompra, CotacaoVenda, DataHoraCotacao,ValidoDe,ValidoAte)
	SELECT ID, Codigo
		, CotacaoCompra
		, REPLACE(CotacaoVenda,',','.') CotacaoVenda
		, CAST(LEFT(DataHoraCotacao,10) AS DATETIME2(3)) AS DataHoraCotacao
		, CAST(LEFT(DataHoraCotacao,10) AS DATETIME2(3)) AS ValidoDe
		, LEFT(DataHoraCotacao,10)+' 23:59:59.000'  AS ValidoAte
	FROM CotacaoDolar_Stg
	WHERE dataHoraCotacao < (SELECT MAX(DataHoraCotacao) FROM CotacaoDolar_Stg)


--altera��o de tabela para tabela temporal
	ALTER TABLE dbo.CotacaoDolar ADD PERIOD FOR SYSTEM_TIME (ValidoDe, validoAte);
	ALTER TABLE dbo.CotacaoDolar ALTER COLUMN validoDe ADD HIDDEN;
	ALTER TABLE dbo.CotacaoDolar ALTER COLUMN validoAte ADD HIDDEN;
	ALTER TABLE dbo.CotacaoDolar
	SET ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = dbo.CotacaoDolar_Historico ) );


--Consulta
SELECT * FROM CotacaoDolar
SELECT * FROM CotacaoDolar_Historico

--APAGAR UMA TABELA TEMPORAL
/*
	ALTER TABLE [dbo].[CotacaoDolar] SET ( SYSTEM_VERSIONING = OFF)
	GO
	DROP TABLE [dbo].[CotacaoDolar]
	GO
	DROP TABLE [dbo].[CotacaoDolar_Historico]
	GO
*/

--Cria��o de tabela temporal. Apenas para conhecimento.
	--CREATE TABLE CotacaoDolar
	--(
	--	ID INT NOT NULL 
	--	CONSTRAINT pk_CotacaoDolar_ID PRIMARY KEY (ID)
	--	,Moeda CHAR(3) DEFAULT 'USD'
	--	,Codigo TINYINT	
	--	,cotacaoCompra	SMALLINT
	--	,cotacaoVenda	DECIMAL(8,4)
	--	,dataHoraCotacao DATETIME2(3)
	--	,ValidoDe DATETIME2(3) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL
	--	,ValidoAte DATETIME2(3) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL
	--	, PERIOD FOR SYSTEM_TIME(ValidoDe,ValidoAte)
	--)
	--SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CotacaoDolas_Historico));

--Com o ambiente montado, realize os testes atrav�s do arquivo em anexo


