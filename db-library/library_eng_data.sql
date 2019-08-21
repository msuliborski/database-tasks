USE library;
GO

INSERT INTO members
VALUES('SJ123','Smith','Joseph','64101500456', '1964/10/15', 'M','0427650912');
INSERT INTO members
VALUES('WJ090','Wallace','Jennifer','76051900953','1976/05/19', 'F','0238651112');
INSERT INTO members
VALUES('CA009','Carter','Alicia','78070900953','1978/09/07', 'F','0427770822');
INSERT INTO members
VALUES('BA111','Best','Alec','62090200953','1962/02/09', 'M','0123310345');
INSERT INTO members
VALUES('CC212','Chace','Chris','67032000322','1967/03/20', 'M','0231510885');
GO
SELECT count(*) FROM members;
GO
SELECT * FROM members;
GO
INSERT INTO employees
VALUES('Knight','Brad','1965/10/21','1999/06/11');
INSERT INTO employees
VALUES('Jones','Adam','1968/11/21','1998/10/01');
INSERT INTO employees
VALUES('Grace','Andy','1975/10/23','2001/03/05');
INSERT INTO employees
VALUES('King','Ray','1975/06/02','2001/10/21');
INSERT INTO employees
VALUES('Reedy','Kate','1968/12/05','1998/01/01');
INSERT INTO employees
VALUES('Jarvis','Jill','1979/05/11','2001/09/05');
INSERT INTO employees
VALUES('Brown','Marie','1963/08/14','1998/01/01');
INSERT INTO employees
VALUES('Bays','Bonnie','1984/03/18','2002/03/01');
INSERT INTO employees
VALUES('Small','Elisabeth','1983/06/07','2002/09/15');
INSERT INTO employees 
VALUES('Brand','Anne','1970/08/17','2001/03/04');
GO
SELECT COUNT(*) FROM employees;
GO
SELECT * FROM employees;
GO
INSERT INTO publishers VALUES ('Berkley Publishing','Boston','635-12-09');
INSERT INTO publishers VALUES ('Course Technology', 'New York','025-22-03');
INSERT INTO publishers VALUES ('Touchstone Books', 'Westport CT','635-42-11');
INSERT INTO publishers VALUES ('Dom Ksi¹¿ki', 'Poznañ','775-24-92');
INSERT INTO publishers VALUES ('Penguin USA', 'New York','305-32-34');
GO
SELECT COUNT(*) FROM publishers;
GO
SELECT * FROM publishers;
GO
INSERT INTO Books VALUES(1,1,'Electric Light',45.50,320,'science');
INSERT INTO Books VALUES(2,2,'A Guide to SQL',68.90, 240,'science');
INSERT INTO Books VALUES(3,3,'Travels with Charley',39.90, 120, 'novel');
INSERT INTO Books VALUES(4,3,'Band of Brothers', 62.70, 359,'historical');
INSERT INTO Books VALUES(5,3,'Shortest Poems', 55.20, 322,'poems');
INSERT INTO Books VALUES(6,4,'Harry Potter and the Prisoner of Azkaban',29.00, 102, 'science fiction');
INSERT INTO Books VALUES(7,4,'Harry Potter and the Goblet of Fire', 21.30, 89, 'science fiction');
INSERT INTO Books VALUES(8,5,'Little Wind', 19.20, 55, 'for kids');
INSERT INTO Books VALUES(9,5,'Nine Stories', 15.90, 35, 'for kids');
INSERT INTO Books VALUES(10,2,'SQL for Dummies', 85.90, 210, 'science');
INSERT INTO Books VALUES(11,3,'East of Eden', 23.20, 384, 'novel');
INSERT INTO Books VALUES(12,3,'Van Gogh and Gauguin', 25.40, 245, 'historical');
GO
SELECT COUNT(*) FROM Books;
GO
SELECT * FROM Books;
GO

INSERT INTO Book_loans
VALUES(1,'SJ123',4,'2008/03/01','2008/07/28', 25.50);
INSERT INTO Book_loans
VALUES(2,'WJ090',2,'2008/03/04','2008/06/18',5.20);
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(3,'CA009',2,'2008/03/04','2008/03/20');
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(8,'CA009',1,'2008/03/20','2008/04/10');
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(8,'WJ090',1,'2008/04/12','2008/04/30');
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(4,'BA111',6,'2008/04/15','2008/06/12');
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(5,'BA111',6,'2008/04/15','2008/06/12');
INSERT INTO Book_loans
VALUES(12,'CC212',6,'2008/08/21','2008/12/21',12.1);
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(5,'CC212',6,'2008/06/21','2008/07/29');
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(10,'CC212',6,'2008/06/21','2008/08/08');
INSERT INTO Book_loans
VALUES(10,'SJ123',7,'2008/08/21','2008/11/09',8.80);
INSERT INTO Book_loans
VALUES(4,'CA009',7,'2008/08/22','2008/12/18',7.5);
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(2,'CC212',8,'2008/11/16','2009/01/19');
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(2,'CC212',8,'2008/11/17', NULL);
INSERT INTO Book_loans (BookID,CardNo,emp_id,DateOut,DueDate)
VALUES(11,'WJ090',9,'2008/11/21', NULL);
GO
SELECT COUNT(*) FROM Book_loans;
GO
SELECT * FROM Book_loans;
GO


