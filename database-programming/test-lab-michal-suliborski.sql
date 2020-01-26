--
-- Lab test
-- Michał Suliborski (217863)
-- Set 2
--



-- 1
declare
  cursor c_emp is select first_name, last_name, job_title from employees e join jobs j on e.job_id = j.job_id;
begin
  for v_emp in c_emp loop
    dbms_output.put_line(v_emp.first_name || ' ' || v_emp.last_name || ' works as ' || v_emp.job_title);
  end loop;
end;



-- 2
create or replace procedure PROC_1(p_dep_id departments.department_id%type) is
  e_no_dep_found exception;
  v_deps_count number := 0;
  cursor c_emps is select * from employees where department_id = p_dep_id;
begin
  select count(*) into v_deps_count from departments where department_id = p_dep_id;
  if v_deps_count = 0 then
    raise e_no_dep_found;
  else 
    for emp in c_emps loop
      update employees 
      set salary = salary * 1.1
      where employee_id = emp.employee_id;
    end loop;
    dbms_output.put_line('Salary of all employees in department ' || p_dep_id || ' has just risen'); 
  end if;
exception
  when e_no_dep_found then
    dbms_output.put_line('No such department found'); 
end;

--verify on department 90
select * from employees where department_id = 90;
exec PROC_1(90);
exec PROC_1(9999);



-- 3
create or replace function FUN_1(p_inc_rate number, p_dep_id departments.department_id%type) 
return number is
  e_no_dep_found exception;
  v_deps_count number := 0;
  v_sal_sum number := 0;
  cursor c_emps is select * from employees where department_id = p_dep_id;
begin
  select count(*) into v_deps_count from departments where department_id = p_dep_id;
  if v_deps_count = 0 then
    raise e_no_dep_found;
  else 
    for emp in c_emps loop
      v_sal_sum := v_sal_sum + emp.salary;
    end loop;
    return (v_sal_sum * (1 + p_inc_rate)) - v_sal_sum;
  end if;
exception
  when e_no_dep_found then
    dbms_output.put_line('No such department found'); 
    return 0;
end;

--verify on department 90
select * from employees where department_id = 90;
select FUN_1(0.1, 90) from dual; --10% increase
select FUN_1(0.1, 9999) from dual;



-- 4
--prepare archive table
create table employees_archive as select * from employees;
delete from employees_archive;

create or replace trigger TRIG_1
before update or delete on employees
for each row
begin
  insert into employees_archive (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
  values (:old.employee_id, :old.first_name, :old.last_name, :old.email, :old.phone_number, :old.hire_date, :old.job_id, :old.salary, :old.commission_pct, :old.manager_id, :old.department_id);
end;

-- verify on update
select * from employees where employee_id = 100;
update employees set last_name = 'Not so King after all' where employee_id = 100;
select * from employees where employee_id = 100;
select * from employees_archive;

-- verify on delete
select * from employees where employee_id = 199;
delete from employees where employee_id = 199;
select * from employees where employee_id = 199;
select * from employees_archive;

