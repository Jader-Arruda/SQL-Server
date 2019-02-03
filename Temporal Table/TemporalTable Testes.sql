/****************************************************************************
Autor: Jader Gabriel Soares de Arruda
Data: 02-02-2019
Assunto: tabela temporal com cotação diária do Dolar desde 2000
****************************************************************************/
USE BCB

--Verificação da tabela
--Mostra o dado mais atual
SELECT *,Validode, ValidoAte FROM CotacaoDolar

--Mostra o dado de 11 de Setembro de 2001. Mostra apenas o período especificado
SELECT *,Validode, ValidoAte  FROM CotacaoDolar
FOR SYSTEM_TIME as of '2001-09-11 00:00:00.000'

--Mostra o mês de Setembro de 2001. > <
SELECT *,Validode, ValidoAte  FROM CotacaoDolar
FOR SYSTEM_TIME FROM '2001-09-03 00:00:00.000' TO '2001-09-28 23:59:59.999' order by dataHoraCotacao

--BETWEEN > <=
SELECT *,Validode, ValidoAte  FROM CotacaoDolar
FOR SYSTEM_TIME BETWEEN '2001-09-03 00:00:00.000' AND '2001-09-28 23:59:59.999' order by dataHoraCotacao

--CONTAINED IN >= =<
SELECT *,Validode, ValidoAte  FROM CotacaoDolar
FOR SYSTEM_TIME CONTAINED IN ( '2001-09-03 00:00:00.000' , '2001-09-28 23:59:59.999' ) order by dataHoraCotacao

--ALL
SELECT *,Validode, ValidoAte  FROM CotacaoDolar
FOR SYSTEM_TIME ALL order by dataHoraCotacao
