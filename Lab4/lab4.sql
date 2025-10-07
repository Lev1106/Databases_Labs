drop table if exists assignments;
drop table if exists employees;
drop table if exists projects;

-- Create tables
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE,
    manager_id INTEGER,
    email VARCHAR(100)
);
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    budget NUMERIC(12,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);
CREATE TABLE assignments (
    assignment_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    project_id INTEGER REFERENCES projects(project_id),
    hours_worked NUMERIC(5,1),
    assignment_date DATE
);

-- Insert sample data
INSERT INTO employees (first_name, last_name, department, salary, hire_date, manager_id, email) VALUES
    ('John', 'Smith', 'IT', 75000, '2020-01-15', NULL, 'john.smith@company.com'),
    ('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1, 'sarah.j@company.com'),
    ('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL, 'mbrown@company.com'),
    ('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL, 'emily.davis@company.com'),
    ('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
    ('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3, 'lisa.a@company.com');

INSERT INTO projects (project_name, budget, start_date, end_date, status) VALUES
    ('Website Redesign', 150000, '2024-01-01', '2024-06-30', 'Active'),
    ('CRM Implementation', 200000, '2024-02-15', '2024-12-31', 'Active'),
    ('Marketing Campaign', 80000, '2024-03-01', '2024-05-31', 'Completed'),
    ('Database Migration', 120000, '2024-01-10', NULL, 'Active');

INSERT INTO assignments (employee_id, project_id, hours_worked, assignment_date) VALUES
    (1, 1, 120.5, '2024-01-15'),
    (2, 1, 95.0, '2024-01-20'),
    (1, 4, 80.0, '2024-02-01'),
    (3, 3, 60.0, '2024-03-05'),
    (5, 2, 110.0, '2024-02-20'),
    (6, 3, 75.5, '2024-03-10');


-- Task 1.1
select first_name || ' ' || last_name, department, salary from employees;

-- Task 1.2
select distinct department from employees;

-- Task 1.3
select project_name, budget, case
    when budget > 150000 then 'Large'
    when budget between 100000 and 150000 then 'Medium'
    else 'Small'
end as budget_category
from projects;

-- Task 1.4
select first_name || ' ' || last_name, coalesce(email, 'No email provided') from employees;


-- Task 2.1
select * from employees where hire_date > '2020-01-01';

-- Task 2.2
select * from employees where salary between 60000 and 70000;

-- Task 2.3
select * from employees where last_name like 'S%' or last_name like 'J%';

-- Task 2.4
select * from employees where manager_id is not null and department = 'IT';


-- Task 3.1
select upper(first_name || ' ' || last_name), length(last_name), substring(email, 1, 3) from employees;

-- Task 3.2
select salary * 12 as annual_salary,
       round(salary, 2) as monthly_salary,
       salary * 0.1 as raise_amount from employees;

-- Task 3.3
select format('Project: %s - Budget: $%s - Status: %s', project_name, budget, status) from projects;

-- Task 3.4
select first_name, last_name, hire_date,
       extract(year from age(current_date, hire_date)) as years_in_compnay
from employees;


-- Task 4.1
select department, avg(salary) from employees group by department;

-- Task 4.2
select
    (select project_name
     from projects
     where projects.project_id = assignments.project_id) as project_name,
    sum(hours_worked) as total_hours
from assignments
group by project_id;

-- Task 4.3
select department, count(*) as number_of_employees from employees
group by department having count(*) > 1;

-- Task 4.4
select max(salary) as max_salary,
       min(salary) as min_salary,
       sum(salary) as total_payroll from employees;


-- Task 5.1
select employee_id, first_name || ' ' || last_name as full_name, salary from employees where salary > 65000
union
select employee_id, first_name || ' ' || last_name as full_name, salary from employees where hire_date > '2020-01-01';

-- Task 5.2
select employee_id, first_name || ' ' || last_name as full_name, salary from employees where department = 'IT'
intersect
select employee_id, first_name || ' ' || last_name as full_name, salary from employees where salary > 65000;

-- Task 5.3
select employee_id, first_name || ' ' || last_name as full_name, salary from employees
except
select e.employee_id, e.first_name || ' ' || e.last_name as full_name, salary from employees e
join assignments a on e.employee_id = a.employee_id;


-- Task 6.1
select * from employees e where exists (
    select *  from assignments a
    where a.employee_id = e.employee_id
);

-- Task 6.2
select * from employees e where e.employee_id in (
    select employee_id from assignments a
    where a.project_id in (
        select p.project_id from projects p
        where p.status = 'Active'
    )
);

-- Task 6.3
select * from employees e where e.salary > any (
    select salary from employees where department = 'Sales'
);


-- Task 7.1
select first_name || ' ' || last_name as full_name,
       department,
    (
        select avg(a.hours_worked) from assignments a
        where a.employee_id = employees.employee_id
    ) as average_hours,
    salary,
    (
        select count(*) from employees e where e.department = employees.department
                                          and e.salary >= employees.salary
    ) as rank
from employees order by department, rank;

-- Task 7.2
select * from (
    select project_name, (
        select sum(a.hours_worked) from assignments a
        where a.project_id = projects.project_id
    ) as total_hours,
    (
        select count(distinct a.employee_id) from assignments a
        where a.project_id = projects.project_id
    ) as number_of_employees
    from projects) as q where total_hours > 150;

-- Task 7.3
select department,
       count(*) as number_of_employees,
       avg(salary) as average_salary,
       max(case when salary = (select max(salary) from employees e where e.department = employees.department) then
           first_name || ' ' || last_name || ' | ' || salary ||
           case
               when greatest(salary, 70000) = salary then ' | High salary'
               when least(salary, 58888) = salary then ' | Low salary'
               else ' | Medium salary'
           end
       end) as highest_paid_employee
from employees
group by department;