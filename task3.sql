--1. Determine the structure of all database's tables.
SELECT * FROM countries
SELECT * FROM departments
SELECT * FROM employees
SELECT * FROM job_history
SELECT * FROM jobs
SELECT * FROM locations
SELECT * FROM regions

--2. Display names and salaries of employees.
SELECT first_name, last_name, salary FROM employees;

--3. Display the last name and salary of employees earning more than $12,000.
SELECT last_name, salary FROM employees WHERE salary > 12000;

--4. Display the last name and department number for employee number 176.
SELECT last_name, department_id FROM employees WHERE employee_id = '176';

--5. Display the last name and salary for all employees whose salary is not in the range of $5,000 to $12,000.
SELECT last_name, salary FROM employees WHERE salary NOT BETWEEN 5000 AND 12000;

--6. Display the last name, job ID, and start date (hire date) for the employees with the last names of Matos and Taylor. Order the query in ascending order by start date.
SELECT last_name, job_id, hire_date FROM employees WHERE last_name IN ('Matos', 'Taylor') ORDER BY hire_date ASC

--7. Display the last name and department number of all employees in departments 20 or 50 in ascending alphabetical order by name.
SELECT last_name, department_id FROM employees WHERE department_id IN ('20', '50') ORDER BY last_name ASC

--8. Display the last name and job title of all employees who do not have a manager.
SELECT employees.last_name, jobs.job_title FROM employees, jobs
WHERE employee_id = (SELECT employee_id FROM employees WHERE manager_id IS NULL)
AND employees.job_id = jobs.job_id

--9. Display the last name, salary, and commission for all employees who earn commissions. Sort data in descending order of salary and commissions.
SELECT last_name, salary, commission_pct FROM employees WHERE commission_pct IS NOT NULL ORDER BY salary DESC, commission_pct DESC

--10. Find the highest, lowest, sum, and average salary of all employees. Label the columns Maximum, Minimum, Sum, and Average, respectively.
SELECT MAX(salary) as Maximum, MIN(salary) as Minimum, SUM(salary) as sum, AVG(salary) as average FROM employees

--11. Modify the previous query to display the minimum, maximum, sum, and average salary for each job type (job_id).
SELECT job_id, MAX(salary) as Maximum, MIN(salary) as Minimum, SUM(salary) as sum, AVG(salary) as average FROM employees GROUP BY job_id

--12. Display the number of people with the same job.
SELECT job_id, COUNT(*) as total FROM employees GROUP BY job_id

--13. Determine the number of managers without listing them. Label the column Number of Managers. Hint: Use the MANAGER_ID column to determine the number of managers.
SELECT COUNT(DISTINCT manager_id) as numberOfManagers FROM employees

--14. Find the difference between the highest and lowest salaries. Label the column DIFFERENCE.
SELECT MAX(salary) - MIN(salary) as difference FROM employees

--15. Find the addresses of all the departments. Use the LOCATIONS and COUNTRIES tables. Show the location ID, street address, city, state or province, and country in the output.
SELECT locations.location_id, locations.street_address, locations.city, locations.state_province, countries.country_name FROM locations, countries 
WHERE locations.country_id = countries.country_id;

--16. Display the last name and department name for all employees.
SELECT employees.last_name, departments.department_name FROM employees, departments 
WHERE employees.department_id = departments.department_id; 

--17. Display the last name, job, department number, and department name for all employees who work in Toronto.
SELECT employees.last_name, employees.job_id, employees.department_id, departments.department_name FROM employees, departments 
WHERE employees.department_id = departments.department_id 
AND departments.department_id IN 
(SELECT departments.department_id FROM departments, locations 
WHERE departments.location_id = locations.location_id AND locations.city = 'Toronto');

--If you have time, complete the following exercises:
--1A. Create a report to display the manager number and the salary of the lowest-paid employee for that manager. Exclude and groups where the minimum salary is $6000 or less. Sort the output in descending order of salary.
--2A. The HR department wants to determine the names of all employees who were hired after Davies. Create a query to display the name and hire date of any employee hired after employee Davies.
--3A. The HR department needs to find the names and hire dates for all employees who were hired before their managers, along with their managers' names and hire dates
--4A. Create a report that displays the employee number, last name, and salary of all employees who earn more than the avarage salary. Sort the results in order of ascending salary.
--5A. Write a query that displays the employee number and last name of all employees who work in a depatrment with any employee whose last name starts with "U"
--6A. Create a report for HR that displays the last name and salary of every employee who reports to King.
--7A. For budgeting purposes, the HR depatrment needs a report on projected 10% raises. The report shoud display those employees who have no commisions