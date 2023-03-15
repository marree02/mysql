drop database if exists webbshopNew;
create database webbshopNew;
use webbshopNew;
-- SET FOREIGN_KEY_CHECKS=0;

create table Shoes(
id int not null auto_increment primary key,
quantity int not null,
color varchar(15) not null,
size int not null,
price int not null,
namn varchar(15) not null
);

create table Categories(
id int not null auto_increment primary key,
namn varchar(100) not null
);

create table Shoe_Categories(
id int auto_increment primary key,
shoe_id int,
category_id int,
foreign key (shoe_id) references Shoes(id),
foreign key (category_id) references Categories(id));

create table Customers(
id int auto_increment primary key,
namn varchar(100) not null
);

create table Orders(
id int not null auto_increment primary key,
datum datetime not null,
customer_id int,
foreign key (customer_id) references Customers(Id));

create table Order_items(
id int not null auto_increment primary key,
quantity int not null,
order_id int,
shoe_id int,
foreign key (order_id) references Orders(id),
foreign key (shoe_id) references Shoes(id),
unique(order_id, shoe_id));

insert into Shoes(quantity, color, size, price, namn) values
(10,'red', 38, 1000,'Ecco'),
(23, 'orange', 44, 599,'Nike'),
(44,'blue', 35, 899,'Adidas'),
(12, 'black', 42, 299,'Puma'),
(42,'white', 44, 399,'Nike'),
(24,'green', 40, 1200,'Jordan 1'),
(75,'black', 39, 1900,'Footjoy'),
(56,'grey', 46, 2000,'Birkenstocks');

INSERT INTO Categories(namn) VALUES
('Sandals'),
('Boots'),
('Sneakers'),
('Trainers'),
('Golf');

insert into Shoe_Categories(shoe_id, category_id) values
(1,4),
(1,3),
(2,4),
(3,3),
(4,3),
(5,6),
(7,1),
(8,2);

insert into Customers(namn) values
('Marcel Ghostine'),
('Sam Hellgren'),
('Kalle Holm'),
('Oliver Dahlgren'),
('Philip Benani'),
('Bella Giordgi');

insert into Orders (customer_id, datum) values
(1, "2021-02-05 12:34:24"),
(2, "2021-06-06 23:54:23"),
(3, "2021-09-22 13:09:06"),
(4, "2021-12-06 15:54:09"),
(5, "2022-01-05 17:11:33"),
(1, "2022-01-23 21:22:23");


insert into Order_items(quantity, shoe_id, order_id ) values
(1,1,1), -- Ecco skor marcel 
(2,1,2), -- Ecco skor Sam
(1,2,3),
(1,3,5),
(1,4,4),
(1,5,6);

-- ------------------------------------- 

SELECT Customers.namn
FROM Orders
INNER JOIN Order_items ON Orders.id = Order_items.order_id
INNER JOIN Shoes ON Order_items.shoe_id = Shoes.id
INNER JOIN Customers ON Orders.customer_id = Customers.id
WHERE Shoes.namn = 'Ecco' AND Shoes.size = 38 AND Shoes.color = 'red';

-- ------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE AddToCart(IN customer_id INT, IN order_id INT, IN shoe_id INT)
BEGIN
DECLARE existsOrder INT;
SELECT COUNT(id) INTO existsOrder FROM orders WHERE id = order_id;

IF existsOrder = 0 OR order_id IS NULL THEN
INSERT INTO orders (customer_id, datum) VALUES (customer_id, NOW());
SET order_id = LAST_INSERT_ID();
END IF;

INSERT INTO order_items (order_id, shoe_id, quantity)
VALUES (order_id, shoe_id, 1)
ON DUPLICATE KEY UPDATE quantity = quantity + 1;

UPDATE shoes SET quantity = quantity - 1 where id = shoe_id;
end//

delimiter ;
-- ---------------------------------------------------

select * from Order_items;
select * from Orders;
select * from Shoes;

call AddToCart(1,1,1);
call AddToCart(1,null,1);
call AddToCart(1,50,1);

select * from Order_items;
select * from Orders;
select * from Shoes;