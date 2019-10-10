USE HR

--1.
SELECT department_name FROM departments
WHERE department_id IN (SELECT department_id FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees)/2)

--2. 
SELECT COUNT(department_id) FROM departments 
WHERE manager_id IS NULL

-- 3. 
SELECT countries.country_name, COUNT(q1.department_name) AS departments FROM countries,
(SELECT departments.department_name, locations.country_id AS countr_id FROM departments, locations 
WHERE departments.location_id = locations.location_id) AS q1
WHERE countries.country_id = q1.countr_id
GROUP BY countries.country_name

-- 4. 
SELECT city FROM locations
WHERE location_id IN (SELECT location_id FROM departments
WHERE department_id NOT IN (SELECT department_id FROM employees
WHERE department_id IS NOT NULL))

-- 5. 
SELECT employee_id, first_name, last_name FROM employees
WHERE employee_id IN (SELECT employee_id FROM job_history)

-- 6. 
SELECT q1.first_name, q1.last_name, q2.subordinates FROM
(SELECT first_name, last_name, employee_id FROM employees WHERE employee_id IN (SELECT manager_id FROM employees)) AS q1,
(SELECT manager_id, COUNT(*) AS subordinates FROM employees GROUP BY manager_id HAVING COUNT(*) > 10 OR COUNT(*) < 5) AS q2
WHERE q1.employee_id = q2.manager_id
