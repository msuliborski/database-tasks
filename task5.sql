use test_empl;

-- 1. Get names and salaries of employees
SELECT name, salary
FROM employees;

-- 2. Get names and daily salaries of employees
SELECT name, salary / 30 AS daily_salary
FROM employees;

-- 3. Get names and yearly salaries of employees
SELECT name, salary * 12 AS yearly_salary
FROM employees;

-- 4. Get the minimal salary in the table employees
SELECT MIN(salary) AS min_salary
FROM employees;

-- 5. Get the name, job, and salary of the employee with the smallest salary
SELECT name, job, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- 6. Get names, jobs and salaries of employees who earn less than the average salary in the enterprise
SELECT name, job, salary
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees);

-- 7. For each department get the number of employees
SELECT id_dep, COUNT(id_dep)
FROM employees
GROUP BY(id_dep);

use test_empl;
-- 8. For each department and for each job get the number of employees
SELECT id_dep, job, COUNT(*) AS employees
FROM employees
GROUP BY id_dep, job;
-- 9. Get names and salaries of employees who earn more than any employee working in depeartment 30
SELECT name, salary
FROM employees
WHERE salary > (SELECT MAX(salary) FROM employees WHERE id_dep = 30);

-- 10. For every employee get his name, salary and the difference between his salary and the average salary in the enterprise
SELECT name,
       salary,
       ABS(salary - (SELECT AVG(salary) AS difference
                     FROM employees
       )) AS difference
FROM employees

-- 11. For every department get its name and the average salary
SELECT departments.name, AVG(salary) AS avg_salary
FROM employees,
     departments
WHERE departments.name = (SELECT name FROM departments WHERE employees.id_dep = departments.id_dep)
GROUP BY departments.name;

-- 12. Get the name, id_dep and salary of employees who earn more than the average salary in their departments
SELECT name, id_dep, salary
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees,
                     departments
                WHERE departments.id_dep = employees.id_dep)

-- 13. Get the names of employees who have subordinate employees
SELECT name
FROM employees
WHERE num_id IN (SELECT boss FROM Employees)

-- 14. Get the identifier and the name of the department without employees
SELECT id_dep, name
FROM departments
WHERE 0 = (SELECT COUNT(*) FROM employees WHERE departments.id_dep = employees.id_dep)

-- 15. Insert a new employee with the following attributes: (num_id -9781, Name -Hurst, job -ACCOUNTANT, boss - 9235, start_date - today, salary 1150, id_dep – 70)
INSERT INTO employees
VALUES (9781, 'Hurst', 'ACCOUNTANT', 9235, GETDATE(), null, 1150, null, null, 70)

-- 16. Insert a new employee with the following attributes: (num_id -9782, Name -Cooper, job -LOGISTICIAN, boss - 9332, start_date - today+12 days, salary 1200)
INSERT INTO employees
VALUES (9782, 'Cooper', 'LOGISTICIAN', 9332, DATEADD(DAY, 30, GETDATE()), null, 1200, null, null, null)

-- 17. Change the job of operators to sellers in department 50 and increase their salary by 10%
UPDATE employees
SET job    = 'SELLER',
    salary = salary * 1.1
WHERE id_dep = 50
  AND job = 'OPERATOR'

-- 18. For all employees who have subordinate employees increase the bonus by 10% of the smallest salary
UPDATE employees
SET bonus = bonus + 0.1 * (SELECT MIN(salary) FROM employees)
WHERE num_id IN (SELECT boss FROM Employees)


-- 19. Delete the logistician with the shortest period of employment
DELETE FROM employees
WHERE start_date = (SELECT MAX(start_date) FROM employees WHERE job = 'LOGISTICIAN')
