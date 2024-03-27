-- 1. Categorias que possuam preços entre R$ 100,00 e R$ 200,00.
	select cod_cat from categoria where valor_dia between 100 and 200;
	
-- 2. Categorias cujos nomes possuam a palavra ‘Luxo’.
	select cod_cat from categoria where nome ilike '%Luxo%';
	
-- 3. Nomes de categorias de apartamentos que foram ocupados há mais de 5 anos.
	select c.nome from categoria c natural join apartamento a natural join hospedagem hosp where hosp.dt_ent <= now() - interval '5  years';
	
-- 4. Apartamentos que estão ocupados, ou seja, a data de saída está vazia.
	select num from hospedagem where dt_sai is null;
	
-- 5. Apartamentos cuja categoria tenha código 1, 2, 3, 11, 34, 54, 24, 12.
	select num from apartamento where cod_cat in (1,2,3,11,34,54,24,12);
	
-- 6. Apartamentos cujas categorias iniciam com a palavra ‘Luxo’.
	select num from apartamento a natural join categoria c where c.nome ilike 'Luxo%';
	
-- 7. Quantidade de apartamentos cadastrados no sistema.
	SELECT COUNT(*) FROM APARTAMENTO;

-- 8. Somatório dos preços das categorias.
	SELECT SUM(VALOR_DIA) FROM CATEGORIA;

-- 9. Média de preços das categorias.
	SELECT AVG(VALOR_DIA) FROM CATEGORIA;

-- 10. Maior preço de categoria.
	SELECT MAX(VALOR_DIA) FROM CATEGORIA;
	
-- 11. Menor preço de categoria.
	SELECT MIN(VALOR_DIA) FROM CATEGORIA;

-- 12. O preço média das diárias dos apartamentos ocupados por cada hóspede.
	select cod_hosp,avg(c.valor_dia) from categoria c natural join apartamento a natural join hospedagem hosp group by cod_hosp;
	
-- 13. Quantidade de apartamentos para cada categoria.
	select c.cod_cat categoria,count(a.num) apartamentos from categoria c left join apartamento a on c.cod_cat=a.cod_cat group by c.cod_cat;
    
-- 14. Categorias que possuem pelo menos 2 apartamentos.
	select c.cod_cat from categoria c natural join apartamento a group by c.cod_cat having count(num) > 1;
	
-- 15. Nome dos hóspedes que nasceram após 1° de janeiro de 1970.
	select nome from hospede where dt_nasc > '1970-01-01';
	
-- 16. Quantidade de hóspedes.
	select count(cod_hosp) from hospede;
	
-- 17. Apartamentos que foram ocupados pelo menos 2 vezes.
	select num from apartamento a natural join hospedagem h group by num having count(num) > 1;
	
-- 18. Altere a tabela Hóspede, acrescentando o campo "Nacionalidade".
	alter table hospede add column Nacionalidade varchar(30) not null default 'Brasileiro';
	
-- 19.Quantidade de hóspedes para cada nacionalidade
	select nacionalidade, count(cod_hosp) from hospede group by nacionalidade;
	
-- 20. A data de nascimento do hóspede mais velho.
	select min(dt_nasc) from hospede;
	
-- 21. A data de nascimento do hóspede mais novo.
	select max(dt_nasc) from hospede;

-- 22. Reajuste em 10% o valor das diárias das categorias.
	update categoria set valor_dia = valor_dia * 1.1;
	
-- 23. O nome das categorias que não possuem apartamentos.
	select nome from categoria c left join apartamento a on c.cod_cat = a.cod_cat where a.cod_cat is null;
	
-- 24. O número dos apartamentos que nunca foram ocupados.
	select num from apartamento except select num from hospedagem where dt_ent is not null;
	
-- 25. O número do apartamento mais caro ocupado pelo João.
	select * from apartamento a natural join hospedagem hosp
	natural join categoria c join hospede h on hosp.cod_hosp = h.cod_hosp
	where h.nome ilike 'João Silva' order by valor_dia DESC limit 1;
	
-- 26. O nome dos hóspedes que nunca se hospedaram no apartamento 201.
	select nome from hospede 
	except
	select nome from hospede where cod_hosp in(
	select cod_hosp from hospedagem where num=201);
	
-- 27. O nome dos hóspedes que nunca se hospedaram em apartamentos da categoria LUXO.
	select nome from hospede where cod_hosp not in(
	select cod_hosp from hospedagem natural join apartamento natural join categoria where categoria.nome ilike 'Luxo');
	
-- 28. O nome dos hóspedes que se hospedaram ou reservaram apartamento do tipo LUXO.
	select h.nome from hospede h natural join hospedagem hosp natural join apartamento a join categoria c on c.cod_cat = a.cod_cat
	where c.nome ilike 'Luxo'
	union
	select h.nome from hospede h natural join reserva res natural join apartamento a join categoria c on c.cod_cat = a.cod_cat
	where c.nome ilike 'Luxo';
	
-- 29. O nome dos hóspedes que se hospedaram mas nunca reservaram apartamentos do tipo
-- LUXO.
	select h.nome from hospede h natural join hospedagem natural join apartamento a join categoria c on c.cod_cat = a.cod_cat where c.nome ilike 'Luxo'
	and h.cod_hosp not in (select cod_hosp from reserva res natural join apartamento a natural join categoria c where c.nome ilike 'Luxo');

-- 30. O nome dos hóspedes que se hospedaram e reservaram apartamento do tipo LUXO.
	select h.nome from hospede h natural join hospedagem hosp natural join apartamento a join categoria c on c.cod_cat = a.cod_cat
	where c.nome ilike 'Luxo'
	intersect
	select h.nome from hospede h natural join reserva res natural join apartamento a join categoria c on c.cod_cat = a.cod_cat
	where c.nome ilike 'Luxo';
	