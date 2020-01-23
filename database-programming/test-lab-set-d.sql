-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET D
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1
-- Utworz blok anonimowy, w ktorym przy uzyciu kursora:
-- > wypisane zostana stanowiska (job_id) wszystkich pracownikow (tabela employees) zarabiajacych powyzej okreslonej stawki (podanej w bloku jako parametr kursora), wypisujacy na koniec komunikat
-- `Przynajmniej tyle zarabia sie na ...(liczba)... stanowiskach` lub
-- `Na zadnym stanowisku nie zarabia sie tak duzo.`


-- 2
-- Utworz procedure która;
-- > dzialom bez podanego managera przypisze numer tego managera, ktory ma najmniejsza liczbe przypisanych pracownikow.
-- > Nastepnie wypisze komunikat postaci: Managerowi o numerze ... (numer managera) przydzielono ... (liczba nowych dzialow) nowych dzialow.
-- > Jesli nie dokonano zadnych zmian, wypisze komunikat: wszystkie dzialy maja managera.
-- > Napisz blok z wywolaniem procedury. Po wykonaniu bloku testujacego procedure, wycofaj zmiany.


-- 3
-- Utwórz funkcje podajaca dla kazdego dzialu, ile procent wszystkich zatrudnionych stanowia pracownicy tego dzialu. Wywolaj ja wewnatrz zapytania dajacego wynik w posaci dwoch kolumn: id_dzialu, rozklad_prac.


-- 4
-- Utwórz wyzwalacz ktory po zmodyfikowaniu placy minimalnej (MIN_SALARY) w tabeli JOBS, zmieni place (SALARY) kazdemu pracownikowi o taka wartosc, o jaka zmienila sie placa minimalna dla jego stanowiska.





-- ANSWERS
--by Michal
declare
CURSOR c_emp(sal employees.salary%type) IS SELECT job_id FROM employees where salary >= sal;
v_job_id employees.job_id%type;
begin 
    open c_emp(4000);
    loop
      FETCH c_emp INTO v_job_id;
      EXIT WHEN c_emp%NOTFOUND;
      dbms_output.put_line(job_id)
    end loop;
    dbms_ouput.put_line(c_emp%ROWCOUNT);
    close c_emp;
end;




--1
DECLARE
CURSOR kursor (pensja HR.employees.salary%TYPE) IS
SELECT DISTINCT job_id FROM HR.employees WHERE salary > pensja;
stanowisko HR.employees.job_id%TYPE;
stawka HR.employees.job_id%TYPE := 15000;
BEGIN
	OPEN kursor(stawka);
	LOOP
		FETCH kursor INTO stanowisko;
		IF kursor%NOTFOUND
		THEN
			IF kursor%ROWCOUNT = 0
			THEN
				DBMS_OUTPUT.put_line('Na zadnym stanowisku nie zarabia sie tak duzo.');
			ELSE 
				DBMS_OUTPUT.put_line('Przynajmniej tyle zarabia sie na '|| kursor%ROWCOUNT || ' stanowiskach.' );
			END IF;
			EXIT;
		END IF;
		DBMS_OUTPUT.put_line(stanowisko);
	END LOOP;
	CLOSE kursor;
END;

--2
CREATE OR REPLACE PROCEDURE procedura IS
  man_id HR.employees.manager_id%TYPE;
BEGIN
  SELECT manager_id INTO man_id FROM (SELECT DISTINCT manager_id, count(manager_id) AS MAN_EMP FROM HR.employees WHERE manager_id IS NOT NULL GROUP BY manager_id ORDER BY count(manager_id) ASC) WHERE rownum = 1;

  UPDATE HR.departments SET manager_id = man_id WHERE manager_id IS NULL;

  IF sql%ROWCOUNT = 0
  THEN
    DBMS_OUTPUT.put_line('Wszystkie dzialy maja managera.');
  ELSE 
    DBMS_OUTPUT.put_line('Managerowi o numerze ' || man_id || ' przydzielono ' || sql%ROWCOUNT || ' nowych dzialow.');
  END IF;
END;

BEGIN
  procedura;
  procedura;
END;

ROLLBACK;
--3
CREATE OR REPLACE FUNCTION funkcja
(nr_dzialu HR.employees.department_id%TYPE)
RETURN NUMBER IS
  dzial NUMBER;
  firma NUMBER;
BEGIN
  SELECT COUNT(*) INTO dzial FROM HR.employees WHERE department_id = nr_dzialu;
  SELECT COUNT(*) INTO firma FROM HR.employees;
  RETURN (dzial / firma) * 100;
END;

SELECT department_id, funkcja(department_id) FROM HR.departments;

ROLLBACK;


--4
CREATE OR REPLACE TRIGGER wyzwalacz
BEFORE update OF min_salary ON HR.jobs FOR EACH ROW
BEGIN
  UPDATE HR.employees SET salary = salary - :old.min_salary + :new.min_salary WHERE job_id = :old.job_id;
END;

SELECT * FROM HR.jobs WHERE job_id='IT_PROG';
SELECT employee_id, first_name, salary FROM HR.employees WHERE job_id='IT_PROG';
UPDATE HR.jobs SET min_salary = 4500 WHERE job_id='IT_PROG';
SELECT employee_id, first_name, salary FROM HR.employees WHERE job_id='IT_PROG';

