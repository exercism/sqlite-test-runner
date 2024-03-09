UPDATE leap
SET is_leap = 1
WHERE year % 4 != 0;