-- Посмотеть все индексы для таблиц, участвующих в следующем запросе 
select *
from pg_indexes 
where
tablename in('rental','customer')
order by tablename
;

-- 1. Индекс по одному полю
-- На каких полях нужны индексы для такого запроса?
-- rental_date (условие between)
-- film_actor: film_id, actor_id (вторичные ключи в JOIN)
-- film: release_year (условие between)
-- film_category: film_id (вторичный ключ)

-- Удалить индексы на указанных в запросе таблицах перед первым замером 
--drop index if exists idx_fk_film_id;
--drop index if exists idx_actor_first_name;
drop index if exists idx_unq_rental_rental_date_inventory_id_customer_id;
drop index if exists idx_rental_rental_date;
analyze public.rental;
analyze public.customer;

explain (costs, verbose, format json, analyze)
select 
r.rental_date, r.return_date, ctm.first_name, ctm.last_name
from public.rental as r inner join public.customer as ctm using(customer_id)
where 
(r.rental_date between '2005-06-15 00:00:00' and '2005-06-17 12:00:00')
and ctm.first_name = 'BARBARA'
ORDER BY rental_date
;
/*
Без индексов
      Sort (cost=409.13..409.14 rows=1 width=29) (actual=0.828..0.83 rows=4 loops=1)		
С индексом
	  Sort (cost=49.59..49.59 rows=1 width=29) (actual=0.137..0.138 rows=4 loops=1)	
*/
-- создадим индекс 
create index if not exists idx_rental_rental_date
on public.rental using btree
(rental_date ASC);

create index if not exists idx_customer_first_name
on public.customer using btree
(first_name ASC);

analyze public.rental, public.customer;

-- 2 Полнотекстовый поиск
select
*
from pg_indexes
where
tablename = 'address'
;

alter table public.address 
add column address_lexeme tsvector
;

update public.address
set address_lexeme = to_tsvector(address)
;

explain(costs, verbose, format json, analyze)
select
address
from
public.address
where
address_lexeme@@to_tsquery('Avenu')
;
/*
До индексирования  Seq Scan on public.address as address (cost=0..315.04 rows=3 width=20) (actual=0.051..2.615 rows=59 loops=1)
После индексирования  Bitmap Heap Scan on public.address as address (cost=8.71..41.19 rows=59 width=20) (actual=0.029..0.048 rows=59 loops=1)
*/

create index if not exists idx_address_search 
on public.address using GIN
(address_lexeme)
;
analyze address
;

-- 3. Индекс по полю с функцией
explain (costs, verbose, format json, analyze)
select
address
from
public.address
where
char_length(address) > 30
;
/*
До создания индекса    Seq Scan on public.address as address (cost=0..26.05 rows=201 width=20) (actual=0.015..0.073 rows=26 loops=1)
После создания индекса Bitmap Heap Scan on public.address as address (cost=4.34..22.45 rows=25 width=20) (actual=0.011..0.021 rows=26 loops=1)
*/

create index if not exists idx_address_length
on public.address (char_length(address))
;
analyze public.address
;

-- 4. Составной индекс
explain (costs, verbose, format json, analyze)
select
*
from
public.film
where
rental_duration = 6
and rental_rate > 4
;

/*
До индексирования      Seq Scan on public.film as film (cost=0..70 rows=71 width=390) (actual=0.007..0.167 rows=66 loops=1)
После индеексирования  Bitmap Heap Scan on public.film as film (cost=5..64 rows=71 width=390) (actual=0.025..0.048 rows=66 loops=1)

*/
drop index if exists idx_composite;
create index if not exists idx_composite
on public.film (rental_duration,rental_rate)
;
analyze public.film
;

/*
Обратил внимание, что составной индекс работает только в случае 
Если в условии WHERE по первому полю из индекса стоит проверка на равенство.
По второму полю может быть проверка не не строгое равенство
*/



