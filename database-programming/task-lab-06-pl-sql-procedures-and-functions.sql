-- 1. Create a procedure called ADD_JOB to insert a new job into the JOBS table. Provide the ID and job title using two parameters. invoke the procedure with IT_DBA as the job ID and Database Administrator as the job title. Query the JOBS table and view the results.
create or replace procedure add_job(p_id jobs.job_id%type, 
                                    p_title jobs.job_title%type) is 
begin
    insert into jobs
    values (p_id, p_title, null, null);
end;

begin
    add_job('IT_DBA', 'Database Administrator');
end;

    select * from jobs;

-- 2. Invoke your procedure again, passing a job ID of ST_MAN and a job title of Stock Manager. What happens and why? Handle the exception.
declare
    e_job_already_exist exception;
    pragma exception_init (e_job_already_exist, -00001);
begin
    add_job('ST_MAN', 'Stock Manager');
exception
    when e_job_already_exist then 
    dbms_output.put_line('Job already exist.');
end;

-- 3. Create a procedure called UPD_JOB to update the job title. Provide the job ID and a new title using two parameters. Include the necessary exception handling if no update occurs. Invoke the procedure to change the job title of the job ID IT_DBA to Data Administrator. Query the JOBS table and view the results.
    -- Test the exception-handling section of the procedure by trying to update a job that does not exist. You can use the job ID IT_WEB and the job title Web Master.
create or replace procedure upd_job(p_job_id jobs.job_id%type,
                                    p_new_title jobs.job_title%type) is
    no_job_exists exception;
begin
    update jobs set 
    job_title=p_new_title
    where job_id = p_job_id;
    if sql%notfound then
        raise no_job_exists;
    end if;
exception
    when no_job_exists then
        dbms_output.PUT_LINE('No such job');
end;

begin
    upd_job('IT_DBA', 'Data Administrator');
end;
    
select * from jobs;

begin
    upd_job('IT_WEB', 'Web Master');
end;

-- 4. Create a procedure called DEL_JOB to delete a job. Include the necessary exception-handling code if no job is deleted. Invoke the procedure using the job ID IT_DBA. Query the JOBS table and view the results.
    -- Test the exception-handling section of the procedure by trying to delete a job that does not exist. Use IT_WEB as the job ID.
create or replace procedure del_job(p_job_id jobs.job_id%type) is
    no_job_exists exception;
begin
    delete from jobs 
    where job_id = p_job_id;
    if sql%notfound then
        raise no_job_exists;
    end if;
exception
    when no_job_exists then
        dbms_output.PUT_LINE('No such job');
end;

begin
    del_job('IT_DBA');
end;

select * from jobs;

begin
    del_job('IT_WEB');
end;
    
-- 5. Create a procedure that returns a value from the SALARY and JOB_ID columns for a specified employee ID. Execute the procedure using an anonymous block with variables for the two OUT parameters—one for the salary and the other for the job ID. Display the salary and job ID for employee ID 120.
    -- Invoke the procedure again, passing an EMPLOYEE_ID of 300 - handle the exception.
create or replace procedure get_info(p_emp_id employees.employee_id%type,
                                     p_sal out employees.salary%type,
                                     p_job_id out employees.job_id%type) is 
begin
    select salary, job_id into p_sal, p_job_id from employees
    where employee_id = p_emp_id;
exception
  when no_data_found then
    dbms_output.PUT_LINE('No employee found');
end;

declare
    v_emp_id employees.employee_id%type := 300;
    v_emp_sal employees.salary%type;
    v_emp_job_id employees.job_id%type;
begin
    get_info(v_emp_id, v_emp_sal, v_emp_job_id);
    if v_emp_sal is not null and v_emp_job_id is not null then
        dbms_output.put_line('Employee(' || v_emp_id || ', ' || v_emp_sal || ', ' || v_emp_job_id);
    end if;
end;

-- 6. Create a function called GET_ANNUAL_COMP to return the annual salary computed from an employee’s monthly salary and commission passed as parameters. Use the function in a SELECT statement against the EMPLOYEES table for employees in department 30.
create or replace function get_annual_comp(p_sal employees.salary%type,
                                           p_comm employees.commission_pct%type)
return number is
begin
    if p_comm is not null then
        return p_sal * 12 * (p_comm + 1);
    else 
        return p_sal * 12;
    end if;
end;

declare
    cursor c_emps is
        select last_name, salary, commission_pct from employees
        where department_id = 30;
    v_emps c_emps%rowtype;  
begin
    open c_emps;
    loop
        fetch c_emps into v_emps;
        exit when c_emps%notfound;
        dbms_output.put_line(get_annual_comp(v_emps.salary, v_emps.commission_pct));
    end loop;
    close c_emps;
end;

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

create or replace function valid_deptid(p_depit departments.department_id%type)
return boolean is
    v_depts number;
begin
    select count(*) into v_depts from departments
    where department_id = p_deptid;
    if v_depts = 0 then 
        return false;
    else 
        return true;
    end if;
end;

create or replace procedure add_employee(p_first_name employees.first_name%type,
                                         p_last_name employees.last_name%type,
                                         p_email employees.email%type,
                                         p_job employees.job_id%type default 'SA_REP',
                                         p_mgr employees.manager_id%type default 145,
                                         p_sal employees.salary%type default 1000,
                                         p_comm employees.commission_pct%type default 0,
                                         p_deptid employees.department_id%type default 30) is
no_dept exception;
begin
    if valid_deptid(p_deptid) then 
        insert into employees 
        values(employees_seq.nextval, p_first_name, p_last_name, p_email, null, TRUNC(SYSDATE), p_job, p_sal, p_comm, p_mgr, p_deptid);
    else 
        raise no_dept;
    end if;
exception
    when no_dept then
        dbms_output.put_line('No such department!');
end;

begin
    add_employee('a', 'b', 'c');
end;

-- 8. Call ADD_EMPLOYEE for the name 'Jane Harris' in department 15 and e-mail 'JAHARRIS', leaving other parameters with their default values. Handle an appropriate exception / exceptions.
begin
    add_employee('Jane', 'Harris', 'JAHARRIS', p_deptid => 15);
end;