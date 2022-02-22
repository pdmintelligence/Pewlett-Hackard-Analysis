-------------------------------------STEP 1 - creating PH-EMployeeDB-------------------------------

--creating table for departments.csv
CREATE TABLE departments (
     dept_no VARCHAR (4) NOT NULL,
     dept_name VARCHAR (40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

-- creating table for employees.csv

CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

--creating table for dept_manger.csv 

CREATE TABLE dept_manager (
	dept_no VARCHAR (4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

--creating salaries table*.
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

--creating table for titles*.
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--creating table for dep_emp*.
CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR (4) NOT NULL,	
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);


---Importation procedures were executed manually*.

--data was imported manually using postgress interface*.
--testing successful upload and importation of data files*.
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;


--NOTE: Errors detected in files - deleting and recreating them*.
---NOTE: as of 02/10/2022 - no further errors with data;
	--errors were in the way of primary key / foreign keys misidentified; and a variable being assigned 
	--wrong length in one datatable compared to another*.
	--ALL BELOW ELEMENTS ARE CODED OUT***.
--DROP TABLE departments CASCADE;
--DROP TABLE dept_emp CASCADE;
--DROP TABLE employees CASCADE;
--DROP TABLE salaries CASCADE;
--DROP TABLE titles CASCADE;
--DROP TABLE dept_manager CASCADE;

-------------------------------------STEP 2 - Testing Data-------------------------------

--describing data table first**.
SELECT * FROM employees 
ORDER BY first_name DESC;


-------------------------------------STEP 3 - Executing Extractions-------------------------------


--finding those nearing retirment*. 
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';


--Narrowing searches down further**.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--iterating retirement searches on other subpops*.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-------------STEP 4 -----------------adding adjustments to retirement eligbility subpops*.

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


----Taking a querry and returing a NEW TABLE using INTO querry*.
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

--------------Exportation of retirement_info data completed manually*.



----------------STEP 5 - retirement_info table deemed insufficient; - recreating with additional fields------*

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

---NOTE: retirement_info table now has employee identifer information - data exported and saved over original*.

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

--redoing prior joint command on dept and dept manager tables with ALIASES*.
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no=dm.dept_no;

--adding another joint to see if employee is current*.
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirees_Cnt
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


-------------STEP 6 - creating additional lists------------*.
---create list of employee info
---create list of mgmt info
---create list of department retires - IE: employees grouped by dept where data indicate likely retirements*.

--Checking salaries for to_date column*.
SELECT * FROM salaries;
SELECT * FROM salaries
ORDER BY to_date DESC;
--salary date columns appear to be dates related to salaries - not employement*.
--pulling data from dept_emp*.
SELECT * FROM dept_emp;
SELECT * FROM dept_emp
ORDER BY to_date DESC;


--identifying and creating new data file for employees*. 
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM emp_info;

--incorporating information into emp dataframe**.
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');
	

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

--getting list of retiring managers*.
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-----------------lists containing info in the retirement_info table, only tailored for the Sales team.
--creating TABLE SALES_DEPT_DATA containing retiring persons grouped BY dept*. 

SELECT * FROM retirement_info;
SELECT * FROM dept_emp;
SELECT * FROM departments;


--creating requested list of retirees by sales dept*.
SELECT ri.emp_no, ri.first_name, ri.last_name, depts.dept_name
INTO SALES_DEPT_DATA
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
	ON (ri.emp_no=de.emp_no)
INNER JOIN departments AS depts
ON (depts.dept_no = de.dept_no)
WHERE depts.dept_name = 'Sales';

SELECT * FROM SALES_DEPT_DATA
ORDER BY emp_no ASC


--creating requested list of retiress by sales AND Development depts**. 
SELECT ri.emp_no, ri.first_name, ri.last_name, depts.dept_name
INTO SALES_DEV_DEPT_DATA
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
	ON (ri.emp_no=de.emp_no)
INNER JOIN departments AS depts
ON (depts.dept_no = de.dept_no)
WHERE depts.dept_name IN ('Sales','Development');

SELECT * FROM SALES_DEV_DEPT_DATA
ORDER BY emp_no ASC


--These final files were manually exported out as well***.


---------------------------------FINAL SECTION --CHALLENGE*.


---determine the number of retiring employees per title, 
--and identify employees who are eligible to participate in a mentorship program. 

--create a Retirement Titles table that holds all the titles of employees 
--who were born between January 1, 1952 and December 31, 1955. 
--use the DISTINCT ON statement to create a table that contains the most recent title of each employee. 
--use the COUNT() function to create a table that has the CNT of retirement-age employees by recent title*.
--nclude only current employees in our analysis; exclude those employees who have already left the company.

--testing data values*.
SELECT * FROM employees
SELECT * FROM titles

--executing data manipulations for deliverable 1*.
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

SELECT * FROM retirement_titles;

---modifying data manipulations using distrinct on filters to get unique titles*. 
SELECT DISTINCT ON (emp_no) emp_no, first_name,last_name, title
INTO unique_titles
FROM retirement_titles
WHERE (to_date='9999-01-01')
ORDER BY emp_no, to_date DESC;
SELECT * FROM unique_titles;

SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count(emp_no) DESC
SELECT * FROM retiring_titles;

--final section - deliverable 2*.

SELECT * FROM employees
SELECT * FROM titles
SELECT * FROM dept_emp

SELECT DISTINCT ON (e.emp_no)
	e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibilty
FROM employees AS e
INNER JOIN dept_emp as de
ON (e.emp_no=de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no=ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND 
	   '1965-12-31') AND 
	   (de.to_date='9999-01-01')
	 ORDER BY e.emp_no ASC;
SELECT * FROM mentorship_eligibilty;









