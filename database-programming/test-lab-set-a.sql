-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET A
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1
-- Stworzyć blok anonimowy, który przy użyciu kursora dla każdego pracownika z tabeli pracownicy wypisuje na ekranie tekst:
-- 'Pracownik NAZWISKO pracuje w dziale NAZWA_DZIALU', gdzie NAZWISKO pochodzi z tabeli pracownicy, natomiast NAZWA_DZIALU pochodzi z tabeli działy



-- 2
-- Stworzyć procedurę, która pobiera nazwisko pracownika jako parametr, zwiększa mu pensję o 10% i wypisuje komunikat informujący o tym, ze operacja się powiodła
-- Jeżeli nie znajdzie takiego pracownika, to wypisuje odpowiedni komunikat poprzez obsługę błędów.
-- W sekcji deklaratywnej procedury musi zostać zdefiniowany wyjątek, który musi zostać wygenerowany w ciele procedury i obsłużony w sekcji EXCEPTION procedury.



-- 3
-- Stworzyć funkcję, która pobiera nazwę działu jako parametr, oblicza sumę zarobków dla podanego działu, wypisuje oraz zwraca obliczoną wartość.
-- Jeżeli nie znajdzie takiego działu, to wypisuje odpowiedni komunikat poprzez obsługę błędów.


-- 4
-- Stworzyć trigger, który monitoruje wszystkie zmiany w tabeli pracownicy i zapisuje stare wartości (wartości zmieniane lub usuwane) z tej tabeli do innej tabeli o takiej samej strukturze co tabela pracownicy
-- Tabelę danych historycznych można wygenerować za pomocą polecenia:
-- CREATE TABLE PRACOWNICY_ARCHIWUM AS SELECT * FROM HR.employees;
-- DELETE FROM PRACOWNICY_ARCHIWUM;













-- ANSWERS
-- by Michal
-- 1
DECLARE
CURSOR c_emp IS SELECT last_name, department_name FROM employees e JOIN departments d ON e.department_id = d.department_id;
v_last_name VARCHAR2(20);
v_dep_name VARCHAR2(20);
begin
  OPEN c_emp;
  loop
    FETCH c_emp INTO v_last_name, v_dep_name;
    EXIT WHEN c_emp%NOTFOUND;
    dbms_output.put_line(v_last_name || ' ' || v_dep_name);
  end loop;
  close c_emp;

end;

-- 2
CREATE OR REPLACE PROCEDURE EX2(p_last_name employees.last_name%type)
IS
ex exception;
c NUMBER(10);
BEGIN
    SELECT count(*) INTO c from employees WHERE last_name = p_last_name;
    IF c = 0 then
     raise ex;
    END IF;
    update employees
       set salary = 1.1 * salary
     where last_name = p_last_name;
    exception
      when ex then
        dbms_output.put_line('SHIEEET!');
END;

-- 3
CREATE OR REPLACE FUNCTION t(p_dep_name departments.department_name%type)
RETURN employees.salary%type
IS
sum_ employees.salary%type;
dep_id departments.department_id%type;
begin
  SELECT department_id INTO dep_id FROM departments WHERE department_name = p_dep_name;
  SELECT sum(salary) INTO sum_ FROM employees WHERE department_id = dep_id;
  dbms_output.put_line(sum_);
  return sum_;
  exception
    when no_data_found then
      dbms_output.put_line('SHIEEET!');
        return 0;
end;


-- 4
CREATE TABLE PRACOWNICY_ARCHIWUM AS SELECT * FROM HR.employees;

CREATE OR REPLACE TRIGGER h
BEFORE UPDATE OR DELETE ON employees
FOR EACH ROW
begin
  insert into PRACOWNICY_ARCHIWUM 
  values (:old.employee_id, :old.first_name, :old.last_name, :old.email,
  :old.phone_number, :old.hire_date, :old.job_id, :old.salary, :old.commission_pct, :old.manager_id, :old.department_id);
end;

SELECT employee_id, first_name FROM HR.employees WHERE employee_id=197;
UPDATE HR.employees SET first_name = 'Imie' WHERE employee_id=197;
SELECT employee_id, first_name FROM HR.employees WHERE employee_id=197;
SELECT employee_id, first_name FROM pracownicy_archiwum WHERE employee_id=197;





-- theirs

-- 1
DECLARE
  CURSOR kursor IS
  SELECT last_name, department_name FROM HR.employees E, HR.departments D WHERE E.department_id = D.department_id;
  nazwisko HR.employees.last_name%TYPE;
  nazwa_dzialu HR.departments.department_name%TYPE;
BEGIN
  OPEN kursor;
  LOOP
  FETCH kursor INTO nazwisko, nazwa_dzialu;
  IF kursor%NOTFOUND
  THEN
    EXIT;
  END IF;	
    DBMS_OUTPUT.put_line('Pracownik '|| nazwisko || ' pracuje w dziale ' || nazwa_dzialu );
  END LOOP;
  CLOSE kursor;
END;

--2

-- wlasny wyjatek
CREATE OR REPLACE PROCEDURE procedura   
(nazwisko HR.employees.last_name%TYPE) IS
  wyjatek EXCEPTION;
  licznik NUMBER;
BEGIN
  SELECT COUNT(*) INTO licznik FROM HR.employees WHERE last_name = nazwisko;
  IF licznik = 0
  THEN
	RAISE wyjatek;
  ELSE
    UPDATE HR.employees SET salary = 1.1 * salary WHERE last_name = nazwisko;
    DBMS_OUTPUT.put_line('Pracownik '|| nazwisko || ' mial zwiekszona pensje o 10%.' );
  END IF;
EXCEPTION
  WHEN wyjatek
  THEN
	DBMS_OUTPUT.put_line('Pracownik '|| nazwisko || ' nie zostal odnaleziony.' );
END;

-- wyjątek NO_DATA_FOUND
-- tego nie używać chyba, ale to jest logczine :c
CREATE OR REPLACE PROCEDURE procedura   
(nazwisko HR.employees.last_name%TYPE) IS
BEGIN
  UPDATE HR.employees SET salary = 1.1 * salary WHERE last_name = nazwisko;
  DBMS_OUTPUT.put_line('Pracownik '|| nazwisko || ' mial zwiekszona pensje o 10%.' )
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
	DBMS_OUTPUT.put_line('Pracownik '|| nazwisko || ' nie zostal odnaleziony.' );
END;


EXECUTE procedura('Leo');

SELECT salary FROM HR.employees WHERE last_name='Bull';
EXECUTE procedura('Bull');
SELECT salary FROM HR.employees WHERE last_name='Bull';

ROLLBACK;


-- 3
CREATE OR REPLACE FUNCTION funkcja   
(nazwa_dzialu HR.departments.department_name%TYPE)
RETURN NUMBER IS
  nr_dzialu HR.employees.department_id%TYPE;
  suma HR.employees.salary%TYPE := 0;
BEGIN
  SELECT department_id INTO nr_dzialu FROM HR.departments WHERE department_name = nazwa_dzialu;
  SELECT SUM(salary) INTO suma FROM HR.employees WHERE department_id = nr_dzialu;
  DBMS_OUTPUT.put_line('Suma zarobkow oddzialu ' || nazwa_dzialu || ' wynosi ' || suma);
  RETURN suma;
EXCEPTION
	WHEN NO_DATA_FOUND
	THEN
		DBMS_OUTPUT.put_line('Dzial '|| nazwa_dzialu || ' nie zostal odnaleziony.' );
    RETURN 0;
END;

EXECUTE DBMS_OUTPUT.put_line(funkcja('Nieznany oddzial'));
EXECUTE DBMS_OUTPUT.put_line(funkcja('IT'));

ROLLBACK;


--4
CREATE TABLE pracownicy_archiwum AS SELECT * FROM HR.employees;
DELETE FROM pracownicy_archiwum;

CREATE OR REPLACE TRIGGER wyzwalacz
BEFORE update OR delete ON HR.employees FOR EACH ROW
BEGIN
  INSERT INTO pracownicy_archiwum VALUES (:old.employee_id, :old.first_name, :old.last_name, :old.email,
  :old.phone_number, :old.hire_date, :old.job_id, :old.salary, :old.commission_pct, :old.manager_id, :old.department_id);
END;


SELECT employee_id, first_name FROM HR.employees WHERE employee_id=197;
UPDATE HR.employees SET first_name = 'Imie' WHERE employee_id=197;
SELECT employee_id, first_name FROM HR.employees WHERE employee_id=197;
SELECT employee_id, first_name FROM pracownicy_archiwum WHERE employee_id=197;

ROLLBACK;
