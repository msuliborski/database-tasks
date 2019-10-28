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