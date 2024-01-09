analyze;

show search_path;

-- Поиск по шаблону и регулярные выражения
-- Вывести актеров имена которых начинаются с J затем в имени есть N и в фамилии которых не начинаются с s в любом регистре 
select *
from actor
where 
-- По шаблону
first_name ~~* 'j%n%' and 
-- Регулярное выражение POSIX
last_name !~* '^s'
;

-- JOINS
-- LEFT JOIN
-- Вывести актеров и документальные фильмы в которых они снимались в период с 2006 по 2007 год
-- Если таких фильмов нет - то все равно вывести актеров с маской по имени
select 
a.first_name||' '||a.last_name as actor,
f.title, f.release_year
from actor as a 
left join film_actor as fa using(actor_id)
left join film as f on 
	fa.film_id = f.film_id and 
	f.release_year between '2006' and '2007' 
left join film_category as fc on 
	f.film_id = fc.film_id and 
	fc.category_id = 6
where 
a.first_name like 'J%N%'
GROUP BY 
actor, f.title, f.release_year
ORDER BY actor, f.release_year
;

-- INNER JOIN
-- Вывести актеров и документальные фильмы в которых они снимались до 2001 года
-- Если таких фильмов нет - то не выводить актеров
select 
a.first_name||' '||a.last_name as actor,
f.title, f.release_year
from actor as a 
join film_actor as fa using(actor_id)
join film as f on 
	fa.film_id = f.film_id and 
	f.release_year < '2001' 
join film_category as fc on 
	f.film_id = fc.film_id and 
	fc.category_id = 6
where 
a.first_name like 'J%N%'
GROUP BY 
actor, f.title, f.release_year
ORDER BY actor, f.release_year
;


-- Создание таблицы из запроса с добавлением записей
DROP TABLE if exists actor_films ;

CREATE TABLE actor_films 
AS (
select 
a.first_name||' '||a.last_name as actor,
f.film_id,
f.title, f.release_year
from actor as a 
join film_actor as fa using(actor_id)
join film as f on 
	fa.film_id = f.film_id and 
	f.release_year < '2008' 
join film_category as fc on 
	f.film_id = fc.film_id and 
	fc.category_id = 6
where 
a.first_name like 'J%N%'
GROUP BY 
actor, f.title, f.film_id, f.release_year
ORDER BY actor, f.release_year, f.title
)
;

-- Добавление записей в созданную ранее таблицу 
-- Вывести добавленные записи в результат запроса
INSERT INTO actor_films 
SELECT 
a.first_name||' '||a.last_name as actor,
f.film_id,
f.title, f.release_year
from actor as a 
join film_actor as fa using(actor_id)
join film as f on 
	fa.film_id = f.film_id and 
	f.release_year between '2006' and '2020'
join film_category as fc on 
	f.film_id = fc.film_id and 
	fc.category_id = 6
where 
a.first_name like 'A%N%'
GROUP BY 
actor, f.title, f.film_id, f.release_year
ORDER BY actor, f.release_year, f.title
RETURNING *
;

-- Добавить статистику проката фильмов
-- UPDATE from query
ALTER TABLE actor_films
ADD COLUMN rental_cnt int DEFAULT 0
;

UPDATE actor_films
set rental_cnt = rental_counters.rental_cnt
FROM
(select
af.actor,
af.film_id,
af.title, 
af.release_year,
count(rnt.rental_id) as rental_cnt
from
actor_films as af 
left join inventory as inv using(film_id)
left join rental as rnt using(inventory_id)
group by
af.actor,
af.film_id,
af.title, 
af.release_year) as rental_counters
WHERE 
actor_films.actor = rental_counters.actor and 
actor_films.film_id = rental_counters.film_id 
RETURNING *
;

-- Удалить из таблицы со статистикой проката данные с номером склада проката = 2
DELETE from actor_films
USING 
(select
af.actor,
af.film_id,
af.title, 
af.release_year,
st.store_id
from 
actor_films as af 
left join inventory as inv using(film_id)
left join store as st using(store_id)
where st.store_id = 2
group by
af.actor,
af.film_id,
af.title, 
af.release_year,
st.store_id) as store_2
where 
actor_films.actor = store_2.actor and 
actor_films.film_id = store_2.film_id 
RETURNING *
;

-- COPY 
-- ** COPY to file
COPY (SELECT * FROM actor_films) TO '/home/postgres/actors_films.csv' WITH CSV HEADER;

-- ** COPY from file
--1. Create table by template
CREATE TABLE actor_copy
AS(
SELECT * FROM actor
	WHERE 1=2
)
;

-- 2. Download data from template table
COPY (SELECT * FROM actor) TO '/home/postgres/actor.csv' WITH CSV HEADER;
SELECT count(*) FROM actor_copy;

-- 3. Upload data from file
COPY actor_copy FROM '/home/postgres/actor.csv' WITH CSV HEADER;
-- 4. Check
SELECT count(*) FROM actor_copy;
SELECT * FROM actor_copy;


