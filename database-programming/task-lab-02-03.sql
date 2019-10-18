-- 1. Determine the structure of all HR schema's tables and their contents.


-- 2. Display all unique job IDs from the EMLOYEES table.
select unique job_title from employees 
join jobs on employees.job_id = jobs.job_id;

-- 3. Display the last name and salary of employees who earn more than $15000.
select last_name, salary from employees
where salary > 15000;

-- 4. Display the last name and salary for all employees whose salary is not in the range of $5000 and $12000.
select last_name, salary from employees
where salary > 5000 and salary < 12000;

-- 5. Display the last name and department number of all employees in departments 20 or 50 in ascending alphabetical order by name.
select last_name, department_id from employees
where department_id = 20 or department_id = 50
order by last_name asc;

-- 6. Display the last name and job title of all employees who do not have a manager.
select last_name, job_title from employees
natural join jobs
where manager_id is null;

-- 7. Display last names, ID numbers and their managers’ last names for all employees, including employees who have no managers.
select e.last_name as e_name, e.employee_id as e_id, m.employee_id as m_id from employees e
join employees m on m.employee_id = e.manager_id;

-- 8. Display the last name, salary, and commission for all employees who earn commissions. Sort data in descending order of salary and commissions.
select last_name, salary, commission_pct from employees
where commission_pct is not null
order by salary desc, commission_pct desc;

-- 9. Display the last name, salary, and commission amounts for all employees. If an employee does not earn commission, show “No commission”. Label the column COMM.
select last_name, salary, nvl(to_char(salary * commission_pct), 'No commission') as COMM from employees;

-- 10. Find the highest, lowest, sum, and average salary of all employees. Label the columns Maximum, Minimum, Sum, and Average, respectively.
select max(salary) as Maximum, min(salary) as Minimum, sum(salary) as Sum, avg(salary) as Average from employees;

-- 11. Modify the previous query to display the minimum, maximum, sum, and average salary for each job type (job_id).
select job_id, max(salary) as Maximum, min(salary) as Minimum, sum(salary) as Sum, avg(salary) as Average from employees
group by job_id;

-- 12. Display the number of people with the same job
select job_id, count(*) from employees
group by job_id;

-- 13. Determine the number of managers without listing them. Label the column Number of Managers. Hint: Use the MANAGER_ID column to determine the number of managers.
select count(*) from employees
where employee_id in (select manager_id from employees);

-- 14. Find the difference between the highest and lowest salaries. Label the column DIFFERENCE.
select abs(max(salary) - min(salary)) as DIFFERENCE from employees;

-- 15. Find the addresses of all the departments. Use the LOCATIONS and COUNTRIES tables. Show the location ID, street address, city, state or province, and country in the output.
select locations.location_id, street_address, city, state_province, country_name from locations
join countries on locations.country_id = countries.country_id;

-- 16. Display the last name and department name for all employees.
select last_name, department_name from employees
join departments on departments.department_id = employees.department_id;

-- 17. Display the last name, job, department number, and department name for all employees who work in Toronto.
select last_name, job_id, departments.department_id, department_name from employees
join departments on departments.department_id = employees.department_id
join locations on departments.location_id = locations.location_id
where city = 'Toronto';

-- 18. Create a report to display the manager number and the salary of the lowest-paid employee for that manager. Exclude and groups where the minimum salary is $6000 or less. Sort the output in descending order of salary.



-- 19. The HR department wants to determine the names of all employees who were hired after Davies. Create a query to display the name and hire date of any employee hired after employee Davies.
select last_name, hire_date from employees
where hire_date > (
    select hire_date from employees
    where last_name = 'Davies');
    
-- 20. The HR department needs to find the names and hire dates for all employees who were hired before their managers, along with their managers' names and hire dates.

select last_name as e, manager_id, hire_date from employees aaa
where manager_id in (
    select employee_id from employees
    where employee_id in (select manager_id from employees)) and 
hire_date > (
    select hire_date from employees
    where employee_id = aaa.manager_id);
    
--21. Create a report that displays the employee number, last name, and salary of all employees who earn more than the average salary. Sort the results in order of ascending salary.
select employee_id, last_name, salary from employees
where salary > (select avg(salary) from employees)
order by salary asc;

--22. Write a query that displays the employee number and last name of all employees who work in a department with any employee whose last name starts with "U".
select employee_id, last_name from employees
where department_id in (select department_id from employees where last_name like 'U%');

--23. Create a report for HR that displays the last name and salary of every employee who reports to King.
select last_name, salary from employees
where manager_id in (select employee_id from employees where last_name like 'King');

--24. For budgeting purposes, the HR department needs a report on projected 10% raises. The report should display those employees who have no commissions.
select * from employees
where commission_pct is null;

--25. Show last names and numbers of all managers together with the number of employees that are his / her subordinates.
select e.manager_id, m.last_name, count(e.employee_id) as emp_count from employees e
join employees m on m.employee_id = e.manager_id
group by e.manager_id, m.last_name;

-- 26. Create a report that displays the department name, location name, job title and salary of those employees who work in a specific (given) location.
 select departments.department_name, street_address, job_title, salary from employees
 join departments on departments.department_id = employees.department_id
 join locations on locations.location_id = departments.location_id
 join jobs on jobs.job_id = employees.job_id
 where departments.location_id = 1700;

-- 27. Find the number of employees who have a last name that ends with the letter n.
 select count(*) from employees
 where last_name like '%n';

-- 28. Create a report that shows the name, location and the number of employees for each department. Make sure that report also includes departments without employees.
select department_name, street_address, count(employee_id) from employees
right join departments on departments.department_id = employees.department_id
join locations on locations.location_id = departments.location_id
group by department_name, street_address;


--29. Show all employees who were hired in the first half of the month (before the 16th of the month).
--30. Create a report to display the department number and lowest salary of the department with the highest average salary.
--31. Create a report that displays department where no sales representatives work. Include the department number, department name and location in the output.
--32. Display the department number, department name and the number of employees for the department:
--    - with the highest number of employees.
--    - with the lowest number of employees
--    - that employs fewer than three employees.
--33. Display years and total numbers of employees that were employed in that year.
--34. Display countries and number of locations in that country.
--35. Show all employees who were hired on the day of the week on which the highest number of employees were hired.
--36. Find names of all employees who are not managers.


