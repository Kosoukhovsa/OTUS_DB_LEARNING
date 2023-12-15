# Описание схемы базы данных книжного интернет магазина.

## Функциональные требования к системе
Интернет-магазин должен обеспечить следующие возможности:

**Покупателям:**
*	Регистрироваться на сайте, вести профиль, отслеживать состояние заказа, просматривать историю заказов
*	Подбирать книги по тематике, году публикации, ключевым словам
*	Просмотр подробной информации о книге
*	Заполнять корзину покупок и оформлять заказ. Добавлять и удалять книги из корзины
*	Отслеживать состояние заказа
*	Оставлять отзывы на книги

**Менеджерам магазина:**

_Управление Товарами:_
*	Добавление новых книг в каталог.
*	Обновление информации о книгах.
*	Удаление книг из каталога.
*	Формировать рейтинг книг на основе отзывов

_Управление Заказами:_
*	Просмотр и управление заказами (подтверждение, отмена, изменение статуса).

_Аналитика и Отчетность:_
*	Отслеживание продаж, популярных книг и активности пользователей.
*	Генерация отчетов по продажам.
      
**Администраторам сайта:**
*	Просмотр информации о пользователях.
*	Управление статусами пользователей (активировать, блокировать).


## Таблицы

- [x] **book** 

Книга. 


Field|Name       | Constraint | High cardinality|Index|
---- | ----------|------------|----|-|
id   | Ключ  | Primary key|||
title| Заголовок |NOT NULL|||
author | Автор| NOT NULL|||
description | Краткое описание книги| NOT NULL|||
book_type_id |Тип книги| NOT NULL|||
publisher_id |Издатель| NOT NULL|||
year_publishing |Год издания| NOT NULL|X|X|
toc  | Оглавление|NOT NULL|||


- [x] **book_type** 

Категория книги (электронная, бумажная, аудио). 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|--|-|
id   | Ключ  | Primary key|||
name| Категория |NOT NULL, UNIQUE|||


- [x] **genre**

Жанр. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|--|-|
id   | Ключ  | Primary key|||
name| Жанр |NOT NULL, UNIQUE|||


- [x] **book_genre**

Жанр книги. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|--|-|
id   | Ключ  | Primary key|||
book_id| Книга |NOT NULL||X|
genre_id|Жанр|NOT NULL||X|


- [x] **publisher**

Издательство. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|--|-|
id   | Ключ  | Primary key|||
name| Издательство |NOT NULL, UNIQUE|||
country_id|Страна|NOT NULL|||


- [x] **country**

Страна. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|-|-|
id   | Ключ  | Primary key|||
iso_code| Международная аббревиатура |NOT NULL, UNIQUE|||
name|Страна|NOT NULL|||


- [x] **user**

Пользователь. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|--|-|
id   | Ключ  | Primary key||
login| Логин |NOT NULL, UNIQUE||
f_name|Имя|||
s_name|Фамилия|||
email| Email |NOT NULL, UNIQUE||
pwd_hash| Хеш-строка пароля |NOT NULL||
time_created| Время создания |NOT NULL|X|X|
last_visit| Время последнего посещения |NOT NULL|X|X|
country_id| Страна |NOT NULL||
birth_date| Дата рождения |NOT NULL|X|X|
is_blocked| Флаг блокировки |NOT NULL||


- [x] **review**

Обзор книги. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|-|-|
id   | Ключ  | Primary key||
user_id| Пользователь |NOT NULL||X|
book_id|Книга|NOT NULL||X|
score|Рейтинг||X|X|
time_created| Время создания |NOT NULL||X|X|
review| Краткий обзор |||


- [x] **basket**

Корзина. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|-|-
id   | Ключ  | Primary key||
user_id| Пользователь |NOT NULL||X
book_id|Книга|NOT NULL||X|
quantity|Количество||X|X|
time_added| Время добавления в корзину |NOT NULL|X|


- [x] **order**

Заказ. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|-|-
id   | Ключ  | Primary key||
user_id| Пользователь |NOT NULL||X
time_created| Время создания |NOT NULL|X|X
time_closed| Время закрытия ||X|X
status_id| Статус заказа |NOT NULL||X


- [x] **order_item**

Позиция заказа. 

Field|Name       | Constraint |High cardinality|Index|
---- | ----------|------------|-|-
id   | Ключ  | Primary key||
book_id| Книга |NOT NULL||X
order_id| Заказ |NOT NULL||X
quantity| Количество |NOT NULL|X|X
price| Цена |NOT NULL|X|X
amount| Сумма |NOT NULL|X|X

CHECK (
    (amount >= (0)) 
AND (quantity >= (0)) 
AND (price >= (0))
)

- [x] **status**

Статус заказа. 

Field|Name       | Constraint |High cardinality|
---- | ----------|------------|-|
id   | Ключ  | Primary key||
name| Статус |NOT NULL, UNIQUE||









