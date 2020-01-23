-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET C
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1
-- Utwórz blok anonimowy, w którym za pomocą kursora z parametrem w postaci numeru działu wypisane zostaną nazwiska wszystkich pracowników z podanego działu, a na koniec zostanie wypisany komunikat "Dział .. zatrudnia .. pracowników" lub "Podany dział nie zatrudnia pracowników"
declare
  cursor c_emps_in_dep(p_dep_id departments.department_id%type) is
    select last_name from employees where department_id = p_dep_id;
  emp_count number(4) := 0;
  p_param departments.department_id%type := 90;
begin
  for emp in c_emps_in_dep(p_param) loop
    dbms_output.put_line(emp.last_name);
    emp_count := emp_count + 1;
  end loop;
  dbms_output.put_line('Department ' || p_param || ' employes ' || emp_count || ' employees');
end;



-- 2
-- Napisz procedurę, która: w dziale o numerze podanym jako parametr, zwiększy wszystkim jego pracownikom pensję o 10%, a na koniec wypisany zostanie komunikat, że pracownikom została zmieniona pensja. Dodaj obsługę błędów dla przypadku, gdy numer działu nie zostanie odnaleziony. Napisz blok z wywołaniem tej procedury
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
  else 
    for emp in c_emps loop
      update employees 
      set salary = salary * 1.1
      where employee_id = emp.employee_id;
      emps_count := emps_count + 1;
    end loop;
    dbms_output.put_line('Salary has been changed'); 
  end if;
exception
  when e_no_dep_found then
    dbms_output.put_line('No department found'); 
end;

select * from employees where department_id = 90;
exec salary_raise('Executive');
exec salary_raise('Wrong department name');



-- 3
-- Napisz funkcję, która dla podanego działu obliczy różnicę pomiędzy maksymalnym i minimalnym wynagrodzeniem w tym dziale. Funkcję wywołaj w zapytaniu dającym wynik w postaci dwóch kolum: id_działu, różnica
create or replace function dep_sal_diff(p_dep_id departments.department_id%type) 
return employees.salary%type is
  dep_sal_diff employees.salary%type := 0;
begin
  select max(salary) - min(salary) into dep_sal_diff from employees where department_id = p_dep_id;
  return dep_sal_diff;
end;

select salary from employees e join departments d on e.department_id = d.department_id where e.department_id = 90;
select * from departments where department_id = 90; 



-- 4
-- Utwórz wyzwalacz, który przy wstawaniu nowego rekordu dla tabeli countries, jeśli użytkownik nie poda nazwy państwa (country_name), będzie wpisywał pod nazwę państwa wartość 'Nowa nazwa'
create or replace trigger country_guard 
before insert on countries 
for each row
begin
  if :new.country_name is null then
  :new.country_name := 'New name';
  end if;
end;

insert into countries (country_id, region_id) values ('AA', 1);
select * from countries where countryid = 'AA';
