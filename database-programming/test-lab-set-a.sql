-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET A
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 



-- 1
-- Stworzyć blok anonimowy, który przy użyciu kursora dla każdego pracownika z tabeli pracownicy wypisuje na ekranie tekst:
-- 'Pracownik NAZWISKO pracuje w dziale NAZWA_DZIALU', gdzie NAZWISKO pochodzi z tabeli pracownicy, natomiast NAZWA_DZIALU pochodzi z tabeli działy
declare
  cursor c_emp is select last_name, department_name from employees e join departments d on e.department_id = d.department_id;
begin
  FOR v_emp IN c_emp LOOP
    dbms_output.put_line('Employee ' || v_emp.last_name || ' works in department ' || v_emp.department_name);
  END LOOP;
end;



-- 2
-- Stworzyć procedurę, która pobiera nazwisko pracownika jako parametr, zwiększa mu pensję o 10% i wypisuje komunikat informujący o tym, ze operacja się powiodła
-- Jeżeli nie znajdzie takiego pracownika, to wypisuje odpowiedni komunikat poprzez obsługę błędów.
-- W sekcji deklaratywnej procedury musi zostać zdefiniowany wyjątek, który musi zostać wygenerowany w ciele procedury i obsłużony w sekcji EXCEPTION procedury.
create or replace procedure salary_raise(p_last_name employees.last_name%type) is
  e_no_emp_found exception;
  emp_count number(4) := 0;
begin
  select count(*) into emp_count from employees where last_name = p_last_name;
  if emp_count = 0 then
    raise e_no_emp_found;
  end if;
  update employees 
  set salary = salary * 1.1;
exception
  when e_no_emp_found then
    dbms_output.put_line('No employees found'); 
end;

select * from employees where employee_id = 100;
exec salary_raise('King');
exec salary_raise('Wrong last name');



-- 3
-- Stworzyć funkcję, która pobiera nazwę działu jako parametr, oblicza sumę zarobków dla podanego działu, wypisuje oraz zwraca obliczoną wartość.
-- Jeżeli nie znajdzie takiego działu, to wypisuje odpowiedni komunikat poprzez obsługę błędów.
create or replace function dep_sum(p_dep_name departments.department_name%type) 
return employees.salary%type is
  e_no_dep_found exception;
  dep_count number(4) := 0;
  dep_sum employees.salary%type := 0;
begin
  select count(*) into dep_count from departments where department_name = p_dep_name;
  if dep_count = 0 then
    raise e_no_dep_found;
  end if;

  select sum(salary) into dep_sum from employees e join departments d on e.department_id = d.department_id where department_name = p_dep_name;
  return dep_sum;
exception
    when e_no_dep_found then
    dbms_output.put_line('No departments found'); 
    return 0;
end;

select * from employees where department_id = 90;
select dep_sum('Executive') from dual; 
select dep_sum('Wrong department name') from dual; 



-- 4
-- Stworzyć trigger, który monitoruje wszystkie zmiany w tabeli pracownicy i zapisuje stare wartości (wartości zmieniane lub usuwane) z tej tabeli do innej tabeli o takiej samej strukturze co tabela pracownicy
-- Tabelę danych historycznych można wygenerować za pomocą polecenia:
-- CREATE TABLE PRACOWNICY_ARCHIWUM AS SELECT * FROM HR.employees;
-- DELETE FROM PRACOWNICY_ARCHIWUM;
create or replace trigger emp_change
before update or delete on employees
for each row
begin
  insert into employees_archive (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
  values (:old.employee_id, :old.first_name, :old.last_name, :old.email, :old.phone_number, :old.hire_date, :old.job_id, :old.salary, :old.commission_pct, :old.manager_id, :old.department_id);
end;

select * from employees where employee_id = 100;
update employees set first_name = 'changed_name' where employee_id = 100;
select * from employees where employee_id = 100;
select * from employees_archive;

select * from employees where employee_id = 197;
delete from employees where employee_id = 197;
select * from employees where employee_id = 197;
select * from employees_archive;
