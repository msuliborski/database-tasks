USE HR;

-- 1. Show last names and numbers of all managers together with the number of employees that are his / her subortinates.
SELECT last_name,
       employee_id,
       (SELECT COUNT(employee_id) FROM employees WHERE manager_id = quary1.employee_id) AS numberOfSubortinates
FROM employees AS quary1
WHERE employee_id IN (SELECT manager_id FROM employees)

-- 2. Create a report that displays the department name, location name, job title and salary of those employeses who work in a specific (given) location.
SELECT department_name, location_id, last_name, jobs.job_title, employees.salary
FROM departments, employees, jobs
WHERE location_id = 1400

-- 3. Find the number of employees who have a last name that ends with the letter n.
SELECT employee_id, first_name, last_name
FROM employees
WHERE last_name LIKE '%n';

-- 4. Create a report that shows the name, location and the number of employees for each department. Make sure that report also includes departments without employees.
SELECT department_id,
       department_name,
       location_id,
       (SELECT COUNT(*) FROM employees WHERE query1.department_id = department_id)
FROM departments AS query1

-- 5. Show all employees who were hired in the first five days of the month (before the 6th of the month)
SELECT * FROM employees
WHERE  DATEPART(dd, hire_date) >= 1 AND DATEPART(dd, hire_date) <= 5

-- 6. Create a report to display the department number and lowest salary of the department with the highest average salary.
SELECT department_id, MIN(salary) FROM employees WHERE department_id = (SELECT TOP 1 department_id FROM employees GROUP BY department_id ORDER BY AVG(salary) DESC) GROUP BY department_id;

-- 7. Create a report that displays department where no sales representatives work. Include the deprtment number, department name and location in the output.
SELECT * FROM departments
WHERE department_id NOT IN (SELECT department_id FROM employees WHERE job_id = 'SA_REP' AND department_id IS NOT NULL)

-- 8. Display the depatrment number, department name and the number of employees for the department:
-- a. with the highest number of employees.
SELECT department_id, department_name FROM departments
WHERE department_id = (SELECT TOP 1 department_id FROM employees GROUP BY department_id ORDER BY COUNT(employee_id) DESC)
-- b. with the lowest number of employees
SELECT department_id, department_name FROM departments
WHERE department_id = (SELECT TOP 1 department_id FROM employees GROUP BY department_id ORDER BY COUNT(employee_id))
-- c. that employs fewer than three employees.
SELECT department_id, department_name FROM departments
WHERE department_id IN (SELECT department_id FROM employees GROUP BY department_id HAVING COUNT(employee_id) > 5)

-- 9. Display years and total numbers of employees that were employed in that year.
SELECT * FROM employees
WHERE DATEPART(yy, hire_date) = 1991

-- 10. Display countries and number of locations in that country.
SELECT country_name, COUNT(*) FROM countries, locations 
WHERE countries.country_id = locations.country_id GROUP BY country_name;

-- If you have time, complete the following exercises:
-- A1. Create a query to display the employees who earn a salary that is higher than the salary of all the sales managers (JOB_ID = 'SA_MAN'). Sort the results from the highest to the lowest.
-- A2. Display details such as the employee ID, last name, and department ID of those employees who works in cities the names of which begin with 'T'.
-- A3. Write a query to find all employees who earn more than the average salary in their
-- A4. Find all employees who are not sumervisors (managers). Do this using the NOT EXISTS operator.
-- Can it be done using NOT IN operator?
-- A5. Display the last names of the employees who earn less than the average salary in their departments.
-- A6. Display the last names of the employees who have one or more coworkers in their departments with later hire dates but higher salaries.
-- A7. Display the department names of those depatrments whose total salary cost is above one-eight (1/8) of the total salary cost od the whole company. Use the WITH clause to write this query. Name the query SUMMARY.
-- A8. Delete the oldest JOB_HISTORY row of an employee by looking up the JOB_HISTORY table for the MIN(START_DATE) for the employee. Delete the records of only those employees who have changed at least two jobs.





