\connect postgres

drop database if exists university_main;
drop database if exists university_archive;

-- alter database university_test is_template false;
drop database if exists university_test;
drop database if exists university_backup;

drop database if exists university_distributed;
drop tablespace if exists student_data;
drop tablespace if exists course_data;


-- Task 1.1
create database university_main
owner postgres
template template0
encoding 'utf8';

create database university_archive
connection limit 50
template template0;

create database university_test
is_template true
connection limit 10;

-- Task 1.2
create tablespace student_data
location '/data/students';

create tablespace course_data
owner postgres
location '/data/courses';

create database university_distributed
tablespace student_data
encoding 'latin9'
lc_ctype 'C'
lc_collate 'C'
template template0;

-- Task 2.1
\connect university_main

drop table if exists students;
drop table if exists professors;
drop table if exists courses;
drop table if exists class_schedule;
drop table if exists student_records;
drop table if exists departments;
drop table if exists grade_scale;
drop table if exists library_books;
drop table if exists student_book_loans;
drop table if exists semester_calendar;


create table students (
    student_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone char(15),
    date_of_birth date,
    enrollment_date date,
    gpa decimal(4, 2),
    is_active boolean,
    graduation_year smallint
);

create table professors (
    professor_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    office_number varchar(20),
    hire_date date,
    salary decimal(10, 2),
    is_tenured boolean,
    years_experience int
);

create table courses (
    course_id serial primary key,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment int,
    course_fee decimal(10, 2),
    is_online boolean,
    created_at timestamp
);

-- Task 2.2
create table class_schedule (
    schedule_id serial primary key,
    course_id int,
    professor_id int,
    classroom varchar(20),
    class_date date,
    start_time time,
    end_time time,
    duration interval
);

create table student_records (
    record_id serial primary key,
    student_id int,
    course_id int,
    semester varchar(20),
    year int,
    grade char(2),
    attendance_percentage numeric(4, 1),
    submission_timestamp timestamptz,
    last_updated timestamptz
);

-- Task 3.1
alter table students
add column middle_name varchar(30),
add column student_status varchar(20),
alter column phone type varchar(20),
alter column student_status set default 'ACTIVE',
alter column gpa set default 0.00;

alter table professors
add column department_code char(5),
add column research_area text,
alter column years_experience type smallint,
alter column is_tenured set default false,
add column last_promotion_date date;

alter table courses
add column prerequisite_course_id int,
add column difficulty_level smallint,
alter column course_code type varchar(10),
alter column credits set default 3,
add column lab_required boolean default false;


-- Task 3.2
alter table class_schedule
add column room_capacity int,
drop column duration,
add column session_type varchar(15),
alter column classroom type varchar(30),
add column equipment_needed text;

alter table student_records
add column extra_credit_points decimal(4, 1),
alter column grade type varchar(5),
alter column extra_credit_points set default 0,
add column final_exam_date date,
drop column last_updated;


-- Task 4.1
create table departments (
    department_id serial primary key,
    department_name varchar(100),
    department_code char(5),
    building varchar(50),
    phone varchar(15),
    budget decimal(10, 2),
    established_year int
);

create table library_books (
    book_id serial primary key,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price decimal(10, 2),
    is_available boolean,
    acquisition_timestamp timestamp
);

create table student_book_loans (
    loan_id serial primary key,
    student_id int,
    book_id int,
    loan_date date,
    due_date date,
    return_date date,
    fine_amount decimal(10, 2),
    loan_status varchar(20)
);


-- Task 4.2
alter table professors
add column department_id int;

alter table students
add column advisor_id int;

alter table courses
add column department_id int;

create table grade_scale (
    grade_id serial primary key,
    letter_grade char(2),
    min_percentage decimal(4, 1),
    max_percentage decimal(4, 1),
    gpa_points decimal(3, 2)
);

create table semester_calendar (
    semester_id serial primary key,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamptz,
    is_current boolean
);


-- Task 5.1
drop table if exists student_book_loans;
drop table if exists library_books;
drop table if exists grade_scale;

create table grade_scale (
    grade_id serial primary key,
    letter_grade char(2),
    min_percentage decimal(4, 1),
    max_percentage decimal(4, 1),
    gpa_points decimal(3, 2),
    description text
);

drop table if exists semester_calendar cascade;
create table semester_calendar (
    semester_id serial primary key,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamptz,
    is_current boolean
);

-- Task 5.2
\connect postgres

alter database university_test is_template false;
drop database if exists university_test;
drop database if exists university_distributed;

create database university_backup
template university_main;