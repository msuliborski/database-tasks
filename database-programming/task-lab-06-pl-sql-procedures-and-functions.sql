-- 1. Create a procedure called ADD_JOB to insert a new job into the JOBS table. Provide the ID and job title using two parameters. invoke the procedure with IT_DBA as the job ID and Database Administrator as the job title. Query the JOBS table and view the results.
create or replace procedure add_job(id hr.jobs.job_id%type, title hr.jobs.job_title%type) is 
begin
    select * from hr.employees
    -- insert into hr.jobs
    -- values (id, title, null, null);
end;

begin
    add_job('IT_DBA', 'Database Administrator');
end;

-- 2. Invoke your procedure again, passing a job ID of ST_MAN and a job title of Stock Manager. What happens and why? Handle the exception.
-- 3. Create a procedure called UPD_JOB to update the job title. Provide the job ID and a new title using two parameters. Include the necessary exception handling if no update occurs. Invoke the procedure to change the job title of the job ID IT_DBA to Data Administrator. Query the JOBS table and view the results.
    -- Test the exception-handling section of the procedure by trying to update a job that does not exist. You can use the job ID IT_WEB and the job title Web Master.
-- 4. Create a procedure called DEL_JOB to delete a job. Include the necessary exception-handling code if no job is deleted. Invoke the procedure using the job ID IT_DBA. Query the JOBS table and view the results.
    -- Test the exception-handling section of the procedure by trying to delete a job that does not exist. Use IT_WEB as the job ID.
-- 5. Create a procedure that returns a value from the SALARY and JOB_ID columns for a specified employee ID. Execute the procedure using an anonymous block with variables for the two OUT parameters—one for the salary and the other for the job ID. Display the salary and job ID for employee ID 120.
    -- Invoke the procedure again, passing an EMPLOYEE_ID of 300 - handle the exception.
-- 6. Create a function called GET_ANNUAL_COMP to return the annual salary computed from an employee’s monthly salary and commission passed as parameters. Use the function in a SELECT statement against the EMPLOYEES table for employees in department 30.
-- 7. Create a procedure, ADD_EMPLOYEE, to insert a new employee into the EMPLOYEES table. The procedure should call a VALID_DEPTID function to check whether the department ID specified for the new employee exists in the DEPARTMENTS table.
    -- Provide the following parameters:
        -- - first_name
        -- - last_name
        -- - email
        -- - job: Use 'SA_REP' as the default.
        -- - mgr: Use 145 as the default.
        -- - sal: Use 1000 as the default.
        -- - comm: Use 0 as the default.
        -- - deptid: Use 30 as the default.
        -- - Use the EMPLOYEES_SEQ sequence to set the employee_id column.
        -- - Set the hire_date column to TRUNC(SYSDATE).
-- 8. Call ADD_EMPLOYEE for the name 'Jane Harris' in department 15 and e-mail 'JAHARRIS', leaving other parameters with their default values. Handle an appropriate exception / exceptions.




















-- NOT MINE 

--Create a procedure called ADD_JOB to insert a new job into the JOBS table. Provide the ID and job title using two parameters. invoke the procedure with IT_DBA as the job ID and Database Administrator as the job title. Query the JOBS table and view the results.
CREATE OR REPLACE PROCEDURE add_job(p_job_id jobs.job_id%TYPE,
                                    p_job_title jobs.job_title%TYPE)
    IS
BEGIN
    INSERT INTO jobs (job_id, job_title)
    VALUES (p_job_id, p_job_title);
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.PUT_LINE('Job with the id of ' || p_job_id || ' already exists.');
END;

BEGIN
    ADD_JOB('IT_DBA', 'Database Administrator');
END;

SELECT *
FROM jobs;

--Invoke your procedure again, passing a job ID of ST_MAN and a job title of Stock Manager. What happens and why? Handle the exception.
BEGIN
    ADD_JOB('ST_MAN', 'Stock Manager');
END;

--Create a procedure called UPD_JOB to update the job title. Provide the job ID and a new title using two parameters. Include the necessary exception handling if no update occurs. Invoke the procedure to change the job title of the job ID IT_DBA to Data Administrator. Query the JOBS table and view the results.
--Test the exception-handling section of the procedure by trying to update a job that does not exist. You can use the job ID IT_WEB and the job title Web Master.
CREATE OR REPLACE PROCEDURE upd_job(p_job_id jobs.job_id%TYPE,
                                    p_job_title jobs.job_title%TYPE)
    IS
    no_update EXCEPTION;
BEGIN
    UPDATE jobs
    SET job_title = p_job_title
    WHERE job_id = p_job_id;
    IF SQL%NOTFOUND THEN
        RAISE no_update;
    END IF;
EXCEPTION
    WHEN no_update THEN
        dbms_output.PUT_LINE('No job with an id of ' || p_job_id);
END;

BEGIN
    upd_job('IT_DBA', 'Data Administrator');
END;

BEGIN
    upd_job('IT_WEB', 'Web Master');
END;

--Create a procedure called DEL_JOB to delete a job. Include the necessary exception-handling code if no job is deleted. Invoke the procedure using the job ID IT_DBA. Query the JOBS table and view the results.
--Test the exception-handling section of the procedure by trying to delete a job that does not exist. Use IT_WEB as the job ID.
CREATE OR REPLACE PROCEDURE del_job(p_job_id jobs.job_id%TYPE)
    IS
    no_delete EXCEPTION;
BEGIN
    DELETE
    FROM jobs
    WHERE job_id = p_job_id;
    IF SQL%NOTFOUND THEN
        RAISE no_delete;
    END IF;
EXCEPTION
    WHEN no_delete THEN
        dbms_output.PUT_LINE('No job with an id of ' || p_job_id);
END;

BEGIN
    del_job('IT_WEB');
END;

--Create a procedure that returns a value from the SALARY and JOB_ID columns for a specified employee ID. Execute the procedure using an anonymous block with variables for the two OUT parameters—one for the salary and the other for the job ID. Display the salary and job ID for employee ID 120.
--Invoke the procedure again, passing an EMPLOYEE_ID of 300 - handle the exception.
CREATE OR REPLACE PROCEDURE get_salary_and_job(p_empl_id employees.employee_id%TYPE,
                                               p_salary OUT employees.salary%TYPE,
                                               p_job_id OUT employees.job_id%TYPE)
    IS
    no_empl_found EXCEPTION;
BEGIN
    SELECT salary, job_id
    INTO p_salary, p_job_id
    FROM employees
    WHERE employee_id = p_empl_id;

    IF SQL%NOTFOUND THEN
        RAISE no_empl_found;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.PUT_LINE('No employee with an id of ' || p_empl_id);
END;

DECLARE
    v_empl_id employees.employee_id%TYPE := 99;
    v_salary  employees.salary%TYPE;
    v_job_id  employees.job_id%TYPE;
    no_data_returned EXCEPTION;
BEGIN
    get_salary_and_job(v_empl_id, v_salary, v_job_id);
    IF v_salary IS NOT NULL AND v_job_id IS NOT NULL THEN
        dbms_output.PUT_LINE(
                    'Employee with id ' || v_empl_id || ' (salary: ' || v_salary || ', ' || 'job_id: ' || v_job_id);
    END IF;
END;

--Create a function called GET_ANNUAL_COMP to return the annual salary computed from an employee’s monthly salary and commission passed as parameters. Use the function in a SELECT statement against the EMPLOYEES table for employees in department 30.
CREATE OR REPLACE FUNCTION get_annual_comp(p_salary employees.salary%TYPE,
                                           p_commission employees.commission_pct%TYPE)
    RETURN NUMBER
    IS
BEGIN
    IF p_commission IS NULL THEN
        RETURN p_salary * 12;
    END IF;
    IF p_commission IS NOT NULL THEN
        RETURN p_salary * 12 + p_commission * 12 * p_salary;
    END IF;
END;

SELECT employee_id, GET_ANNUAL_COMP(salary, commission_pct)
FROM employees
WHERE department_id = 30;

--Create a procedure, ADD_EMPLOYEE, to insert a new employee into the EMPLOYEES table. The procedure should call a VALID_DEPTID function to check whether the department ID specified for the new employee exists in the DEPARTMENTS table.
--Provide the following parameters:
--       first_name
--       last_name
--       email
--       job: Use 'SA_REP' as the default.
--       mgr: Use 145 as the default.
--       sal: Use 1000 as the default.
--       comm: Use 0 as the default.
--       deptid: Use 30 as the default.
--       Use the EMPLOYEES_SEQ sequence to set the employee_id column.
--       Set the hire_date column to TRUNC(SYSDATE)

CREATE OR REPLACE FUNCTION valid_deptid(dep_id employees.department_id%TYPE)
    RETURN BOOLEAN
    IS
    rowcount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO rowcount
    FROM departments
    WHERE department_id = dep_id;

    IF rowcount = 0 THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END;


CREATE OR REPLACE PROCEDURE add_employee(first_name employees.first_name%TYPE,
                                         last_name employees.last_name%TYPE,
                                         email employees.email%TYPE,
                                         job employees.job_id%TYPE DEFAULT 'SA_REP',
                                         mgr employees.manager_id%TYPE DEFAULT 145,
                                         sal employees.salary%TYPE DEFAULT 1000,
                                         comm employees.commission_pct%TYPE DEFAULT 0,
                                         deptid employees.department_id%TYPE DEFAULT 30)
    IS
    dep_not_exists EXCEPTION;
BEGIN
    IF NOT valid_deptid(deptid) THEN
        raise dep_not_exists;
    END IF;
    INSERT INTO employees
    VALUES (employees_seq.nextval, first_name, last_name, email, NULL, TRUNC(SYSDATE), job, sal, comm, mgr, deptid);
EXCEPTION
    WHEN dep_not_exists THEN
        dbms_output.PUT_LINE('Department does not exist: ' || deptid);
END;

BEGIN
    add_employee('Jane', 'Harris', 'JAHARRIS', deptid => 15);
END;