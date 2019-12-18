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
    job_id          NUMBER NOT NULL PRIMARY KEY, 
    job_title       VARCHAR2(35) NOT NULL, 
    min_salary      NUMBER(6), 
    max_salary      NUMBER(6)
);

CREATE TABLE employees ( 
    employee_id     NUMBER NOT NULL PRIMARY KEY, 
    first_name      VARCHAR2(20) NOT NULL, 
    last_name       VARCHAR2(25) NOT NULL,
    email           VARCHAR2(25) NOT NULL,
    phone_number    VARCHAR2(20) NOT NULL, 
    hire_date       DATE NOT NULL,
    salary          NUMBER(8), 
    job_id          NUMBER NOT NULL,
    supervisor_id   NUMBER, 
    CONSTRAINT      e_s_min         CHECK (salary > 0), 
    CONSTRAINT      e_j_fk          FOREIGN KEY (job_id) REFERENCES jobs (job_id), 
    CONSTRAINT      e_s_fk          FOREIGN KEY (supervisor_id) REFERENCES employees
);

CREATE TABLE guests ( 
    guest_id        NUMBER NOT NULL PRIMARY KEY, 
    first_name      VARCHAR2(20) NOT NULL, 
    last_name       VARCHAR2(25) NOT NULL,
    email           VARCHAR2(25),
    phone_number    VARCHAR2(20), 
    CONSTRAINT      g_p_e_nn  CHECK (email IS NOT NULL OR phone_number IS NOT NULL)
);


CREATE TABLE beds ( 
    bed_id          NUMBER NOT NULL PRIMARY KEY,
    bed_type        VARCHAR2(10) NOT NULL CHECK (bed_type IN ('for kids', 'sofa', 'normal', 'luxurious')),
    capacity        NUMBER(1) NOT NULL
);

CREATE TABLE rooms ( 
    room_id         NUMBER NOT NULL PRIMARY KEY, 
    capacity        NUMBER(2) NOT NULL, 
    has_bathroom    NUMBER(1,0) DEFAULT 0,
    smoking_allowed NUMBER(1,0) DEFAULT 0,
    pets_allowed    NUMBER(1,0) DEFAULT 0,
    maintainer_id   NUMBER,
    CONSTRAINT      r_m_fk  FOREIGN KEY (maintainer_id) REFERENCES employees
);

CREATE TABLE bedsToRooms ( 
    bed_id          NUMBER,
    room_id         NUMBER,
    CONSTRAINT      b_b_i_fk  FOREIGN KEY (bed_id) REFERENCES beds,
    CONSTRAINT      b_r_i_fk  FOREIGN KEY (room_id) REFERENCES rooms
);

CREATE TABLE reservations ( 
    reservation_id  NUMBER NOT NULL PRIMARY KEY,
    check_in_date   DATE NOT NULL,
    check_out_date  DATE NOT NULL,
    room_costs      NUMBER(6) NOT NULL,
    extra_costs     NUMBER(6),
    payment_status  VARCHAR2(10) NOT NULL CHECK (payment_status IN ('pending', 'paid', 'canceled')),
    guest_id        NUMBER NOT NULL,
    room_id         NUMBER NOT NULL,
    CONSTRAINT      r_gt_i_fk     FOREIGN KEY (guest_id) REFERENCES guests,
    CONSTRAINT      r_r_i_fk      FOREIGN KEY (room_id) REFERENCES rooms
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
