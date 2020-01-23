-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET D
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1
-- Utworz blok anonimowy, w ktorym przy uzyciu kursora:
-- > wypisane zostana stanowiska (job_id) wszystkich pracownikow (tabela employees) zarabiajacych powyzej okreslonej stawki (podanej w bloku jako parametr kursora), wypisujacy na koniec komunikat
-- `Przynajmniej tyle zarabia sie na ...(liczba)... stanowiskach` lub
-- `Na zadnym stanowisku nie zarabia sie tak duzo.`
declare
  cursor c_emps_with_sal(p_sal employees.salary%type) is
    select distinct job_id from employees where salary > p_sal;
  emp_count number(4) := 0;
  p_param employees.salary%type := 10000;
begin
  for emp in c_emps_with_sal(p_param) loop
    dbms_output.put_line('At ' || emp.job_id || ' one earns at least ' || p_param);
    emp_count := emp_count + 1;
  end loop;
  if emp_count = 0 then
    dbms_output.put_line('There is no job with that high salary');
  end if;
end;



-- 2
-- Utworz procedure która;
-- > dzialom bez podanego managera przypisze numer tego managera, ktory ma najmniejsza liczbe przypisanych pracownikow.
-- > Nastepnie wypisze komunikat postaci: Managerowi o numerze ... (numer managera) przydzielono ... (liczba nowych dzialow) nowych dzialow.
-- > Jesli nie dokonano zadnych zmian, wypisze komunikat: wszystkie dzialy maja managera.
-- > Napisz blok z wywolaniem procedury. Po wykonaniu bloku testujacego procedure, wycofaj zmiany.
create or replace procedure assign_mgrs is
  mgr_id employees.manager_id%type;
begin
  select manager_id into mgr_id from (select distinct manager_id, count(manager_id) as man_emp from hr.employees where manager_id is not null group by manager_id order by count(manager_id) asc) where rownum = 1;

  update departments set manager_id = mgr_id where manager_id is null;

  if sql%rowcount = 0 then
    dbms_output.put_line('All departments have a manager');
  else 
    dbms_output.put_line('Manager with ID ' || mgr_id || ' got ' || sql%rowcount || ' nowych dzialow.');
  end if;
end;

exec assign_mgrs();



-- 3
-- Utwórz funkcje podajaca dla kazdego dzialu, ile procent wszystkich zatrudnionych stanowia pracownicy tego dzialu. Wywolaj ja wewnatrz zapytania dajacego wynik w posaci dwoch kolumn: id_dzialu, rozklad_prac.
create or replace function show_employed(p_dep_id hr.employees.department_id%type)
return number is
  dep_emps number;
  all_amps number;
begin
  select count(*) into dep_emps from employees where department_id = p_dep_id;
  select count(*) into all_amps from employees;
  return round((dep_emps / all_amps) * 100, 2);
end;

select department_id, show_employed(department_id) from hr.departments;



-- 4
-- Utwórz wyzwalacz ktory po zmodyfikowaniu placy minimalnej (MIN_SALARY) w tabeli JOBS, zmieni place (SALARY) kazdemu pracownikowi o taka wartosc, o jaka zmienila sie placa minimalna dla jego stanowiska.
create or replace trigger min_sal_fix 
before update of min_salary on jobs 
for each row
begin
  update employees set salary = salary - :old.min_salary + :new.min_salary where job_id = :old.job_id;
end;

select * from jobs where job_id = 'IT_PROG';
select employee_id, first_name, salary from employees where job_id = 'IT_PROG';
update jobs set min_salary = 10000 where job_id = 'IT_PROG';
select employee_id, first_name, salary from employees where job_id = 'IT_PROG';
