-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET B
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1
-- Stworzyć blok anonimowy, który przy użyciu kursora dla każdego pracownika z tabeli pracownicy wypisuje na ekranie tekst: 
-- 'Pracownik NAZWISKO pracuje na stanowisku STANOWISKO'
-- Gdze nazwisko oraz stanowisko pochodzą z tabeli pracownicy
declare
  cursor c_emp is select last_name, job_title from employees e join jobs j on e.job_id = j.job_id;
begin
  FOR v_emp IN c_emp LOOP
    dbms_output.put_line('Employee ' || v_emp.last_name || ' works as ' || v_emp.job_title);
  END LOOP;
end;

-- 2
-- Stworzyć procedurę, która pobiera nazwę działu jako parametr, zwiększa pensję każdego pracownika w tym dziale o 10% i wypisuje ilu pracownikom zmieniła
-- Jeżeli nie znajdzie takiego działu, to wypisuje odpowiedni komunikat poprzez obsługę błędów.
-- W sekcji deklaratywnej procedury procedury musi zostać zdefiniowany wyjątek, który musi zostać wygenerowany w ciele procedury i obsłużony w sekcji exception procedury
create or replace procedure salary_raise(p_dep_name departments.department_name%type) is
  e_no_dep_found exception;
  deps_count number(4) := 0;
  emps_count number(4) := 0;
  deps_changed number(4) := 0;
  cursor c_emps is select * from employees e join departments d on e.department_id = d.department_id where department_name = p_dep_name;
begin
  select count(*) into deps_count from departments where department_name = p_dep_name;
  if deps_count = 0 then
    raise e_no_dep_found;
  end if;

  for emp in c_emps loop
    update employees 
    set salary = salary * 1.1
    where employee_id = emp.employee_id;
    emps_count := emps_count + 1;
  end loop;

  dbms_output.put_line('Salary raised for ' || emps_count || ' employee(s)'); 

exception
  when e_no_dep_found then
    dbms_output.put_line('No department found'); 
end;

exec salary_raise('Executive');
exec salary_raise('Wrong department name');

-- 3
-- Stworzyć funkcję, któa pobiera nazwę działu jako parametr, oblicza wartość maksymalnej płacy dla podanego działu, wypisuje oraz zwraca obliczoną wartość.
-- Jeżeli nie znajdzie takiego działu, to wypisuje odpowiedni komunikat poprzez obsługę błędów.
create or replace function dep_max_sal(p_dep_name departments.department_name%type) 
return employees.salary%type is
  e_no_dep_found exception;
  dep_count number(4) := 0;
  dep_max_sal employees.salary%type := 0;
begin
  select count(*) into dep_count from departments where department_name = p_dep_name;
  if dep_count = 0 then
    raise e_no_dep_found;
  end if;

  select max(salary) into dep_max_sal from employees e join departments d on e.department_id = d.department_id where department_name = p_dep_name;
  return dep_max_sal;
exception
    when e_no_dep_found then
    dbms_output.put_line('No departments found'); 
    return 0;
end;

select dep_max_sal('Executive') from dual; 
select dep_max_sal('Wrong department name') from dual; 

-- 4 
-- Stworzyć trigger, który monitoruje wszystkie zmiany w tabeli stanowiska i zapisuje stare wartości (wartości zmienianie lub usuwane) z tej tabeli do innej tabeli o takiej samej strukturze co tabela stanowiska.
-- Tabelę danych historyzcznych można wygenerować przy użyciu polecenia 
-- CREATE TABLE STANOWISKA_ARCHIWUM AS SELECT * FROM HR.jobs;
-- DELETE FROM STANOWISKA_ARCHIWUM;
create or replace trigger job_change
before update or delete on jobs
for each row
begin
  insert into jobs_archive (job_id, job_title, min_salary, max_salary)
  values (:old.job_id,:old.job_title, :old.min_salary, :old.max_salary);
end;

select * from jobs where job_id = 'AD_PRES';
update jobs set job_title = 'changed_title' where job_id = 'AD_PRES';
select * from jobs where job_id = 'AD_PRES';
select * from jobs_archive;

select * from jobs where job_id = 'AD_PRES';
delete from jobs where job_id = 'AD_PRES'; --cannot delete becouse of constarins 
select * from jobs where job_id = 'AD_PRES';
select * from jobs_archive;
