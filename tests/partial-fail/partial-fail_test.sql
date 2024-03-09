
.read ./create_fixture.sql

.mode markdown
.output user_output.md
.read ./partial-fail.sql
.output

DROP TABLE IF EXISTS main.tests;

CREATE TABLE IF NOT EXISTS main.tests (
    uuid TEXT PRIMARY KEY,
	name TEXT NOT NULL,
    status TEXT DEFAULT 'fail',
    message TEXT,
    output TEXT,
    test_code TEXT,
    task_id INTEGER DEFAULT NULL,
    year INT NOT NULL,
    result BOOL NOT NULL
);

INSERT INTO tests (name, uuid, year, result)
    VALUES
        ('not_divisible_by_4', '6466b30d-519c-438e-935d-388224ab5223', 2015, 0),
        ('divisible_by_2_not_divisible_by_4', 'ac227e82-ee82-4a09-9eb6-4f84331ffdb0', 1970, 0),
        ('divisible_by_4_not_divisible_by_100', '4fe9b84c-8e65-489e-970b-856d60b8b78e', 1996, 1),
        ('divisible_by_100_not_divisible_by_400', '78a7848f-9667-4192-ae53-87b30c9a02dd', 2100, 0),
        ('divisible_by_400', '42ee56ad-d3e6-48f1-8e3f-c84078d916fc', 2000, 1),
        ('divisible_by_200_not_divisible_by_400', 'c30331f6-f9f6-4881-ad38-8ca8c12520c1', 1800, 0);

UPDATE tests
SET status = 'pass'
FROM (SELECT year, is_leap FROM leap) AS l
WHERE (l.year, l.is_leap) = (tests.year, tests.result);

UPDATE tests
SET message = 'Result for ' || l.year || ' is: ' || l.is_leap || ', but should be: ' || tests.result
FROM (SELECT year, is_leap FROM leap) AS l
WHERE l.year = tests.year AND tests.status = 'fail';

.mode json
.once './output.json'

SELECT name, status, message, output, test_code, task_id
FROM tests;

.mode table
SELECT name, status, message
FROM tests;