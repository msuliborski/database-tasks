-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SET B
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 1
-- Stworzyć blok anonimowy, który przy użyciu kursora dla każdego pracownika z tabeli pracownicy wypisuje na ekranie tekst: 
-- 'Pracownik NAZWISKO pracuje na stanowisku STANOWISKO'
-- Gdze nazwisko oraz stanowisko pochodzą z tabeli pracownicy

-- 2
-- Stworzyć procedurę, która pobiera nazwę działu jako parametr, zwiększa pensję każdego pracownika w tym dziale o 10% i wypisuje ilu pracownikom zmieniła
-- Jeżeli nie znajdzie takiego działu, to wypisuje odpowiedni komunikat poprzez obsługę błędów.
-- W sekcji deklaratywnej procedury procedury musi zostać zdefiniowany wyjątek, który musi zostać wygenerowany w ciele procedury i obsłużony w sekcji exception procedury


-- 3
-- Stworzyć funkcję, któa pobiera nazwę działu jako parametr, oblicza wartość maksymalnej płacy dla podanego działu, wypisuje oraz zwraca obliczoną wartość.
-- Jeżeli nie znajdzie takiego działu, to wypisuje odpowiedni komunikat poprzez obsługę błędów.


-- 4 
-- Stworzyć trigger, który monitoruje wszystkie zmiany w tabeli stanowiska i zapisuje stare wartości (wartości zmienianie lub usuwane) z tej tabeli do innej tabeli o takiej samej strukturze co tabela stanowiska.
-- Tabelę danych historyzcznych można wygenerować przy użyciu polecenia 
-- CREATE TABLE STANOWISKA_ARCHIWUM AS SELECT * FROM HR.jobs;
-- DELETE FROM STANOWISKA_ARCHIWUM;








-- ANSWERS
--1
DECLARE
  CURSOR kursor IS
  SELECT last_name, job_title FROM HR.employees E, HR.jobs J WHERE E.job_id = J.job_id;
  nazwisko HR.employees.last_name%TYPE;
  stanowisko HR.jobs.job_title%TYPE;
BEGIN
  OPEN kursor;
  LOOP
  FETCH kursor INTO nazwisko, stanowisko;
  IF kursor%NOTFOUND
  THEN
    EXIT;
  END IF;	
    DBMS_OUTPUT.put_line('Pracownik '|| nazwisko || ' pracuje na stanowisku ' || stanowisko );
  END LOOP;
  CLOSE kursor;
END;

--2
CREATE OR REPLACE PROCEDURE procedura   
(nr_dzialu HR.employees.department_id%TYPE) IS
  wyjatek EXCEPTION;
  licznik NUMBER;
BEGIN
  SELECT COUNT(*) INTO licznik FROM HR.employees WHERE department_id = nr_dzialu;
  IF licznik = 0;
  THEN
	RAISE wyjatek;
  ELSE
    UPDATE HR.employees SET salary = 1.1 * salary WHERE department_id = nr_dzialu;
    DBMS_OUTPUT.put_line(licznik || ' pracownikow mialo zwiekszona pensje o 10%.' );
  END IF;
EXCEPTION
  WHEN wyjatek
  THEN
	DBMS_OUTPUT.put_line('Dzial '|| nr_dzialu || ' nie zostal odnaleziony.' );
END;

EXECUTE procedura('99');

SELECT salary FROM HR.employees WHERE department_id='30';
EXECUTE procedura('30');
SELECT salary FROM HR.employees WHERE department_id='30';

ROLLBACK;


--3
CREATE OR REPLACE FUNCTION funkcja   
(nazwa_dzialu HR.departments.department_name%TYPE)
RETURN NUMBER IS
  nr_dzialu HR.employees.department_id%TYPE;
  suma HR.employees.salary%TYPE := 0;
BEGIN
  SELECT department_id INTO nr_dzialu FROM HR.departments WHERE department_name = nazwa_dzialu;
  SELECT MAX(salary) INTO suma FROM HR.employees WHERE department_id = nr_dzialu;
  DBMS_OUTPUT.put_line('Najwieksze zarobki w dziale ' || nazwa_dzialu || ': ' || suma);
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
CREATE TABLE stanowiska_archiwum AS SELECT * FROM HR.jobs;
DELETE FROM stanowiska_archiwum;

CREATE OR REPLACE TRIGGER wyzwalacz
BEFORE update OR delete ON HR.jobs FOR EACH ROW
BEGIN
  INSERT INTO stanowiska_archiwum VALUES (:old.job_id, :old.job_title, :old.min_salary, :old.max_salary);
END;


SELECT job_id, job_title FROM HR.jobs WHERE job_id='IT_PROG';
UPDATE HR.jobs SET job_title = 'Tytul' WHERE job_id='IT_PROG';
SELECT job_id, job_title FROM HR.jobs WHERE job_id='IT_PROG';
SELECT job_id, job_title FROM stanowiska_archiwum WHERE job_id='IT_PROG';

ROLLBACK;
