-- 1. Write a DML statement trigger  that enforces a business rule, which states that each time one or more employees are added to the EMPLOYEES table, an audit record must also be created.
    -- - Create the AUDIT_TABLE by executing the following SQL statement:
        create table audit_table
        (action varchar2(50),
        user_name varchar2(30) default user,
        last_change_date timestamp default systimestamp);
    -- - Create a statement-level trigger that inserts a row into the AUDIT_TABLE immediately after one or more rows are added to the EMPLOYEES table. The AUDIT_TABLE row should contain value “Inserting” in the action column. The other two columns should have their default values. Save your trigger code for later.
        create or replace trigger t_audit 
            after insert on employees 
            begin
                insert into audit_table (action)
                values ('Inserting');
            end;
    -- - Test your trigger by inserting a row into EMPLOYEES, then querying the AUDIT_TABLE to see that it contains a row. Make sure the trigger does not fire with a DELETE by deleting the employee you just entered. Recheck the AUDIT_TABLE to make sure that there is not another new row.
        insert into employees 
        values(employees_seq.nextval, 'Aaa', 'Bbb', 'Ccc', null, TRUNC(SYSDATE), 'SA_REP', 1000, 0, 145, 30);

        select * from employees 
        order by employee_id desc;

        select * from audit_table;

        delete from employees
        where employee_id = (select max(employee_id) from employees);

        select * from employees 
        order by employee_id desc;

-- 2. The rows in the JOBS table store a minimum and maximum salary allowed for different JOB_ID values. You are asked to write code to ensure that employees’ salaries fall in the range allowed for their job type, for insert and update operations.
    -- - Create a procedure called CHECK_SALARY as follows:
        -- * The procedure accepts two parameters, one for an employee’s job ID string and the other for the salary.
        -- * The procedure uses the job ID to determine the minimum and maximum salary for the specified job.
        -- * If the salary parameter does not fall within the salary range of the job, inclusive of the minimum and maximum, then it should raise an application exception, with the message “Invalid salary <sal>. Salaries for job <jobid> must be between <min> and <max>”. Replace the various items in the message with values supplied by parameters and variables populated by queries.
        create or replace procedure check_salary(   p_emp_job_id employees.job_id%type,
                                                    p_emp_sal employees.salary%type) is
            v_min_sal jobs.min_salary%type;
            v_max_sal jobs.max_salary%type;
            e_wrong_salary exception;
        begin
            select min_salary, max_salary into v_min_sal, v_max_sal from jobs
            where job_id = p_emp_job_id;
            if p_emp_sal > v_max_sal or p_emp_sal < v_min_sal then
                raise e_wrong_salary;
            end if;
        exception
            when e_wrong_salary then
                dbms_output.put_line('Invalid salary ' || p_emp_sal || '. Salaries for job ' || p_emp_job_id || ' must be between ' || v_min_sal || ' and ' || v_max_sal);
        end;
    -- - Create a trigger called CHECK_SALARY_TRG on the EMPLOYEES table that fires before an INSERT or UPDATE operation on each row:
        -- * The trigger must call the CHECK_SALARY procedure to carry out the business logic.
        -- * The trigger should pass the new job ID and salary to the procedure parameters.
        create or replace trigger check_salary_trg
        before insert or update on employees
        for each row
        begin
            check_salary(:new.job_id, :new.salary);
        end;
    -- Test the CHECK_SAL_TRG trigger using different cases
        insert into employees 
        values(employees_seq.nextval, 'Aaa', 'Bbb', 'Ccc', null, TRUNC(SYSDATE), 'SA_REP', 1000, 0, 145, 30);
        
        delete from employees
        where employee_id = (select max(employee_id) from employees);
        
        insert into employees 
        values(employees_seq.nextval, 'Aaa', 'Bbb', 'Ccc', null, TRUNC(SYSDATE), 'SA_REP', 7000, 0, 145, 30);
        
        delete from employees
        where employee_id = (select max(employee_id) from employees);
        
        insert into employees 
        values(employees_seq.nextval, 'Aaa', 'Bbb', 'Ccc', null, TRUNC(SYSDATE), 'SA_REP', 100000, 0, 145, 30);

        select * from employees 
        order by employee_id desc;

        delete from employees
        where employee_id = (select max(employee_id) from employees);

-- 3. Update the CHECK_SALARY_TRG trigger to fire only when the job ID or salary values have actually changed.
-- Test the trigger.
        create or replace trigger check_salary_trg
        before insert or update on employees
        for each row
        begin
            if :new.job_id <> :old.job_id or :new.salary <> :old.salary then
                check_salary(:new.job_id, :new.salary);
            end if;
        end;

        insert into employees 
        values(employees_seq.nextval, 'Aaa', 'Bbb', 'Ccc', null, TRUNC(SYSDATE), 'SA_REP', 7000, 0, 145, 30);

        update employees set 
            job_id = 'SA_REP',
            salary = 70000
        where first_name = 'Aaa';

        select * from employees
        order by employee_id desc;

-- 4. You are asked to prevent employees from being deleted during business hours. Write a statement trigger called DELETE_EMP_TRG on the EMPLOYEES table to prevent rows from being deleted during weekday business hours, which are from 9:00 AM to 6:00 PM.
-- Test the trigger with different cases.

-- 5. Create a trigger called CHECK_SAL_RANGE that is fired before every row that is updated in the MIN_SALARY and MAX_SALARY columns in the JOBS table. For any minimum or maximum salary value that is changed, check whether the salary of any existing employee with that job ID in the EMPLOYEES table falls within the new range of salaries specified for this job ID. Include exception handling to cover a salary range change that affects the record of any existing employee.
-- Test the trigger using different cases.

 