# Описание схемы базы данных книжного интернет магазина.

## Функциональные требования к системе
Интернет-магазин должен обеспечить следующие возможности:

**Покупателям:**
*	Регистрироваться на сайте, вести профиль, отслеживать состояние заказа, просматривать историю заказов
*	Подбирать книги по тематике, году публикации, ключевым словам
*	Просмотр подробной информации о книге
*	Заполнять корзину покупок и оформлять заказ. Добавлять и удалять книги из корзины
*	Оформлять заказ: ввод данных для доставки, способа оплаты, подтверждение заказа, оплата заказа
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
*	Генерация отчетов по продажам и запасам на складе.
       Управление Промо-акциями:
*	Создание и управление специальными предложениями и скидками.

**Администраторам сайта:**
*	Просмотр информации о пользователях.
*	Управление статусами пользователей (активировать, блокировать).


## Таблицы

- [x] Book. 
Содержит перечень книг. 


Field|Name       | Constraint |
---- | ----------|------------|
id   | Ключ  | Primary key|
title| Заголовок |NOT NULL|
author | Автор| NOT NULL|
description | Краткое описание книги| NOT NULL|
book_type_id |Тип книги| NOT NULL|
publisher_id |Издатель| NOT NULL|
year_publishing |Год издания| NOT NULL|
toc  | Оглавление|NOT NULL|


### Book_type. 
Содержит категории книг (электронная, бумажная, аудио). 

Field|Name       | Constraint |
---- | ----------|------------|
id   | Ключ  | Primary key|
name| Категория |NOT NULL, UNIQUE|


### Price. 
Содержит цены товаров на разные периоды . 
Структура
* ID - первичный ключ
* Date_from - Дата начала действия цены (NOT NULL)
* Date_to - Дата окончания действия цены (NOT NULL)
* Price - Цена (NOT NULL),(CHECK Price >= 0)
* Product_ID - Продукт (NOT NULL)

#### Индексы:
<u> Поля с высокой кардинальностью: </u> 
* Date_from
* Date_to
* Price

Составной индекс: (Date_from, Date_to, Price)
Может использоваться для запросов вида:

Select
prodict_id,
max(price) 
from
Price
where 
date_from <= '01.01.2020' and 
date_to >= '01.31.2021'
group by 
product_id
;

### Provider. 
Содержит список поставщиков . 
Структура
* ID - первичный ключ
* Name - Наименование (NOT NULL)
* Country_ID - Код страны (NOT NULL)

### Manufacturer. 
Содержит список производителей . 
Структура
* ID - первичный ключ
* Name - Наименование (NOT NULL)
* Country_ID - Код страны (NOT NULL)

### Customer. 
Содержит список покупателей . 
Структура
* ID - первичный ключ
* Name - Наименование (NOT NULL)
* Customer_type_ID - Категория покупателя (NOT NULL)
* Country_ID - Код страны (NOT NULL)

### Customer_type. 
Содержит список категорий покупателей . 
Структура
* ID - первичный ключ (NOT NULL)
* Name - Наименование (NOT NULL)
* Discount - Размер скидки в % (NOT NULL),(CHECK Discount <=100)

### Order. 
Содержит список заказов . 
Структура
* ID - первичный ключ (позиция заказа)
* Order_number - Номер заказа (NOT NULL)
* Order_date - дата заказа (NOT NULL)
* Month - месяц заказа (NOT NULL)
* Year - год заказа (NOT NULL)
* Customer_ID - Покупатель (NOT NULL)
* Product_ID - Товар (NOT NULL)
* Order_type_ID - Тип заказа (NOT NULL)
* Quantity - Количество (NOT NULL),(CHECK Quantity >= 0)
* Amount - сумма (NOT NULL),(CHECK Amount >= 0)

#### Индексы:
<u> Поля с высокой кардинальностью: </u> 
* Date
* Quantity
* Amount

Составной индекс: (Date, Month, Year, Product_ID, Quantity)
Может использоваться для запросов вида:

Select
Month,
Year,
Product_ID,
sum(Quantity) 
from
Price
where 
date_from <= '01.01.2020' and 
date_to >= '01.31.2021' and 
Quantity > 100 and 
Date between '01.01.2020' and '31.01.2020'
group by 
Month,
Year,
Product_ID
;

### Order_type. 
Содержит список типов заказов . 
Структура
* ID - первичный ключ
* Name - Наименование (NOT NULL)

### Country. 
Содержит список стран . 
Структура
* ID - первичный ключ
* Name - Наименование (NOT NULL)
* Region - Регион (NOT NULL)








