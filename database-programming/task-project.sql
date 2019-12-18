-- Design and implement a database system. Topic: Hotel database

-- Note the following guidelines:
-- Grade 3
    -- - at least 5 tables should be defined.
    -- - the database schema reflects all the attributes and dependencies of the “real” objects within the given topic.
    -- - there are relationships between tables based on primary and foreign keys.
    -- - sample data are provided for all the tables,
    -- - at least 10 SQL queries for data preview should be defined; aggregate functions and SQL clauses should be considered,
    -- - at least 3 procedures performing different operations should be defined (e.g. for adding, modification, and retrieving data from the database)
    -- - functions that enable calculations should be defined (at least 2).

-- Grade 4
    -- - all requirements for the assessment of 3, plus:
    -- - definitions of procedures and functions should prove your high database skills (complexity, "if" statements, loops, cursors, handling exceptions ...) and should differ in data they work on, operations they perform, and attributes they accept.

-- Grade 5
    -- - all requirements for the assessment of 4, plus:
    -- - at least 3 tables should have triggers defined,
    -- - additional database structures should be defined, e.g. packages, database scheduler, ...

-- Note: No interface is required (except for standard database output).



CREATE TABLE jobs ( 
    job_id          NUMBER(10) NOT NULL PRIMARY KEY, 
    job_title       VARCHAR2(35) NOT NULL, 
    min_salary      NUMBER(6), 
    max_salary      NUMBER(6)
);

CREATE TABLE employees ( 
    employee_id     NUMBER(10) NOT NULL PRIMARY KEY, 
    first_name      VARCHAR2(20) NOT NULL, 
    last_name       VARCHAR2(25) NOT NULL,
    email           VARCHAR2(25) NOT NULL,
    phone_number    VARCHAR2(20) NOT NULL, 
    hire_date       DATE NOT NULL,
    salary          NUMBER(8,2), 
    job_id          VARCHAR2(10) NOT NULL,
    supervisor_id   NUMBER(10), 
    CONSTRAINT      emp_salary_min      CHECK (salary > 0), 
    CONSTRAINT      emp_job_id_fk       FOREIGN KEY (job_id) REFERENCES jobs (job_id), 
    CONSTRAINT      emp_supervisor_fk   FOREIGN KEY (supervisor_id) REFERENCES employees
);

CREATE TABLE guests ( 
    guest_id        NUMBER(10) NOT NULL PRIMARY KEY, 
    first_name      VARCHAR2(20), 
    last_name       VARCHAR2(25),
    email           VARCHAR2(25),
    phone_number    VARCHAR2(20), 
    CONSTRAINT      gue_gue_id_pk       PRIMARY KEY (employee_id), 
    CONSTRAINT      gue_gue_id_uk       UNIQUE (employee_id),
    CONSTRAINT      gue_first_name_nn   CHECK (first_name NOT NULL), 
    CONSTRAINT      gue_last_name_nn    CHECK (last_name NOT NULL), 
    CONSTRAINT      gue_phone_email_nn  CHECK (email NOT NULL OR phone_number NOT NULL)
);


CREATE TABLE beds ( 
    bed_id          NUMBER(10) NOT NULL PRIMARY KEY,
    bed_type        ENUM('for kids', 'sofa', 'normal', 'luxurious'),
    capacity        NUMBER(1), 
    CONSTRAINT      bed_bed_id_pk       PRIMARY KEY (bed_id),
    CONSTRAINT      bed_bed_id_uk       UNIQUE (bed_id),
	CONSTRAINT      bed_bed_type_nn     CHECK (bed_type NOT NULL),
	CONSTRAINT      bed_capacity_nn     CHECK (capacity NOT NULL)
);

CREATE TABLE rooms ( 
    room_id         NUMBER(10) NOT NULL PRIMARY KEY, 
    capacity        NUMBER(2), 
    has_bathroom    BOOLEAN,
    smoking_allowed BOOLEAN,
    pets_allowed    BOOLEAN,
    maintainer_id   NUMBER(10), 
    CONSTRAINT      room_room_id_pk     PRIMARY KEY (room_id),
    CONSTRAINT      room_room_id_uk     UNIQUE (room_id),
	CONSTRAINT      room_bed_id_nn      CHECK (bed_id NOT NULL),
    CONSTRAINT      room_maintainer_fk  FOREIGN KEY (maintainer_id) REFERENCES employees
);

CREATE TABLE bedsToRooms ( 
    bed_id          NUMBER(10),
    room_id         NUMBER(10),
	CONSTRAINT      btr_bed_id_nn     CHECK (bed_id NOT NULL),
    CONSTRAINT      btr_bed_id_fk  FOREIGN KEY (bed_id) REFERENCES beds,
	CONSTRAINT      btr_room_id_nn    CHECK (room_id NOT NULL),
    CONSTRAINT      btr_room_id_fk  FOREIGN KEY (room_id) REFERENCES rooms
);

CREATE TABLE reservations ( 
    reservation_id  NUMBER(10) NOT NULL PRIMARY KEY,
    check_in_date   DATE,
    check_out_date  DATE,
    room_costs      NUMBER(6),
    extra_costs     NUMBER(6),
    payment_status  VARCHAR2(10),
    guest_id        NUMBER(10),
    room_id         NUMBER(10),
    CONSTRAINT      res_res_id_pk       PRIMARY KEY (reservation_id),
    CONSTRAINT      res_res_id_uk       UNIQUE (reservation_id),
    CONSTRAINT      res_guest_id_fk     FOREIGN KEY (guest_id) REFERENCES guests,
    CONSTRAINT      res_room_id_fk      FOREIGN KEY (room_id) REFERENCES rooms
);

TODO: 
    at least 3 procedures performing different operations should be defined (e.g. for adding, modification, and retrieving data from the database)
        - checkIfRoomAvailable(check_in_date DATE, check_out_date DATE)
        - addReservation(...)
        - addEmployee(...)
        - ?...?

    at least 10 SQL queries for data preview should be defined; aggregate functions and SQL clauses should be considered,
        - ...
    
    at least 2 functions that enable calculations should be defined
        - ...
