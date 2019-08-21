CREATE DATABASE test_suliborski;
USE test_suliborski;

DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS bands;
ALTER TABLE bands
    DROP CONSTRAINT IF EXISTS band_res;

CREATE TABLE bands
(
    band_id        INTEGER NOT NULL PRIMARY KEY IDENTITY (0, 1),
    name           VARCHAR(40),
    origin_country VARCHAR(50),
    formed_year    INTEGER NULL
);

SELECT count(*)
FROM bands;

INSERT INTO bands
VALUES ('The Beatles', 'England', 1960);


SELECT *
FROM bands;

SELECT count(*)
FROM bands;

CREATE TABLE members
(
    memeber_id INTEGER NOT NULL PRIMARY KEY IDENTITY (100, 1),
    band_id    INTEGER,
    surname    VARCHAR(60),
    name       VARCHAR(50),
    FOREIGN KEY (band_id) REFERENCES bands (band_id)
)

INSERT INTO members
VALUES (0, 'John', 'Lennon')
INSERT INTO members
VALUES (0, 'Paul', 'McCartney')

INSERT INTO bands
VALUES ('Queen', 'Great Britain', 1971)

INSERT INTO members
VALUES (1, 'Freddie', 'Mercury')

ALTER TABLE bands
    DROP CONSTRAINT IF EXISTS band_res;
ALTER TABLE bands
    ADD CONSTRAINT band_res CHECK (formed_year >= 1920)

INSERT INTO bands
VALUES ('Queen', 'Great Britain', 1910)

SELECT *
FROM members;