1. Write a DML statement trigger  that enforces a business rule, which states that each time one or more employees are added to the EMPLOYEES table, an audit record must also be created.
    - Create the AUDIT_TABLE by executing the following SQL statement:
        CREATE TABLE audit_table
        (action VARCHAR2(50),
        user_name VARCHAR2(30) DEFAULT USER,
        last_change_date TIMESTAMP DEFAULT SYSTIMESTAMP);
    - Create a statement-level trigger that inserts a row into the AUDIT_TABLE immediately after one or more rows are added to the EMPLOYEES table. The AUDIT_TABLE row should contain value “Inserting” in the action column. The other two columns should have their default values. Save your trigger code for later.
    - Test your trigger by inserting a row into EMPLOYEES, then querying the AUDIT_TABLE to see that it contains a row. Make sure the trigger does not fire with a DELETE by deleting the employee you just entered. Recheck the AUDIT_TABLE to make sure that there is not another new row.

2. The rows in the JOBS table store a minimum and maximum salary allowed for different JOB_ID values. You are asked to write code to ensure that employees’ salaries fall in the range allowed for their job type, for insert and update operations.
    - Create a procedure called CHECK_SALARY as follows:
        * The procedure accepts two parameters, one for an employee’s job ID string and the other for the salary.
        * The procedure uses the job ID to determine the minimum and maximum salary for the specified job.
        * If the salary parameter does not fall within the salary range of the job, inclusive of the minimum and maximum, then it should raise an application exception, with the message “Invalid salary <sal>. Salaries for job <jobid> must be between <min> and <max>”. Replace the various items in the message with values supplied by parameters and variables populated by queries.
    - Create a trigger called CHECK_SALARY_TRG on the EMPLOYEES table that fires before an INSERT or UPDATE operation on each row:
        * The trigger must call the CHECK_SALARY procedure to carry out the business logic.
        * The trigger should pass the new job ID and salary to the procedure parameters.
Test the CHECK_SAL_TRG trigger using different cases

3. Update the CHECK_SALARY_TRG trigger to fire only when the job ID or salary values have actually changed.
Test the trigger.

4. You are asked to prevent employees from being deleted during business hours.   Write a statement trigger called DELETE_EMP_TRG on the EMPLOYEES table to prevent rows from being deleted during weekday business hours, which are from 9:00 AM to 6:00 PM.
Test the trigger with different cases.

5. Create a trigger called CHECK_SAL_RANGE that is fired before every row that is updated in the MIN_SALARY and MAX_SALARY columns in the JOBS table. For any minimum or maximum salary value that is changed, check whether the salary of any existing employee with that job ID in the EMPLOYEES table falls within the new range of salaries specified for this job ID. Include exception handling to cover a salary range change that affects the record of any existing employee.
Test the trigger using different cases.

 