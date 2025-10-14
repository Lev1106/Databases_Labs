-- Beloussov Lev
-- ID: 24B031004

drop table if exists employees;
drop table if exists products_catalog;
drop table if exists bookings;
drop table if exists order_details;
drop table if exists orders;
drop table if exists customers;
drop table if exists inventory;
drop table if exists users;
drop table if exists course_enrollments;
drop table if exists student_courses;
drop table if exists employees_dept;
drop table if exists departments;
drop table if exists books;
drop table if exists publishers;
drop table if exists authors;
drop table if exists order_items;
drop table if exists orders;
drop table if exists products_fk;
drop table if exists categories;


-- Task 1.1
create table employees (
    employee_id int,
    first_name text,
    last_name text,
    age int check (age between 18 and 65),
    salary numeric check (salary > 0)
);

-- Task 1.2
create table products_catalog (
    product_id int,
    product_name text,
    regular_price numeric,
    discount_price numeric,
    constraint valid_discount check (regular_price > 0 and discount_price > 0 and discount_price < regular_price)
);

-- Task 1.3
create table bookings (
    booking_id int,
    check_in_date date,
    check_out_date date,
    num_guests int
    check (num_guests between 1 and 10 and check_out_date > check_in_date)
);

-- Task 1.4

-- Valid
insert into employees (first_name, last_name, age, salary) values
('John', 'Johnson', 25, 50000),
('Lev', 'Beloussov', 18, 100000);
insert into products_catalog (product_name, regular_price, discount_price) values
('Phone', 40000, 35000),
('Fridge', 555555, 222222);
insert into bookings (check_in_date, check_out_date, num_guests) values
('2025-10-10', '2025-10-16', 10),
('2012-12-12', '2013-01-01', 7);

-- Invalid
/*
insert into employees (first_name, last_name, age, salary) values
('Retiree', 'Retired', 69, 77777); -- Age check is violated, must be 18...65
insert into employees (first_name, last_name, age, salary) values
('Intern', 'Internship', 19, 0); -- Salary check is violated, must be > 0

insert into products_catalog (product_name, regular_price, discount_price) values
('Scam', 100, 120); -- Prices check is violated, must be less than regular
insert into products_catalog (product_name, regular_price, discount_price) values
('Fidget spinner', 200, 0); -- Discount price check is violated, must be > 0
insert into products_catalog (product_name, regular_price, discount_price) values
('Labubu', -3, 1234567); -- Regular price check is violated, must be > 0

insert into bookings (check_in_date, check_out_date, num_guests) values
('2025-10-17', '2025-11-11', 0); -- Check of number of guests is violated, must be > 0
insert into bookings (check_in_date, check_out_date, num_guests) values
('2026-01-01', '2025-02-02', 35); -- Dates check is violated, check_in_date must be before check_out_date
*/

-- Task 2.1
create table customers (
    customer_id int not null,
    email text not null,
    phone text,
    registration_date date not null
);

-- Task 2.2
create table inventory (
    item_id int not null,
    item_name text not null,
    quantity int not null check (quantity >= 0),
    unit_price numeric not null check (unit_price > 0),
    last_updated timestamp not null
);

-- Task 2.3

-- Valid
insert into customers (customer_id, email, phone, registration_date) values
(1, 'employee1@gmail.com', '+7-777-666-55-44', '2025-06-30'),
(2, 'lev.blsv@yandex.kz', '+7-000-123-34-45', '2025-10-14');
insert into inventory (item_id, item_name, quantity, unit_price, last_updated) values
(1, 'SSD', 225, 9.99, '2025-05-25'),
(2, 'Monitor', 40, 29000.00, '2024-10-10');

-- Invalid
/*
insert into customers (customer_id, email, phone, registration_date) values
(null, 'anonymous@mail.ru', '112', '2025-09-06'); -- customer id is null
insert into customers (customer_id, email, phone, registration_date) values
(3, null, '329-54-67', '2025-10-10'); -- email is null
insert into customers (customer_id, email, phone, registration_date) values
(4, 'qwerty@example.com', '8-800-555-35-35', null); -- registration date is null

insert into inventory (item_id, item_name, quantity, unit_price, last_updated) values
(null, 'Tablet', 2, 456, '2025-07-06'); -- item id is null
insert into inventory (item_id, item_name, quantity, unit_price, last_updated) values
(3, null, 1, 6.9, '2020-03-21'); -- item name is null
insert into inventory (item_id, item_name, quantity, unit_price, last_updated) values
(4, 'USB', 19, null, now()); -- unit price is null
insert into inventory (item_id, item_name, quantity, unit_price, last_updated) values
(5, 'Contraband',  50, 1.99, null); --last updated timestamp is null
*/

-- Task 3.1
create table users (
    user_id int,
    username text unique,
    email text unique,
    created_at timestamp
);

-- Task 3.2
create table course_enrollments (
    enrollment_id int,
    student_id int,
    course_code text,
    semester text,
    unique (student_id, course_code, semester)
);

-- Task 3.3
alter table users
add constraint unique_username unique (username),
add constraint unique_email unique (email);

insert into users (user_id, username, email, created_at) values
(1, 'lev1106', 'lev2.blsv@gmail.com', '2024-02-29'),
(2, 'test_nickname', 'test_email@yahoo.com', '2025-04-01');

/*
insert into users (user_id, username, email, created_at) values
(3, 'lev1106', 'lev.blsv@gmail.com', '2018-12-31'); -- unique_username is violated
insert into users (user_id, username, email, created_at) values
(4, 'tigr2217', 'test_email@yahoo.com', '2025-08-08'); -- unique_email is violated
*/

-- Task 4.1
create table departments (
    dept_id int primary key,
    dept_name text not null,
    location text
);
insert into departments (dept_id, dept_name, location) values
(1, 'IT', 'Almaty'),
(2, 'SMM', 'Los Angeles'),
(3, 'Marketing', 'Saint Petersburg');

/*
insert into departments (dept_id, dept_name, location) values
(1, 'HR', 'Astana'); -- dept_id is duplicated, violated
insert into departments (dept_id, dept_name, location) values
(null, 'Design', 'Beijing');
*/

-- Task 4.2
create table student_courses (
    student_id int,
    course_id int,
    enrollment_date date,
    grade text,
    primary key (student_id, course_id)
);

-- Task 4.3
/*
1. UNIQUE gives only uniqueness, NULL values can take place. PRIMARY KEY gives uniqueness + NOT NULL
2. Single-column primary key can be applied if we have some identifier for every row.
Otherwise, when uniqueness can be defined only by combining few values, then composite primary key is used
3. PRIMARY KEY is main identifier of all table. Only one column or few column can be assigned as main.
UNIQUE is additional constraint. It can be set separately for some columns, so multiple are allowed.
 */


-- Task 5.1
create table employees_dept (
    emp_id int primary key,
    emp_name text not null,
    dept_id int references departments,
    hire_date date
);
insert into employees_dept (emp_id, emp_name, dept_id, hire_date) values
(1, 'Employee with valid department', 2, '2025-10-01');
/*
insert into employees_dept (emp_id, emp_name, dept_id, hire_date) values
(2, 'Employee without department', 6, '2025-03-31');
*/

-- Task 5.2
create table authors (
    author_id int primary key,
    author_name text not null,
    country text
);
create table publishers (
    publisher_id int primary key,
    publisher_name text not null,
    city text
);
create table books (
    book_id int primary key,
    title text not null,
    author_id int references authors,
    publisher_id int references publishers,
    publication_year int,
    isbn text unique
);

insert into authors (author_id, author_name, country) values
(1, 'Ray Bradbury', 'USA'),
(2, 'Fedor Dostoevsky', 'Russia'),
(3, 'George Orwell', 'UK');

insert into publishers (publisher_id, publisher_name, city) values
(1, 'Almatykitap', 'Almaty'),
(2, 'Oxford University Press', 'UK'),
(3, 'Penguin Random House', 'UK');

insert into books (book_id, title, author_id, publisher_id, publication_year, isbn) values
(1, 'Crime and Punishment', 2, 3, 1866, '34985729384'),
(2, '1984', 3, 2, 1949, '24987289349'),
(3, 'Fahrenheit 451', 1, 1, 1953, '2394872934892');


-- Task 5.3
create table categories (
    category_id int primary key,
    category_name text not null
);
create table products_fk (
    product_id int primary key,
    product_name text not null,
    category_id int references categories on delete restrict
);
create table orders (
    order_id int primary key,
    order_date date not null
);
create table order_items (
    item_id int primary key,
    order_id int references orders on delete cascade,
    product_id int references products_fk,
    quantity int check (quantity > 0)
);

insert into categories (category_id, category_name) values
(1, 'Electronics'),
(2, 'Board games');
insert into products_fk (product_id, product_name, category_id) values
(1, 'Headphones', 1),
(2, 'Speakers', 1),
(3, 'Mafia', 2);
insert into orders (order_id, order_date) values
(1, '2025-10-14'),
(2, '2025-10-13');
insert into order_items (item_id, order_id, product_id, quantity) values
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 2, 3, 1);

-- 1)
--delete from categories where category_id = 2; -- fails because of RESTRICT

-- 2)
select * from order_items where order_id = 1;
delete from orders where order_id = 1;
select * from order_items where order_id = 1;

/*
In case 1), deleting category has failed, because foreign key is set on delete restrict, which prevents it from deleting,
and there are rows in products_fk with category_id = 2
In case 2), deletion successfully happened, because foreign key is set on delete cascade,
so all linked rows were also deleted automatically.
 */


-- Task 6.1
drop table if exists customers;
drop table if exists products;
drop table if exists order_items;
drop table if exists orders;
drop table if exists order_details;
create table customers (
    customer_id int primary key,
    name text not null,
    email text not null unique,
    phone text,
    registration_date date not null
);
create table products (
    product_id int primary key,
    name text not null,
    description text,
    price numeric not null check (price >= 0),
    stock_quantity int not null check (stock_quantity >= 0)
);
create table orders (
    order_id int primary key,
    customer_id int not null references customers on delete restrict,
    order_date date not null,
    total_amount int not null check (total_amount >= 0),
    status text not null check (status in ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);
create table order_details (
    order_detail_id int,
    order_id int not null references orders on delete cascade ,
    product_id int not null references products on delete restrict,
    quantity int not null check (quantity > 0),
    unit_price numeric not null check (unit_price >= 0)
);

insert into customers (customer_id, name, email, phone, registration_date) values
(1, 'Bob', 'bob@sponge.bob', '+7-777-777-77-77', '2025-01-29'),
(2, 'Squidward', 'squidward@sponge.bob', '123-456-7809', '2024-05-05'),
(3, 'Patrick', 'patrick@crusty.crabs', null, '2025-10-04'),
(4, 'Gary', 'garythesnail@sponge.bob', '666-777-69-420', '2011-11-11'),
(5, 'Sandy', 'sandy@sponge.bob', '+7-766-665-52-21', '2025-10-15');

insert into products (product_id, name, description, price, stock_quantity) values
(1, 'Keyboard', 'Mechanic keyboard', 64.99, 32),
(2, 'Laptop', 'Ultrabook', 228.99, 160),
(3, 'Mouse', 'Logitech Mouse', 54.32, 300),
(4, 'USB Type-C 1m', null, 6.66, 234),
(5, 'Phone Case', 'Universal phone case', 7.77, 100);

insert into orders (order_id, customer_id, order_date, total_amount, status) values
(1, 1, '2025-10-14', 1250, 'pending'),
(2, 2, '2025-10-09', 345, 'processing'),
(3, 3, '2025-09-30', 52.52, 'shipped'),
(4, 1, '2025-10-05', 111.11, 'delivered'),
(5, 5, '2025-10-05', 9999, 'cancelled');

insert into order_details (order_detail_id, order_id, product_id, quantity, unit_price) values
(1, 1, 2, 4, 228.99),
(2, 1, 1, 4, 64.99),
(3, 1, 3, 1, 54.32),
(4, 2, 2, 1, 228.99),
(5, 2, 1, 1, 64.99),
(6, 2, 5, 2, 7.77),
(7, 3, 5, 5, 7.77),
(8, 3, 4, 2, 6.66),
(9, 4, 1, 1, 64.99),
(10, 4, 3, 1, 54.32),
(11, 5, 2, 10, 228.99);

-- email uniqueness violiation
/* insert into customers (customer_id, name, email, phone, registration_date)
values (6, 'Fake Bob', 'bob@sponge.bob', null, '2025-11-11'); */
-- name is null
/* insert into customers (customer_id, name, email, phone, registration_date)
values (7, null, 'noname@no.name', null, '2000-01-01'); */

-- duplicating product_id=1 that is primary key
/* insert into products (product_id, name, description, price, stock_quantity)
values (1, 'Super Ultra Mega Keyboard', 'Fails', 100, 1); */
-- non-negative price violation
/* insert into products (product_id, name, description, price, stock_quantity)
values (999, 'Priceless abstract thing', null, -1, 1000); */
-- non-negative stock_quantity violation
/* insert into products (product_id, name, description, price, stock_quantity)
values (1000, 'Product with wrong stock', 'idk what to write it should fail', 10, -5); */

-- incorrect status
/* insert into orders (order_id, customer_id, order_date, total_amount, status)
values (6, 1, now(), 10.00, 'lost'); */

-- quantity is positive violation
/* insert into order_details (order_detail_id, order_id, product_id, quantity, unit_price)
values (10, 6, 1, 1, 64.99); */
-- non-existent order_id
/* insert into order_details (order_detail_id, order_id, product_id, quantity, unit_price)
values (11, 9999, 1, 1, 66.66); */
-- non-existent product_id
/* insert into order_details (order_detail_id, order_id, product_id, quantity, unit_price)
values (12, 1, 9999, 1, 64.99); */

-- on delete cascase checking
select * from order_details where order_id = 1;
delete from orders where order_id = 1;
select * from order_details where order_id = 1;

-- on delete restrict checking (all are failing)
/* delete from products where product_id = 2;
delete from customers where customer_id = 1; */

-- on delete restrict checking (correct order)
delete from orders where order_id = 4;
delete from customers where customer_id = 1;

-- result after everything
select * from customers;
select * from products;
select * from orders;
select * from order_details;