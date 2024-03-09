UPDATE leap
SET is_leap = 1
WHERE year % 100 != 0;

SELECT *
FROM leap;