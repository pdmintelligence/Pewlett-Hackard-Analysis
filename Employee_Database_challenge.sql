
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
	 ORDER BY e.emp_no DESC;
SELECT * FROM mentorship_eligibilty;

