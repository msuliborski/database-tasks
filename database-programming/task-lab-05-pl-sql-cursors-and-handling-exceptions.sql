-- 1. Write a PL/SQL block to print information about a given country.
    -- Declare a PL/SQL record based on the structure of the countries table.
    -- Declare a variable v_countryid. Assign CA to v_countryid.
    -- In the declarative section, use the %ROWTYPE attribute and declare the v_country_record variable of type countries.
    -- In the executable section, get all the information from the countries table by using v_countryid. Display selected information about the country.

    -- DONE

-- 2. Create a PL/SQL block that does the following:
    -- In the declarative section, declare a variable v_deptno of type NUMBER and assign a value that holds the department ID.
    -- Declare a cursor, c_emp_cursor, that retrieves the last_name, salary, and manager_id of the employees working in the department specified in v_deptno.
    -- In the executable section, use the cursor FOR loop to operate on the data retrieved. If the salary of the employee is less than 5,000 and if the manager ID is either 101 or 124, display the message “<<last_name>> Due for a raise.” Otherwise, display the message “<<last_name>> Not due for a raise.”
declare
    v_deptno number := 10;
    cursor c_emp_cursor is
        select last_name, salary, manager_id from hr.employees
        where department_id = v_deptno;
    v_emp_record c_emp_cursor%rowtype;
begin
    open c_emp_cursor;
        loop 
            fetch c_emp_cursor into v_emp_record;
            exit when c_emp_cursor%notfound;
            if v_emp_record.salary < 5000 and 
                v_emp_record.manager_id = 101 or 
                v_emp_record.manager_id = 124 then
                dbms_output.put_line(v_emp_record.last_name || ' due for a raise.' );
            else 
                dbms_output.put_line(v_emp_record.last_name || ' not due for a raise.' );
            end if;
        end loop;
    close c_emp_cursor;
end;

-- 3. Create a PL/SQL block that determines the top n salaries of the employees. n should be passed as a variable in the block.
declare
    v_max_emps number := 5;
    cursor c_emp_cursor is
        select last_name, salary from hr.employees
        order by salary desc;
    v_emp_record c_emp_cursor%rowtype;
begin
    open c_emp_cursor;
        loop
          fetch c_emp_cursor into v_emp_record;
          exit when c_emp_cursor%notfound or 
        end loop
    close c_emp_cursor;
end;
-- 4. Write a PL/SQL block, which declares and uses cursors with parameters. In a loop, use a cursor to retrieve the department number and the department name from the departments table for a department whose department_id is less than 100. Pass the department number to another cursor as a parameter to retrieve from the employees table the details of employee last name, job, hire date, and salary of those employees whose employee_id is less than 120 and who work in that department.
-- 5. Write a PL/SQL block to select the name of the employee with a given salary value. If the salary entered returns only one row, display employee’s name and the salary amount. If the salary entered does not return any rows or returns more than one row, handle the exception with appropriate exception handlers and messages.
-- 6. Use the Oracle server error ORA-02292 (integrity constraint violated – child record found) to practice how to declare exceptions with a standard Oracle Server error. Create a PL/SQL block that deletes department with employees assigned. Handle the exception.
















-- NOT MINE


SET serveroutput on;

--Write a PL/SQL block to print information about a given country.
--Declare a PL/SQL record based on the structure of the countries table.
--Declare a variable v_countryid. Assign CA to v_countryid.
--In the declarative section, use the %ROWTYPE attribute and declare the v_country_record variable of type countries.
--In the executable section, get all the information from the countries table by using v_countryid. Display selected information about the country.
DECLARE
    v_countryid      countries.country_id%TYPE := 'CA';
    v_country_record countries%ROWTYPE;
BEGIN
    SELECT *
    INTO v_country_record
    FROM countries
    WHERE country_id = v_countryid;

    dbms_output.PUT_LINE(to_char(v_country_record.country_id) || ' ' || v_country_record.country_name);
END;

--Create a PL/SQL block that does the following:
--In the declarative section, declare a variable v_deptno of type NUMBER and assign a value that holds the department ID.
--Declare a cursor, c_emp_cursor, that retrieves the last_name, salary, and manager_id of the employees working in the department specified in v_deptno.
--In the executable section, use the cursor FOR loop to operate on the data retrieved. If the salary of the employee is less than 5,000 and if the manager ID is either 101 or 124, display the message “<<last_name>> Due for a raise.” Otherwise, display the message “<<last_name>> Not due for a raise.”
DECLARE
    v_deptno NUMBER := '10';
    CURSOR c_emp_cursor IS
        SELECT last_name, salary, manager_id
        FROM employees
        WHERE department_id = v_deptno;
    v_empl   c_emp_cursor%ROWTYPE;
BEGIN
    OPEN c_emp_cursor;
    LOOP
        FETCH c_emp_cursor INTO v_empl;
        EXIT WHEN c_emp_cursor%NOTFOUND;
        IF (v_empl.salary < 5000 AND (v_empl.manager_id = 101 OR v_empl.manager_id = 124)) THEN
            dbms_output.PUT_LINE(v_empl.last_name || ' due for a raise.');
        ELSE
            dbms_output.PUT_LINE(v_empl.last_name || ' not due for a raise.');
        END IF;
    END LOOP;
    CLOSE c_emp_cursor;
END;

--Create a PL/SQL block that determines the top n salaries of the employees. n should be passed as a variable in the block.
DECLARE
    v_salaries_count INT := 5;
    CURSOR c_top_salaries IS
        SELECT first_name, last_name, salary
        FROM employees
        FETCH FIRST v_salaries_count ROWS ONLY;
    v_empl           c_top_salaries%ROWTYPE;
    v_counter        INT := 1;
BEGIN
    OPEN c_top_salaries;
    LOOP
        FETCH c_top_salaries INTO v_empl;
        EXIT WHEN c_top_salaries%NOTFOUND;
        dbms_output.PUT_LINE('Top salary no. ' || v_counter || ': ' || v_empl.salary);
        v_counter := v_counter + 1;
    END LOOP;
    CLOSE c_top_salaries;
END;

--Write a PL/SQL block, which declares and uses cursors with parameters. In a loop, use a cursor to retrieve the department number and the department name from the departments table for a department whose department_id is less than 100. Pass the department number to another cursor as a parameter to retrieve from the employees table the details of employee last name, job, hire date, and salary of those employees whose employee_id is less than 120 and who work in that department.
DECLARE
    CURSOR c_deps IS
        SELECT department_id, department_name
        FROM departments
        WHERE department_id < 100;
    CURSOR c_empls (dep_id departments.department_id%TYPE) IS
        SELECT last_name, hire_date, salary
        FROM employees
        WHERE employee_id < 120
          AND department_id = dep_id;
    v_dep  c_deps%ROWTYPE;
    v_empl c_empls%ROWTYPE;
BEGIN
    OPEN c_deps;
    LOOP
        FETCH c_deps INTO v_dep;
        EXIT WHEN c_deps%NOTFOUND;
        OPEN c_empls(v_dep.department_id);
        dbms_output.PUT_LINE('#Employees in dep. id ' || v_dep.department_id || ':');
        LOOP
            FETCH c_empls INTO v_empl;
            EXIT WHEN c_empls%NOTFOUND;
            dbms_output.PUT_LINE('  * employee ' || v_empl.last_name || ', salary: ' || v_empl.salary);
        END LOOP;
        CLOSE c_empls;
    END LOOP;
    CLOSE c_deps;
END;

--Write a PL/SQL block to select the name of the employee with a given salary value. If the salary entered returns only one row, display employee’s name and the salary amount. If the salary entered does not return any rows or returns more than one row, handle the exception with appropriate exception handlers and messages.
DECLARE
    v_salary        employees.salary%TYPE := 36271;
    v_employee_name employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_employee_name
    FROM employees
    WHERE salary = v_salary;
    dbms_output.PUT_LINE('Employee ' || v_employee_name || ' has a salary of ' || v_salary);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.PUT_LINE('No employees with a salary of ' || v_salary);
    WHEN too_many_rows THEN
        dbms_output.PUT_LINE('More than one employee with a salary of ' || v_salary);
END;

--Use the Oracle server error ORA-02292 (integrity constraint violated – child record found) to practice how to declare exceptions with a standard Oracle Server error. Create a PL/SQL block that deletes department with employees assigned. Handle the exception.
DECLARE
    v_dep_id departments.department_id%TYPE := 60;
    e_dep_has_employees EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_dep_has_employees, -2292);
BEGIN
    DELETE
    FROM departments
    WHERE department_id = v_dep_id;
EXCEPTION
    when e_dep_has_employees THEN
        dbms_output.PUT_LINE('Cannot delete department no. ' || v_dep_id || ', because some employees are assigned to it.');
END;
