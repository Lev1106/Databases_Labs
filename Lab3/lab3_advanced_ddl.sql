
drop database if exists advanced_lab;
drop table if exists employees;
drop table if exists departments;
drop table if exists projects;
drop table if exists temp_employees;
drop table if exists employee_archive;

-- Part A: Database and Table Setup
-- 1
create database advanced_lab;

\connect advanced_lab
create table employees (
    emp_id serial primary key,
    first_name text,
    last_name text,
    department varchar(50),
    salary int default 0,
    hire_date date,
    status varchar(15) default 'Active'
);

create table departments (
    dept_id serial primary key,
    dept_name varchar(50),
    budget int,
    manager_id int
);

create table projects (
    project_id serial primary key,
    project_name varchar(50),
    dept_id int,
    start_date date,
    end_date date,
    budget int
);


-- Part B: Advanced INSERT Operations
-- 2
insert into employees (emp_id, first_name, last_name, department)
values (1, 'Lev', 'Beloussov', 'HR');

-- 3
insert into employees (emp_id, first_name, last_name, department, salary, hire_date, status)
values (2, 'John', 'Johnson', 'IT', default, '2025-09-30', default);

-- 4
insert into departments (dept_name)
values ('IT'),
       ('HR'),
       ('Marketing');

-- 5
insert into employees (emp_id, first_name, last_name, department, salary, hire_date)
values ( 3, 'Dwayne', 'Johnson', 'IT', 50000 * 1.1, current_date);

-- 6
create temporary table temp_employees as
    select * from employees where department = 'IT';

-- Part C: Complex UPDATE Operations
-- 7
update employees set salary = salary * 1.1;

-- 8
update employees set status = 'Senior' where salary > 60000 and hire_date < '2020-01-01';

-- 9
update employees set department = case
    when salary > 80000 then 'Management'
    when salary > 50000 then 'Senior'
    else 'Junior'
end;

-- 10
update employees set department = default where status = 'Inactive';

-- 11
update departments set budget =
    (select avg(salary) * 1.2 from employees
    where employees.department = departments.dept_name);

-- 12
update employees set salary = salary * 1.15, status = 'Promoted'
    where department = 'Sales';


-- Part D: Advanced DELETE Operations
-- 13
delete from employees where status = 'Terminated';

-- 14
delete from employees where salary < 40000 and hire_date > '2023-01-01' and department is null;

-- 15
delete from departments where dept_name not in
    (select distinct department from employees where department is not null);






-- Inserts for future tasks
insert into projects (project_name, dept_id, start_date, end_date, budget)
values
  ('HR Organizing', 2, '2019-03-03', '2020-06-11', 30000),
  ('Mobile Application', 1, '2024-10-02', '2026-12-31', 90000);
insert into employees (emp_id, first_name, last_name, department, salary, hire_date, status)
values
  (21, 'Brad',  'Pitt',  'Marketing', 40000, '2023-11-11', 'Active'),
  (22, 'Joe',  'Biden',  'IT', 60000, '2022-06-15', 'Inactive'),
  (23, 'Christopher',  'Nolan',  'Senior', 5555, '2012-12-12', 'Active'),
  (24, 'Name',  'Surname',  'Middle', 567890, '2021-08-31', 'Active');




-- 16
delete from projects where end_date < '2021-01-01' returning *;


-- Part E: Operations with NULL Values
-- 17
insert into employees (emp_id, first_name, last_name, department, salary)
values (4, 'Ryan', 'Gosling', null, null);

-- 18
update employees set department = 'Unassigned' where department is null;

-- 19
delete from employees where salary is null or department is null;


-- Part F: RETURNING Clause Operations
-- 20
insert into employees (emp_id, first_name, last_name, department, salary)
values (5, 'Donald', 'Trump', 'Unassigned', null)
returning emp_id || first_name || last_name;

-- 21
update employees set salary = salary + 5000 where department = 'IT'
returning emp_id, salary - 5000 as old_salary, salary as new_salary;

-- 22
delete from employees where hire_date < '2020-01-01' returning *;


-- Part G: Advanced DML Patterns
-- 23
insert into employees (emp_id, first_name, last_name, department, salary)
select 6, 'Lightning', 'McQueen', 'Unassigned', null
where not exists (select * from employees where first_name = 'Lightning' and last_name = 'McQueen');

-- 24
update employees set salary = salary * (
    case
        when departments.budget > 100000 then 1.10
        else 1.05
        end
    )
from departments
where employees.department = departments.dept_name;
-- 25
insert into employees (emp_id, first_name, last_name, department, salary, status)
values (7, 'Uvuvwevwe Onyetenyevwe Ugwemuhwem', 'Osas', 'Marketing', 694200, 'New'),
       (8, 'Sponge Bob', 'Square Pants', 'HR', 98765, 'New'),
       (9, 'Squidward', 'Tentacles', 'IT', 300000, 'New'),
       (10, 'Light', 'Yagami', 'Marketing', 10000, 'New'),
       (11, 'Br Br', 'Patapim', 'HR', 80000, 'New');
UPDATE employees
SET salary = salary * 1.1
WHERE status = 'New';

-- 26
create table employee_archive as
    select * from employees
    where status = 'Inactive';
delete from employees where status = 'Inactive';

-- 27
update projects set end_date = end_date + 30
    from departments where projects.dept_id = departments.dept_id
    and projects.budget > 50000
    and (
        select count(*)
        from employees
        where department = departments.dept_name
    ) > 3;