# Описание схемы базы данных интернет магазина.

## Таблицы

### Product. 
Содержит перечень товаров. 
Структура
* ID - первичный ключ
* Name - Наименование (NOT NULL)
* Product_type_ID - Код категории товара (NOT NULL)
* Manufacturer_ID - Код производителя (NOT NULL)

### Product_type. 
Содержит категории товаров. 
Структура
* ID - первичный ключ
* Name - Наименование (NOT NULL)
* Description - Подробное описание

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








