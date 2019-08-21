INSERT INTO member VALUES
('Velasquez','Carmen','283 King Street','Seattle','587-99-6666','2014-03-03');  


INSERT INTO member VALUES
('Ngao','LaDoris','5 Modrany','Bratislava','586-355-8882','2014-03-08'); 
  
INSERT INTO member VALUES
('Nagayama','Midori','68 Via Centrale','Sao Paolo','254-852-5764','2014-06-17');                

INSERT INTO member VALUES
('Quick-To-See','Mark','6921 King Way','Lagos','63-559-777','2014-04-07'); 
        
INSERT INTO member VALUES 
('Ropeburn','Audry','86 Chu Street','Hong Kong','41-559-87','2014-03-04');  
                                                                         
INSERT INTO member VALUES
  ('Urguhart','Molly','3035 Laurier Blvd.','Quebec','418-542-9988','2014-01-18');

INSERT INTO member VALUES 
('Menchu','Roberta','Boulevard de Waterloo 41','Brussels','322-504-2228','2014-05-14');

INSERT INTO member VALUES 
('Biri','Ben','398 High St.','Columbus','614-455-9863','2014-03-03');

INSERT INTO member VALUES 
('Catchpole','Antoinette','88 Alfred St.','Brisbane','616-399-1411','2014-03-03');
GO

INSERT INTO TITLE 
( title, description, rating, category, release_date)
VALUES	( 'Willie and Christmas Too',  
  'All of Willie''s friends made a Christmas list for Santa, but Willie has yet 
   to create his own wish list.','G','CHILD','2013-03-03');

INSERT INTO TITLE 
(title, description, rating, category, release_date)
VALUES	('Alien Again','Another installment of science fiction 
  history. Can the heroine save the planet from the alien life 
  form?','R','SCIFI','2013-04-03');

INSERT INTO TITLE 
(title, description, rating, category, release_date)
VALUES ('The Glob',
  'A meteor crashes near a small American town and unleashes carnivorous goo 
   in this classic.','NR','SCIFI','2013-03-08');

INSERT INTO TITLE 
(title, description, rating, category, release_date)
VALUES ('My Day Off','With a little luck and a lot 
   of ingenuity, a teenager skips school for a day in NewYork.',
  'PG','COMEDY','2013-07-04');

INSERT INTO TITLE 
(title, description, rating, category, release_date)
VALUES	('Miracles on Ice',
   'A six-year-old has doubts about Santa Claus. But she discovers 
    that miracles really do exist.','PG','DRAMA',
    '2012-02-01');

INSERT INTO TITLE 
(title, description, rating, category, release_date)
VALUES	('Soda Gang','After discovering a cached of 
   drugs, a young couple find themselves pitted against a vicious 
   gang.','NR','ACTION','2013-03-23');

INSERT INTO TITLE
(title, description, rating, category, release_date)
VALUES	('Interstellar Wars', 'Futuristic
	interstellar action movie.  Can the rebels save the humans from
	the evil Empire?', 'PG', 'SCIFI','2011-03-03');

GO

INSERT INTO title_copy VALUES (1,1,'AVAILABLE');
INSERT INTO title_copy VALUES (1,2,'AVAILABLE');
INSERT INTO title_copy VALUES (2,2,'RENTED'); 
INSERT INTO title_copy VALUES (1,3,'AVAILABLE'); 
INSERT INTO title_copy VALUES (1,4,'AVAILABLE'); 
INSERT INTO title_copy VALUES (2,4,'AVAILABLE'); 
INSERT INTO title_copy VALUES (3,4,'RENTED');
INSERT INTO title_copy VALUES (1,5,'AVAILABLE');
INSERT INTO title_copy VALUES (1,6,'AVAILABLE');
INSERT INTO title_copy VALUES (1,7,'RENTED');
INSERT INTO title_copy VALUES (2,7,'AVAILABLE');

GO

INSERT INTO reservation VALUES (DATEADD(DAY,-1,GETDATE()),1,2);
INSERT INTO reservation VALUES (DATEADD(DAY,-2,GETDATE()),5,2);

GO

INSERT INTO rental VALUES (DATEADD(DAY,-1,GETDATE()),2,1,2,null,DATEADD(DAY,+1,GETDATE()));
INSERT INTO rental VALUES (DATEADD(DAY,-2,GETDATE()),3,2,4,null,GETDATE());
INSERT INTO rental VALUES (DATEADD(DAY,-3,GETDATE()),1,3,7,null,DATEADD(DAY,-1,GETDATE()));
INSERT INTO rental VALUES (DATEADD(DAY,-4,GETDATE()),1,6,6,DATEADD(DAY,-2,GETDATE()),DATEADD(DAY,-2,GETDATE()));
INSERT INTO rental VALUES (DATEADD(DAY,-5,GETDATE()),1,1,1,DATEADD(DAY,-2,GETDATE()),DATEADD(DAY,-1,GETDATE()));

