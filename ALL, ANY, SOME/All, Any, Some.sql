/****************************************************************************
Autor: Jader Gabriel Soares de Arruda
Data: 12-03-2019
Assunto: ALL, ANY, SOME
****************************************************************************/
/*
There are three operators barely used in SQL Server, ALL Any and Some. 
Any and some are exactly the same.
Since they may show up on the certification exam I decided to thoroughly review them
and make sure I fully understood them and when they are usefull.

The same result can be achieved using EXISTS and NOT EXISTS with more intuition.
*/

	SELECT min(data) AS Menor_Data --2006-03-13
	, max(data) AS Maior_Data --2019-02-05
	 FROM bcb.dbo.CEPEA_Indicador_Soja

 -------------------------------------------------------------------------------------------------
 -- ALL (Executed as NOT EXISTS)
 -------------------------------------------------------------------------------------------------

	 SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data < ALL (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --NULL 
	--All numbers in A that are lesser than all numbers in B.
	 
	 SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data <= ALL (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13
	--A number in A that is lesser or equal all numbers in B. Only the first date is lesser than all dates in B and its equal the lesser in B

	  SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data > ALL (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --NULL
	--A greater than all numbers in B. None
		 
	  SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data >= ALL (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2019-02-05
	--All dates in A that are greater or equal all numbers in B. Only the first date is greater and equal than all numbers	

	  SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data = ALL (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --NULL
	--no date in A is equal all dates in B

	  SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data <> ALL (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --NULL
	 --All dates in A that are different of all letter in B.

 -------------------------------------------------------------------------------------------------
 -- SOME (in execution plan it is transformed as EXISTS)
 -------------------------------------------------------------------------------------------------

	 SELECT MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data < SOME (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e	2019-02-04
	--Dates in A that are lesser than some date in B. All except the most recent day

	 SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data <= SOME (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13	e 2019-02-05
	--Dates in A that are lesser or equal some in B

	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data > SOME (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-14 e	2019-02-05
 
	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data >= SOME (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e 2019-02-05
 
	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data = SOME (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e	2019-02-05
 
	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data <> SOME (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e 2019-02-05


 -------------------------------------------------------------------------------------------------
 -- ANY - Similar to SOME
 -------------------------------------------------------------------------------------------------
 
	 SELECT MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data < ANY (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e	2019-02-04
 
	 SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data <= ANY (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13	e 2019-02-05
 
	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data > ANY (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-14 e	2019-02-05
 
	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data >= ANY (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e 2019-02-05
 
	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data = ANY (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e	2019-02-05
 
	  SELECT  MIN(Data) AS Menor_Data, MAX(DATA) AS Maior_Data FROM bcb.dbo.CEPEA_Indicador_Soja AS a
	 WHERE Data <> ANY (SELECT Data FROM bcb.dbo.CEPEA_Indicador_Soja AS b ) --2006-03-13 e 2019-02-05


--http://bradsruminations.blogspot.com/2009/08/all-any-and-some-three-stooges.html 

--EXAMPLE

   ;with BoxOf3Coins(CoinValue) as (select  5 union all
                                 select 10 union all
                                 select 25)
,EmptyBox as (select CoinValue
              from BoxOf3Coins
              where rand()<0)
select 'Is twenty-five cents worth more than ANY of the coins in Box#1?'
      ,case when 25 > any (select CoinValue from BoxOf3Coins)
            then 'Yes' else 'No' end
union all
select 'Is twenty-five cents worth more than ALL (EACH) of the coins in Box#1?'
      ,case when 25 > all (select CoinValue from BoxOf3Coins)
            then 'Yes' else 'No' end
union all
select 'Is twenty-five cents worth the same as ANY of the coins in Box#1?'
      ,case when 25 = any (select CoinValue from BoxOf3Coins)
            then 'Yes' else 'No' end
union all
select 'Is twenty-five cents worth the same as ALL (EACH) of the coins in Box#1?'
      ,case when 25 = all (select CoinValue from BoxOf3Coins)
            then 'Yes' else 'No' end
union all
select '----------',''
union all
select 'Is twenty-five cents worth more than ANY of the coins in Box#2?'
      ,case when 25 > any (select CoinValue from EmptyBox)
            then 'Yes' else 'No' end
union all
select 'Is twenty-five cents worth more than ALL (EACH) of the coins in Box#2?'
      ,case when 25 > all (select CoinValue from EmptyBox)
            then 'Yes' else 'No' end
union all
select 'Is twenty-five cents worth the same as ANY of the coins in Box#2?'
      ,case when 25 = any (select CoinValue from EmptyBox)
            then 'Yes' else 'No' end
union all
select 'Is twenty-five cents worth the same as ALL (EACH) of the coins in Box#2?'
      ,case when 25 = all (select CoinValue from EmptyBox)
            then 'Yes' else 'No' end
/*
Is twenty-five cents worth more than ANY of the coins in Box#1?          Yes
Is twenty-five cents worth more than ALL (EACH) of the coins in Box#1?   No
Is twenty-five cents worth the same as ANY of the coins in Box#1?        Yes
Is twenty-five cents worth the same as ALL (EACH) of the coins in Box#1? No
----------                                                               
Is twenty-five cents worth more than ANY of the coins in Box#2?          No
Is twenty-five cents worth more than ALL (EACH) of the coins in Box#2?   Yes
Is twenty-five cents worth the same as ANY of the coins in Box#2?        No
Is twenty-five cents worth the same as ALL (EACH) of the coins in Box#2? Yes
*/
