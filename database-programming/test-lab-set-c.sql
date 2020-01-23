-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET C
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1
-- Utwórz blok anonimowy, w którym za pomocą kursora z parametrem w postaci numeru działu
-- > wypisane zostaną nazwiska wszystkich pracowników z podanego działu
-- > na koniec zostanie wypisany komunikat "Dział .. zatrudnia .. pracowników" lub "Podany dział nie zatrudnia pracowników"

-- 2
-- Napisz procedurę, która:
-- > w dziale o numerze podanym jako parametr, zwiększy wszystkim jego pracownikom pensję o 10%
-- > na koniec wypisany zostanie komunikat, że pracownikom została zmieniona pensja.
-- > Dodaj obsługę błędów dla przypadku, gdy numer działu nie zostanie odnaleziony.
-- > Napisz blok z wywołaniem tej procedury

-- 3
-- Napisz funkcję, która dla podanego działu obliczy różnicę pomiędzy maksymalnym i minimalnym wynagrodzeniem w tym dziale. Funkcję wywołaj w zapytaniu dającym wynik w postaci dwóch kolum: id_działu, różnica

-- 4
-- Utwórz wyzwalacz, który przy wstawaniu nowego rekordu dla tabeli countries, jeśli użytkownik nie poda nazwy państwa (country_name), będzie wpisywał pod nazwę państwa wartość 'Nowa nazwa'







-- ANSWERS
-- by Michal
-- 1
declare
CURSOR c_emp(a_dep_id employees.department_id%type)
IS SELECT last_name from employees where department_id = a_dep_id;
v_l_name employees.last_name%type;
v_dep_name employees.department_id%type := 100;
begin 
    OPEN c_emp(v_dep_name);
    loop
      FETCH c_emp INTO v_l_name;
      IF c_emp%NOTFOUND THEN
        IF c_emp%ROWCOUNT = 0 THEN
        dbms_output.put_line('Shieet');
        ELSE 
        dbms_output.put_line(c_emp%ROWCOUNT);
        END IF;
       EXIT;
      END IF;
      dbms_output.put_line(v_l_name ||' ' || v_dep_name );
    end loop;
    close c_emp;


end;


-- 2
CREATE OR REPLACE PROCEDURE a(p_dep_id employees.department_id%type)
IS
v_dep_id employees.department_id%type;
BEGIN
    SELECT department_id INTO v_dep_id FROM departments where department_id = p_dep_id;
    UPDATE employees set salary = salary * 1.1
    where department_id = v_dep_id;
    dbms_output.put_line('done');
    exception
    when no_data_found then
        dbms_output.put_line('shiiet');

END;


-- 3
CREATE OR REPLACE FUNCTION b(p_dep_id departments.department_id%type)
RETURN employees.salary%type
IS
diff employees.salary%type := 0;
begin
  SELECT MAX(SALARY) - MIN(SALARY) INTO diff from employees e JOIN departments d ON e.department_id = d.department_id;
  return diff;
end;

SELECT department_id, diff(department_id) FROM departments where department_id = 30;

-- 4
CREATE OR REPLACE TRIGGER trg_cnt
BEFORE INSERT ON countries
FOR EACH ROW
begin
  IF :new.country_name is null then
    :new.country_name := 'Nowa nazwa';
  END IF;
end;




--1
DECLARE
CURSOR kursor (nr_dzialu HR.employees.department_id%TYPE) IS
SELECT last_name FROM HR.employees WHERE department_id = nr_dzialu;
nazwisko HR.employees.last_name%TYPE;
numer_dzialu NUMBER := 30;
BEGIN
	OPEN kursor(numer_dzialu);
	LOOP
		FETCH kursor INTO nazwisko;
		IF kursor%NOTFOUND
		THEN
			IF kursor%ROWCOUNT = 0
			THEN
				DBMS_OUTPUT.put_line('Podany dzial nie zatrudnia pracownikow');
			ELSE 
				DBMS_OUTPUT.put_line('Dzial '|| numer_dzialu || ' zatrudnia ' || kursor%ROWCOUNT || ' pracownikow.' );
			END IF;
			EXIT;
		END IF;
		DBMS_OUTPUT.put_line(nazwisko);
	END LOOP;
	CLOSE kursor;
END;

--2
CREATE OR REPLACE PROCEDURE procedura   
(nr_dzialu HR.employees.department_id%TYPE) IS
  nr HR.departments.department_id%TYPE;
BEGIN
  SELECT department_id INTO nr FROM HR.departments WHERE department_id = nr_dzialu;
  UPDATE HR.employees SET salary = 1.1 * salary WHERE department_id = nr_dzialu;
  DBMS_OUTPUT.put_line('Dzial '|| nr_dzialu || ' mial zwiekszone pensje o 10%.' );
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
	DBMS_OUTPUT.put_line('Dzial '|| nr_dzialu || ' nie zostal odnaleziony.' );
END;


DECLARE
  nr_dzialu HR.employees.department_id%TYPE := 40;
BEGIN
  procedura(nr_dzialu);
END;

ROLLBACK;


--3
CREATE OR REPLACE FUNCTION funkcja   
(nr_dzialu HR.employees.department_id%TYPE)
RETURN NUMBER IS
min_pensja HR.employees.salary%TYPE;
max_pensja HR.employees.salary%TYPE;
BEGIN
  SELECT MIN(salary) INTO min_pensja FROM HR.employees WHERE department_id = nr_dzialu;
  SELECT MAX(salary) INTO max_pensja FROM HR.employees WHERE department_id = nr_dzialu;
  RETURN max_pensja - min_pensja;
END;

SELECT department_id, funkcja(department_id) FROM HR.departments;

ROLLBACK;

--4
CREATE OR REPLACE TRIGGER wyzwalacz
BEFORE insert ON HR.countries FOR EACH ROW
WHEN (new.country_name IS NULL)
BEGIN
  :new.country_name := 'Nowa nazwa';
END;

SELECT * FROM HR.countries WHERE country_name = 'Nowa nazwa';
INSERT INTO HR.countries VALUES ('NN', NULL, 3);
SELECT * FROM HR.countries WHERE country_name = 'Nowa nazwa';

ROLLBACK;

