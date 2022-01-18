--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries,
                     employees,
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL   AUTO_INCREMENT,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     INT         NOT NULL    AUTO_INCREMENT,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      INT         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     INT         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
)
;

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;


        -- create employees

        INSERT INTO employees (first_name, last_name , gender , hire_date, birth_date) values 
        ('Andres', 'Palomares', 'M','2020-09-09','1987-09-19'),
        ('Mario', 'Bross', 'M','2019-09-09','2003-09-19'),
        ('Federico', 'Rico', 'M','2019-09-09','2006-09-19'),
        ('Hugo', 'Boss', 'M','2019-09-09','2001-09-19'),
        ('Maria', 'Galleta', 'F','2019-09-09','1972-09-19'),
        ('Paca', 'Raca', 'F','2019-09-09','1974-09-19'),
        ('Valentina', 'Filipina', 'F','2019-09-09','1995-09-19'),
        ('Olivia', 'Palotes', 'F','2019-09-09','1985-09-19'),
        ('Gonzalo', 'Cachon', 'M','2019-09-09','1990-09-19'),
        ('Juanito', 'Sanchez', 'M','2019-09-09','1986-09-19'),
        ('Laura', 'Morales', 'F','2019-09-09','1985-09-19'),
        ('Daniela', 'Serrano', 'F','2019-09-09','1999-09-19');

        -- create salary range 1

        INSERT INTO salaries (emp_no ,salary , from_date, to_date ) values
        (1 , 5500 , '2015-01-01', '2020-01-01'),
        (2 , 5500 , '2015-01-01', '2020-01-01'),
        (3 , 5500 , '2015-01-01', '2020-01-01'),
        (4 , 5500 , '2015-01-01', '2020-01-01'),
        (5 , 5000 , '2015-01-01', '2020-01-01'),
        (6 , 6500 , '2015-01-01', '2020-01-01'),
        (7 , 8500 , '2015-01-01', '2020-01-01'),
        (8, 5000 ,' 2015-01-01', '2020-01-01'),
        (9, 5000 ,' 2015-01-01', '2020-01-01'),
        (10, 5000 ,' 2015-01-01', '2020-01-01'),
        (11, 5000 ,' 2015-01-01', '2020-01-01'),
        (12, 5000 ,' 2015-01-01', '2020-01-01');


        -- create salary range 2

        INSERT INTO salaries (emp_no ,salary , from_date, to_date ) values
        (1 , 7500 , '2020-01-01', '2023-01-01'),
        (2 , 7500 , '2020-01-01', '2023-01-01'),
        (3 , 7500 , '2020-01-01', '2023-01-01'),
        (4 , 7500 , '2020-01-01', '2023-01-01'),
        (5 , 8500 , '2020-01-01', '2023-01-01'),
        (6 , 8500 , '2020-01-01', '2023-01-01'),
        (7 , 8500 , '2020-01-01', '2023-01-01'),
        (8 , 9500 , '2020-01-01', '2023-01-01'),
        (9 , 9500 , '2020-01-01', '2023-01-01'),
        (10, 9500 ,' 2020-01-01', '2023-01-01'),
        (11, 9500 ,' 2020-01-01', '2023-01-01'),
        (12, 9500 ,' 2020-01-01', '2023-01-01');


        -- create dep emp

        INSERT INTO departments (dept_name) values
        ('diseño'),
        ('desarrollo'),
        ('calidad'),
        ('informatica');

        -- create dep emp

        INSERT INTO dept_emp (emp_no ,dept_no , from_date, to_date ) values
        (1 , 1 , '2020-01-01', '2023-01-01'),
        (4 , 2 , '2020-01-01', '2023-01-01'),
        (7 , 3 , '2020-01-01', '2023-01-01'),
        (10, 4 , '2020-01-01', '2023-01-01'),
        (11, 4 , '2020-01-01', '2023-01-01'),
        (2 , 1 , '2020-01-01', '2023-01-01'),
        (5 , 3 , '2020-01-01', '2023-01-01'),
        (9 , 4 , '2020-01-01', '2023-01-01'),
        (12, 3 , '2020-01-01', '2023-01-01'),
        (3 , 1 , '2020-01-01', '2023-01-01'),
        (6 , 3 , '2020-01-01', '2023-01-01'),
        (8 , 3 , '2020-01-01', '2023-01-01');


         INSERT INTO dept_emp (emp_no ,dept_no , from_date, to_date ) values
        (1 , 2 , '2020-01-01', '2023-01-01'),
        (4 , 1 , '2020-01-01', '2023-01-01'),
        (7 , 2 , '2020-01-01', '2023-01-01'),
        (10, 2 , '2020-01-01', '2023-01-01'),
        (11, 2 , '2020-01-01', '2023-01-01'),
        (2 , 3 , '2020-01-01', '2023-01-01'),
        (5 , 1 , '2020-01-01', '2023-01-01'),
        (9 , 2 , '2020-01-01', '2023-01-01'),
        (12, 1 , '2020-01-01', '2023-01-01'),
        (3 , 2 , '2020-01-01', '2023-01-01'),
        (6 , 1 , '2020-01-01', '2023-01-01'),
        (8 , 2 , '2020-01-01', '2023-01-01');

-- create dep manager

        INSERT INTO dept_manager (emp_no ,dept_no , from_date, to_date ) values
        (1 , 1 , '2020-01-01', '2023-01-01'),
        (2 , 2 , '2020-01-01', '2023-01-01'),
        (3 , 3 , '2020-01-01', '2023-01-01'),
        (4 , 4 , '2020-01-01', '2023-01-01'),
        (5 , 1 , '2020-01-01', '2023-01-01'),
        (9 , 2 , '2020-01-01', '2023-01-01');

        INSERT INTO dept_manager (emp_no ,dept_no , from_date, to_date ) values
        (1 , 2 , '2020-01-01', '2023-01-01'),
        (2 , 3 , '2020-01-01', '2023-01-01'),
        (3 , 4 , '2020-01-01', '2023-01-01'),
        (4 , 1 , '2020-01-01', '2023-01-01'),
        (5 , 2 , '2020-01-01', '2023-01-01'),
        (9 , 3 , '2020-01-01', '2023-01-01');

        INSERT INTO title (emp_no ,dept_no , from_date, to_date ) values
        (1 , 2 , '2020-01-01', '2023-01-01'),
        (2 , 3 , '2020-01-01', '2023-01-01'),
        (3 , 4 , '2020-01-01', '2023-01-01'),
        (4 , 1 , '2020-01-01', '2023-01-01'),
        (5 , 2 , '2020-01-01', '2023-01-01'),
        (9 , 3 , '2020-01-01', '2023-01-01');

-- create titles

        INSERT INTO titles (emp_no ,title , from_date, to_date ) values
        (1 , "designer" , '2015-01-01', '2020-01-01'),
        (2 , "engineer" , '2015-01-01', '2020-01-01'),
        (3 , "IT" , '2015-01-01', '2020-01-01'),
        (4 , "designer" , '2015-01-01', '2020-01-01'),
        (5 , "designer" , '2015-01-01', '2020-01-01'),
        (6 ,"engineer" , '2015-01-01', '2019-01-01'),
        (7 , "engineer" , '2015-01-01', '2019-01-01'),
        (8 , "designer" , '2015-01-01', '2019-01-01'),
        (9 , "IT" , '2015-01-01', '2021-01-01'),
        (10, "designer" ,' 2015-01-01', '2021-01-01'),
        (11, "IT" ,' 2015-01-01', '2021-01-01'),
        (12, "engineer" ,' 2015-01-01', '2021-01-01');

-- update employee. change name

UPDATE `employees` SET `first_name` = 'federico', `gender` = 'M' 
WHERE `employees`.`first_name` = 'Federica'AND `employees`.`last_name` = 'Rico';

-- update employee. update the dept_names.

update `departments` set `dept_name` = 'depss'
where `departments`.`dept_name` = "devOps";
update `departments` set `dept_name` = 'Developer'
where `departments`.`dept_name` = "desarrollo";


-- get data
--select all employees with a salary greater than 20 000

select  `employees`.* , `salaries`.`salary`
from `employees`
left join `salaries` on `salaries`.`emp_no` =  `employees`.`emp_no`
where `salaries`.`salary` > 8000;

-- between
SELECT `employees`.`first_name`, `salaries`.`salary`
FROM `employees` 
	LEFT JOIN `salaries` ON `salaries`.`emp_no` = `employees`.`emp_no`
WHERE `salaries`.`salary` BETWEEN 5000 and 8000;

-- total numbers of employees

select count(emp_no) from employees;



-- select each employee who has more than 2 departments

SELECT `emp_no`, count(*)
from `dept_emp`
GROUP by `pepe`
having count(*)>1;

-- Select  number of employees who have worked in more than one department

select count(*) as total_duplicados from (
SELECT `emp_no`, count(*)
from `dept_emp`
GROUP by `emp_no`
having count(*)>1
) as ver;   -- PREGUNTAR PEEL HELPING;

-- Select the titles of the year 2019 

select *  from `titles` where `titles`.`to_date` = year('2019'); -- PREGUNTAR PEEL HELPING;

SELECT `titles`.*, `titles`.`to_date` FROM `titles`
WHERE `titles`.`to_date` = '2019-01-01';

SELECT `titles`.*, `titles`.`to_date`
FROM `titles`
WHERE `titles`.`to_date` REGEXP '2019';

--Select only the name of the employees in capital letters

select upper(employees.first_name) from employees  -- PREGUNTAR PEEL HELPING;

--Select the name, surname and name of the current department of each employee

select `employee`.`last_name`,`employee`.`First_name`, 


--Select the name, surname and number of times the employee has worked as a manager

SELECT `employees`.`first_name`, `dept_emp`.`dept_no`, `departments`.`dept_name`
FROM `employees` 
	LEFT JOIN `dept_emp` ON `dept_emp`.`emp_no` = `employees`.`emp_no` 
	LEFT JOIN `departments` ON `dept_emp`.`dept_no` = `departments`.`dept_no`;

--- --Select the name, surname and name of the current department of each employee

SELECT E.first_name, E.last_name, D.dept_name
  FROM employees E 
  JOIN (
    SELECT emp_no, dept_no, from_date 
    FROM dept_emp 
    WHERE from_date IN (
      SELECT MAX(from_date) 
      FROM dept_emp 
      GROUP BY emp_no
    )
  ) recent_depts ON E.emp_no = recent_depts.emp_no 
  JOIN departments D ON recent_depts.dept_no = D.dept_no 
  ORDER BY E.emp_no;


-- delete the department with more 
DELETE FROM departments 
  WHERE dept_no = (
    SELECT dept_no 
    FROM dept_emp 
    WHERE to_date >= CURDATE() 
    GROUP BY dept_no
    ORDER BY COUNT(DISTINCT emp_no) DESC
    LIMIT 1
  );