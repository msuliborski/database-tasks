-- 1. View  commands for the DBMS_OUTPUT package by using DESC statement.
-- 2. Set the SERVEROUTPUT variable that will display messages.
-- 3. Create an anonymous block that prints (displays) "Hi, it's me" (you can print strings, DATEs and NUMBERs, for  others: TO_CHAR (.....)). Use the DBMS_OUTPUT package.
-- 4. Create an anonymous block that includes: declaration of a numeric variable, assigning a value and printing the value (VARIABLE = ......)
-- 5. Create an anonymous block with 2 variables that prints (displays) a greeting, today’s date and tomorrow’s date. Sample output is as follows:
    -- Hello, Agnieszka.
    -- Today is: 24-OCT-2019
    -- Tomorrow is 25-OCT-2019
-- 6. Change the line that prints “Hello …” to print “Hello” and the first name of the employee, which identifier is provided by the user. Include his/her salary in the output.
-- 7. Create a new depts table as a copy of departments table.
-- 8. Create a PL/SQL block that selects the maximum department ID in the depts table and stores it in the v_max_deptno variable. Display the maximum department ID.
-- 9. Create a PL/SQL block that inserts a new department into the depts table. Assign 'Education' to department_name. Add 10 to the maximum existing department ID to get a new department_id. The location can be NULL.
-- 10. Create a PL/SQL block that updates the location_id to 3000 for the new department. Use the local variable v_dept_id to update the row.
-- 11. Write  a DELETE statement to delete the department that you added.
-- 12. Create an anonymous block with a variable and the most complex form of the conditional expression. Using basic  LOOP, FOR and WHILE loop, create an anonymous block to print in the loop:
    -- variable equals  1
    -- variable equals  2
    -- variable equals  3
    -- variable equals  4

-- 13. Declare an anonymous block looping from the value 3 to 7 and printing the value of the counter with comments: "start" for 3, "middle" for 5 and "end" for 7.
-- 14. Create a new emps table as a copy of employees table. Add a new column, stars, of VARCHAR2 data type and size 50.
-- 15. Create a PL/SQL block that inserts an asterisk in the stars column for every $1000 of the employee’s salary.
-- 16 Display the row from the emp table to verify whether your PL/SQL block has executed successfully.


2, 3, 4, 5)

SET SERVEROUTPUT ON;
DECLARE 
    first_name VARCHAR2 (30) := 'Agnieszka';
    today DATE := SYSDATE;
    tomorrow DATE := SYSDATE + 1;
    numba NUMBER(10) := 1000;
BEGIN 
    dbms_output.put_line('Witaj ' || first_name || '!' );
    dbms_output.put_line('Dzisiaj jest ' || today);
    dbms_output.put_line('Jutro bedzie ' || tomorrow );
    dbms_output.put_line('numba is ' || numba );
END;

6)

SET SERVEROUTPUT ON;
DECLARE 
    today DATE := SYSDATE;
    tomorrow DATE := SYSDATE + 1;
    emp_name VARCHAR2(30);
    emp_sal NUMBER(10);
BEGIN 

    SELECT FIRST_NAME, SALARY into emp_name, emp_sal FROM 
    Employees  where employee_id = &eid;

    dbms_output.put_line('Hello ' || emp_name || '!' );
    dbms_output.put_line('Dzisiaj jest ' || today);
    dbms_output.put_line('Jutro bedzie ' || tomorrow );
    dbms_output.put_line('Your salary is ' || emp_sal);
END;

7)

CREATE TABLE depts AS (SELECT * FROM DEPARTMENTS);

8)

SET SERVEROUTPUT ON;
DECLARE
v_max_deptno NUMBER(10);
BEGIN 
SELECT MAX(department_id) INTO v_max_deptno FROM depts;
dbms_output.put_line(v_max_deptno);
END;

9)

DECLARE
v_max_deptno NUMBER(10);
BEGIN 
SELECT MAX(department_id) INTO v_max_deptno FROM depts;
INSERT INTO depts(department_id, department_name, manager_id, location_id)
VALUES(v_max_deptno + 10, 'Education', 100, null);
END;

10)

DECLARE
v_max_deptno NUMBER(10);
BEGIN 
SELECT MAX(department_id) INTO v_max_deptno FROM depts;
UPDATE depts SET location_id = 3000
WHERE department_id = v_max_deptno;
END;

11)

DECLARE
v_max_deptno NUMBER(10);
BEGIN 
SELECT MAX(department_id) INTO v_max_deptno FROM depts;
DELETE FROM depts WHERE department_id = v_max_deptno;
END;

12)

SET SERVEROUTPUT ON;
DECLARE
counter NUMBER(10) := 0;
BEGIN 
WHILE counter < 5 LOOP
dbms_output.put_line('Counter equals ' || counter);
counter := counter + 1;
END LOOP;
FOR counter IN 4..10 LOOP
dbms_output.put_line('Counter equals ' || counter);
END LOOP;
END;

6)

SET SERVEROUTPUT ON;
BEGIN 
FOR counter IN 3..7 LOOP
IF counter = 3 THEN
    dbms_output.put_line('start');
ELSIF counter = 5 THEN
    dbms_output.put_line('middle');
ELSIF counter = 7 THEN
    dbms_output.put_line('end');   
END IF;    
END LOOP;
END;

7)














SET SERVEROUTPUT ON;
--3--
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hi, it''s me ');
END;

--4--
DECLARE
v_number NUMBER := 10;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_number);
END;

--5--
DECLARE
v_greetings VARCHAR(50) := 'Hello Emilia';
v_today DATE := SYSDATE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_greetings);
  DBMS_OUTPUT.PUT_LINE('Today is ' || to_char(v_today));
  DBMS_OUTPUT.PUT_LINE('Tomorrow is ' || to_char(v_today+1));
END;

--6--
DECLARE 
v_id NUMBER := &id;
v_name hr.employees.first_name%TYPE;
v_salary hr.employees.salary%TYPE;
BEGIN
  SELECT first_name, salary 
  INTO v_name, v_salary
  FROM hr.employees
  WHERE employee_id = v_id;
  DBMS_OUTPUT.put_line('Hello ' || v_name || '. Your salary is: ' || v_salary);
END;

--7--
--CREATE TABLE new_depts
--AS (SELECT * FROM HR.DEPARTMENTS);

--8--
DECLARE
v_max_deptno new_depts.department_id%TYPE;
BEGIN
  SELECT MAX(department_id)
  INTO v_max_deptno
  FROM new_depts;
  DBMS_OUTPUT.PUT_LINE(v_max_deptno);
END;

--9--

DECLARE
v_max_deptno new_depts.department_id%TYPE;
BEGIN
  SELECT MAX(department_id)
  INTO v_max_deptno
  FROM new_depts;
  
  INSERT INTO new_depts
  (department_id, department_name)
  VALUES
  (TO_NUMBER(v_max_deptno)+10, 'Education');
END;

--10--
DECLARE 
v_dept_id new_depts.department_id%TYPE := 3000;
BEGIN
  UPDATE new_depts
  SET department_id = v_dept_id
  WHERE department_id = 280;
END;

--11--
DELETE FROM new_depts
WHERE department_id = 3000;

--12.1--
DECLARE
v_variable NUMBER := 1;
BEGIN
  LOOP
  IF v_variable = 5 THEN
  EXIT;
  END IF;
    DBMS_OUTPUT.PUT_LINE('variable is : ' || v_variable);
    v_variable := v_variable + 1;
  END LOOP;
END;

--12.2--
DECLARE
v_variable NUMBER := 0;
BEGIN
  FOR i IN 1..4 LOOP v_variable := v_variable + 1;
  dbms_output.put_line('variable is: '  || v_variable);
  end loop;
END;

--12.3--
DECLARE
v_variable NUMBER := 1;
BEGIN
WHILE v_variable <= 4 
LOOP
    DBMS_OUTPUT.put_line('variable is: '  || v_variable);
    v_variable := v_variable + 1;
END LOOP;
END;

--6--
DECLARE 
v_variable NUMBER := 3;
BEGIN
LOOP
    IF v_variable = 3 THEN 
        dbms_output.put_line('start counter : ' || v_variable);
    ELSIF  v_variable = 5  THEN 
        dbms_output.put_line('medium counter: ' || v_variable);
    ELSIF v_variable = 7 THEN 
        dbms_output.put_line('end counter: ' || v_variable);
        EXIT;
    ELSE
        dbms_output.put_line (v_variable); 
    END IF;
    v_variable := v_variable + 1;
END LOOP;
END;

--7--
CREATE TABLE new_emps
AS (SELECT * FROM employees);

ALTER TABLE new_emps
ADD stars
VARCHAR2(50);

--8--
DECLARE 
v_starcounter NUMBER;
s_stars VARCHAR2(50) := '';
v_star VARCHAR2(50) := '*';
BEGIN
    FOR R_RECORD IN (SELECT * FROM new_emps)
    LOOP
        v_starcounter := (r_record.salary - MOD(r_record.salary, 1000)) / 1000;
        dbms_output.put_line (v_starcounter ||' ' || r_record.salary);
        for k in 1.. v_starcounter LOOP
            s_stars := s_stars || v_star;
        END LOOP;
        dbms_output.put_line(s_stars);
        UPDATE new_emps
        SET stars = s_stars
        WHERE EMPLOYEE_ID = R_RECORD.EMPLOYEE_ID;
        s_stars := '';
    END LOOP;
END;
SELECT * FROM new_emps;

