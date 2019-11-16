-- 1. View  commands for the DBMS_OUTPUT package by using DESC statement.
-- 2. Set the SERVEROUTPUT variable that will display messages.
SET SERVEROUTPUT ON;

-- 3. Create an anonymous block that prints (displays) "Hi, it's me" (you can print strings, DATEs and NUMBERs, for  others: TO_CHAR (.....)). Use the DBMS_OUTPUT package.
BEGIN
  dbms_output.PUT_LINE('Hi, it''s me ');
END;

-- 4. Create an anonymous block that includes: declaration of a numeric variable, assigning a value and printing the value (VARIABLE = ......)
DECLARE
  v_vaw NUMBER(10) := 15;
BEGIN
  dbms_output.PUT_LINE(v_vaw);
END;

-- 5. Create an anonymous block with 2 variables that prints (displays) a greeting, today’s date and tomorrow’s date. Sample output is as follows:
    -- Hello, Agnieszka.
    -- Today is: 24-OCT-2019
    -- Tomorrow is 25-OCT-2019
DECLARE
  today DATE := SYSDATE;
  tomorrow DATE := SYSDATE + 1;
BEGIN
  dbms_output.put_line('Hello, Agnieszka');
  dbms_output.put_line('Today is: ' || today);
  dbms_output.put_line('Tomorrow is: ' || tomorrow);
END; 
-- 6. Change the line that prints “Hello …” to print “Hello” and the first name of the employee, which identifier is provided by the user. Include his/her salary in the output.
DECLARE
  today DATE := SYSDATE;
  tomorrow DATE := SYSDATE + 1;
  emp_name VARCHAR2(50);
  emp_sal NUMBER;
BEGIN
  select first_name, salary into emp_name, emp_sal from hr.employees
  where  employee_id = 101; -- $emp_id instead of 101
  dbms_output.put_line('Hello, ' || emp_name);
  dbms_output.put_line('Today is: ' || today);
  dbms_output.put_line('Tomorrow is: ' || tomorrow);
  dbms_output.put_line('Your salary is: ' || emp_sal);
END; 

-- 7. Create a new depts table as a copy of departments table.
create table depts as (select * from hr.departments)

-- 8. Create a PL/SQL block that selects the maximum department ID in the depts table and stores it in the v_max_deptno variable. Display the maximum department ID.
DECLARE
  v_max_deptno depts.department_id%TYPE;
BEGIN
  select max(department_id) into v_max_deptno from depts;
  dbms_output.put_line('Maximum department ID: ' || v_max_deptno);
END; 

-- 9. Create a PL/SQL block that inserts a new department into the depts table. Assign 'Education' to department_name. Add 10 to the maximum existing department ID to get a new department_id. The location can be NULL.
DECLARE
  v_max_deptno depts.department_id%TYPE;
BEGIN
  select max(department_id) into v_max_deptno from depts;
  insert into depts
  values (v_max_deptno + 10, 'Education', null, null);
END; 

-- 10. Create a PL/SQL block that updates the location_id to 3000 for the new department. Use the local variable v_dept_id to update the row.
DECLARE
  v_max_deptno depts.department_id%TYPE;
  v_dept_id depts.department_id%TYPE;
BEGIN
  select max(department_id) into v_max_deptno from depts;
  update depts set location_id=3000 
  where department_id=v_max_deptno;
END; 

-- 11. Write  a DELETE statement to delete the department that you added.
DECLARE
  v_max_deptno depts.department_id%TYPE;
BEGIN
  select max(department_id) into v_max_deptno from depts;
  delete from depts 
  where department_id=v_max_deptno;
END; 

-- 12. Create an anonymous block with a variable and the most complex form of the conditional expression. Using basic  LOOP, FOR and WHILE loop, create an anonymous block to print in the loop:
    -- variable equals  1
    -- variable equals  2
    -- variable equals  3
    -- variable equals  4
DECLARE
  var1 NUMBER;
BEGIN
  dbms_output.put_line('LOOP');
  var1 := 1;
  loop
    dbms_output.put_line('variable equals ' || var1);
    var1 := var1 + 1;
    exit when var1 = 5;
  end loop;

  dbms_output.put_line('WHILE');
  var1 := 1;
  while var1 < 5 loop
    dbms_output.put_line('variable equals ' || var1);
    var1 := var1 + 1;
  end loop;

  dbms_output.put_line('FOR');
  var1 := 1;
  for var1 in 1..4 loop
    dbms_output.put_line('variable equals ' || var1);
  end loop;
END; 

-- 13. Declare an anonymous block looping from the value 3 to 7 and printing the value of the counter with comments: "start" for 3, "middle" for 5 and "end" for 7.
DECLARE
  var1 NUMBER;
BEGIN
  var1 := 1;
  for var1 in 3..7 loop
    if var1 = 3 then
      dbms_output.put_line('start');
    elsif var1 = 5 then
      dbms_output.put_line('middle');
    elsif var1 = 7 then
      dbms_output.put_line('end');
    end if;
  end loop;
END; 

-- 14. Create a new emps table as a copy of employees table. Add a new column, stars, of VARCHAR2 data type and size 50.
create table emps as (select * from hr.employees);
alter table emps add stars VARCHAR2(50);

-- 15. Create a PL/SQL block that inserts an asterisk in the stars column for every $1000 of the employee’s salary.
DECLARE
  emp_sal emps.salary%TYPE;
  v_stars VARCHAR2(50);
BEGIN
  for records in (select * from emps) loop
    emp_sal := records.salary;
    v_stars := '';
    
    loop 
      exit when emp_sal < 1000;
      v_stars := v_stars || '*';
      emp_sal := emp_sal - 1000;
    end loop;

    update emps 
    set emps.stars = v_stars
    where emps.employee_id = records.employee_id;
  end loop;
END; 

-- 16 Display the row from the emps table to verify whether your PL/SQL block has executed successfully.
select stars from emps;































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

