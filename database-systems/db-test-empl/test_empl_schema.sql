

if exists(select 1 from master.dbo.sysdatabases where name = 'test_empl') drop database test_empl
GO
CREATE DATABASE test_empl;
GO
CREATE TABLE test_empl.dbo.departments (
id_dep	int, 
name	VARCHAR(15), 
seat VARCHAR(15),
CONSTRAINT departments_primary_key PRIMARY KEY (id_dep)
);
GO

CREATE TABLE test_empl.dbo.jobs (
job	VARCHAR(18),
salary_min money, 
salary_max	money, 
CONSTRAINT stan_primary_key PRIMARY KEY (job)
);
GO
CREATE TABLE test_empl.dbo.employees (
num_id int, 
name	VARCHAR(20), 
job VARCHAR(18),
boss int CONSTRAINT emp_self_key REFERENCES employees (num_id), 
start_date	DATETIME, 
end_date	DATETIME, 
salary MONEY, 
bonus MONEY, 
commision MONEY, 
id_dep	INT,
CONSTRAINT emp_primary_key PRIMARY KEY (num_id), 
CONSTRAINT emp_foreign_key FOREIGN KEY (id_dep) REFERENCES departments (id_dep)
);
GO
CREATE TABLE test_empl.dbo.empl_archiw (
num_id INT, 
name VARCHAR(20), 
job VARCHAR(18),
boss INT, 
start_date DATETIME, 
end_date DATETIME, 
salary MONEY, 
bonus MONEY DEFAULT 0, 
commission MONEY DEFAULT 0, 
id_dep	INT
 );
GO





