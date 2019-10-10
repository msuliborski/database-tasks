if exists(select 1 from master.dbo.sysdatabases where name = 'library') drop database library
GO
CREATE DATABASE library
GO

CREATE TABLE library.dbo.members (
CardNo 	CHAR(5) CONSTRAINT mem1_PK PRIMARY KEY,
Surname 	VARCHAR(15) NOT NULL,
Name 	VARCHAR(15) NOT NULL,
Address  VARCHAR(150),
Birthday_date 	SMALLDATETIME NOT NULL,
Gender 	CHAR(1) NOT NULL CONSTRAINT gender_check CHECK(Gender='F' OR Gender='M'),
Phone_No 	VARCHAR(15)

);
GO

CREATE TABLE library.dbo.employees (
emp_id 	INT IDENTITY(1,1) CONSTRAINT emp1_PK PRIMARY KEY,
Surname 	VARCHAR(15) NOT NULL,
Name 	VARCHAR(15) NOT NULL,
Birthday_date 	SMALLDATETIME NOT NULL,
Emp_date	SMALLDATETIME NOT NULL,
CONSTRAINT date_check CHECK (Birthday_date < Emp_date)
); 
GO

CREATE TABLE library.dbo.publishers (
pub_id 	INT IDENTITY(1,1) CONSTRAINT pubs_PK PRIMARY KEY,
Name 	VARCHAR(50) NOT NULL,
City 	VARCHAR(50) NOT NULL,
Phone_No 	VARCHAR(15)
);
GO

CREATE TABLE library.dbo.books (
BookId 	CHAR(5) CONSTRAINT books_PK PRIMARY KEY,
Pub_id	INT,
Title 	VARCHAR(40) NOT NULL,
Price 	MONEY NOT NULL,
PagesNo   INT,
BookType	VARCHAR(30),
CONSTRAINT pubs_FK FOREIGN KEY(pub_id) REFERENCES publishers(pub_id), 
CONSTRAINT Booktype_check CHECK(BookType IN ('novel','historical', 'for kids', 'poems', 'crime', 'science fiction', 'science'))
);
GO

CREATE TABLE library.dbo.book_loans (
Loan_id	INT IDENTITY(1,1),
BookId 	CHAR(5) NOT NULL,
CardNo	CHAR(5) NOT NULL,
emp_id 	INT NOT NULL,
DateOut 	SMALLDATETIME,
DueDate	SMALLDATETIME,
Penalty 	MONEY DEFAULT 0 NOT NULL,
CONSTRAINT loan_PK PRIMARY KEY(Loan_Id),
CONSTRAINT mem_FK FOREIGN KEY(CardNo) REFERENCES members(CardNo), 
CONSTRAINT emp_FK FOREIGN KEY(emp_id) REFERENCES employees(emp_id),
CONSTRAINT book_FK FOREIGN KEY(BookId) REFERENCES books(BookId),
CONSTRAINT check_date CHECK(DateOut < DueDate),
CONSTRAINT check_pen CHECK(penalty >= 0)
);
GO