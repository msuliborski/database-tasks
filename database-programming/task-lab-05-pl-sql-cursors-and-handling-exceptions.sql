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
    v_curr_emps number;
    cursor c_emp_cursor is
        select last_name, salary from hr.employees
        order by salary desc;
    v_emp_record c_emp_cursor%rowtype;
begin
    open c_emp_cursor;
        v_curr_emps := v_max_emps;
        loop
          fetch c_emp_cursor into v_emp_record;
          exit when c_emp_cursor%notfound or v_curr_emps = 0;
          dbms_output.put_line(v_emp_record.last_name || ', ' || v_emp_record.salary);
          v_curr_emps := v_curr_emps - 1;
        end loop;
    close c_emp_cursor;
end;

-- 4. Write a PL/SQL block, which declares and uses cursors with parameters. In a loop, use a cursor to retrieve the department number and the department name from the departments table for a department whose department_id is less than 100. Pass the department number to another cursor as a parameter to retrieve from the employees table the details of employee last name, job, hire date, and salary of those employees whose employee_id is less than 120 and who work in that department.
declare
    cursor c_deps is 
        select department_id, department_name from hr.departments
        where department_id < 100;
    v_deps c_deps%rowtype;    
    cursor c_emps(dep_id hr.departments.department_id%type) is 
        select last_name, job_id, hire_date, salary from hr.employees
        where department_id = dep_id and employee_id < 120; 
    v_emps c_emps%rowtype;    
begin
    open c_deps;
        loop
            fetch c_deps into v_deps;
            exit when c_deps%notfound;
            dbms_output.put_line('Employees in dep. ' || v_deps.department_name || '(' || v_deps.department_id || ')');
            open c_emps(v_deps.department_id);
            loop
                fetch c_emps into v_emps;
                exit when c_emps%notfound;
                dbms_output.put_line(' - ' || v_emps.last_name || '(' || v_emps.job_id || ')' || ', salary: ' || v_emps.salary || ', hired: ' || v_emps.hire_date);
            end loop;
            close c_emps;
        end loop;
    close c_deps;
end;

-- 5. Write a PL/SQL block to select the name of the employee with a given salary value. If the salary entered returns only one row, display employee’s name and the salary amount. If the salary entered does not return any rows or returns more than one row, handle the exception with appropriate exception handlers and messages.
declare 
    v_sal hr.employees.salary%type := 17000; -- 17000, 24000, 24123
    v_name hr.employees.last_name%type;    
begin
    select last_name into v_name from hr.employees
    where salary = v_sal; 
    dbms_output.put_line(v_name || ', salary: ' || v_sal);
exception
    when no_data_found then
        dbms_output.put_line('No employees of salary ' || v_sal);
    when too_many_rows then
        dbms_output.put_line('Too many employees of salary ' || v_sal);
end;

-- 6. Use the Oracle server error ORA-02292 (integrity constraint violated – child record found) to practice how to declare exceptions with a standard Oracle Server error. Create a PL/SQL block that deletes department with employees assigned. Handle the exception.












-- NOT MINE
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
