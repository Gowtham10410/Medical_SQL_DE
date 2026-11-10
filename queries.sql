-- ============================================================
-- PRCE-001: Medical Data History
-- Data Engineering Project
-- Author: GOWTHAMA PRASATH M
-- Date: 2026-09-18
-- Environment: MySQL 8 (hosted at 18.136.157.135:3306)
-- Tool: MySQL Workbench
-- ============================================================

-- ============================================================
-- SECTION 1: INITIAL SETUP & EXPLORATION
-- ============================================================

-- List all databases available on the server
SHOW DATABASES;

-- -- Initially I explored information_schema to understand the server,
-- -- but quickly realised this was not the project database.
-- USE information_schema;
-- SHOW TABLES;
-- DESCRIBE information_schema;

-- Switch to the actual project database
USE project_medical_data_history;

-- List the tables in this database
SHOW TABLES;
-- Output: admissions, doctors, patients, province_names

-- Inspect table structures before writing queries (data profiling)
DESCRIBE patients;
DESCRIBE admissions;
DESCRIBE doctors;
DESCRIBE province_names;

-- Preview the actual data to understand its shape
SELECT * FROM patients LIMIT 5;
SELECT * FROM doctors LIMIT 5;
SELECT * FROM admissions LIMIT 5;
SELECT * FROM province_names;


-- ============================================================
-- SECTION 2: THE 35 PROBLEM QUERIES
-- ============================================================

-- Q1. Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name, gender
FROM patients
WHERE gender = 'M';


-- Q2. Show first name and last name of patients who do not have allergies
SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;


-- Q3. Show first name of patients that start with the letter 'C'
-- Note: Used LIKE (not =) because we want pattern matching, not exact match.
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';


-- Q4. Show first name and last name of patients that weigh between 100 and 120 (inclusive)
SELECT first_name, last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;


-- Q5. Update the patients table: replace NULL allergies with 'NKA'
-- Attempted query:
UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;
-- ERROR 1142 (42000): UPDATE command denied to user 'dm_team4'@'...'
-- Reason: The course-provided user has read-only permissions.
-- The query is syntactically correct; it would work if permissions allowed.
-- Verification of the "before" state:
SELECT COUNT(*) AS null_allergies FROM patients WHERE allergies IS NULL;


-- Q6. Show first name and last name concatenated into one column
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;


-- Q7. Show first name, last name, and full province name of each patient
SELECT p.first_name, p.last_name, pn.province_name
FROM patients p
INNER JOIN province_names pn ON p.province_id = pn.province_id;


-- Q8. Count patients born in 2010
SELECT COUNT(*) AS patients_born_in_2010
FROM patients
WHERE YEAR(birth_date) = 2010;


-- Q9. Show patient with the greatest height
-- Note: Used a subquery (not LIMIT 1) so ties are handled correctly.
SELECT first_name, last_name, height
FROM patients
WHERE height = (SELECT MAX(height) FROM patients);


-- Q10. Show all columns for patients with specific patient_ids
SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);


-- Q11. Show total number of admissions
SELECT COUNT(*) AS total_admissions
FROM admissions;


-- Q12. Show admissions where patient was admitted and discharged on same day
SELECT *
FROM admissions
WHERE admission_date = discharge_date;


-- Q13. Total admissions for patient_id 579
SELECT COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;


-- Q14. Unique cities in province_id 'NS' (Nova Scotia)
SELECT DISTINCT city
FROM patients
WHERE province_id = 'NS';


-- Q15. Patients with height > 160 and weight > 70
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;


-- Q16. Unique birth years, ordered ascending
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year ASC;


-- Q17. First names that occur exactly once
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;


-- Q18. First names starting and ending with 's', at least 6 characters long
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%'
  AND first_name LIKE '%s'
  AND LENGTH(first_name) >= 6;


-- Q19. Patients with diagnosis 'Dementia'
-- Approach 1: Using subquery
SELECT patient_id, first_name, last_name
FROM patients
WHERE patient_id IN (
    SELECT patient_id FROM admissions WHERE diagnosis = 'Dementia'
);

-- Approach 2: Using INNER JOIN (more explicit about the relationship)
SELECT DISTINCT p.patient_id, p.first_name, p.last_name
FROM patients p
INNER JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';


-- Q20. Every patient's first name, ordered by length then alphabetically
SELECT first_name
FROM patients
ORDER BY LENGTH(first_name), first_name;
-- Note: Multiple sort keys are separated by commas, NOT by AND.


-- Q21 & Q22. Male and female patient counts in the same row
SELECT
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM patients;


-- Q23. Patients admitted multiple times for the same diagnosis
SELECT patient_id, diagnosis, COUNT(*) AS admitted_for_same_diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1
ORDER BY admitted_for_same_diagnosis DESC;


-- Q24. City + total patients, ordered by count desc, then city asc
SELECT city, COUNT(*) AS no_of_patients
FROM patients
GROUP BY city
ORDER BY no_of_patients DESC, city ASC;


-- Q25. All people (patients + doctors) with their role
SELECT first_name, last_name, 'Patient' AS role FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role FROM doctors;


-- Q26. Allergies by popularity, excluding NULLs
SELECT allergies, COUNT(*) AS patient_count
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY patient_count DESC;


-- Q27. Patients born in the 1970s, sorted by earliest birth date
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;


-- Q28. Full name as UPPERCASE_lastname,LOWERCASE_firstname, sorted by first_name DESC
-- Note: Fixed — the separator must be a comma, not a space.
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM patients
ORDER BY first_name DESC;


-- Q29. Provinces where total patient height >= 7000
SELECT province_id, SUM(height) AS total_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;


-- Q30. Weight range (max - min) for patients with last name 'Maroni'
-- Note: Single quotes used for string literals (portable across databases).
SELECT MAX(weight) - MIN(weight) AS weight_range
FROM patients
WHERE last_name = 'Maroni';


-- Q31. Admission count per day-of-month, ordered by count desc
SELECT DAY(admission_date) AS day_of_month, COUNT(*) AS admission_count
FROM admissions
GROUP BY DAY(admission_date)
ORDER BY admission_count DESC;


-- Q32. Patients grouped into weight buckets of 10
SELECT FLOOR(weight / 10) * 10 AS weight_group, COUNT(*) AS patient_count
FROM patients
GROUP BY FLOOR(weight / 10) * 10
ORDER BY weight_group DESC;


-- Q33. patient_id, weight, height, isObese (BMI >= 30)
SELECT
    patient_id,
    weight,
    height,
    CASE
        WHEN weight / POWER(height / 100.0, 2) >= 30 THEN 1
        ELSE 0
    END AS isObese
FROM patients;


-- Q34. Patients with 'Epilepsy' diagnosis attended by doctor 'Lisa'
SELECT DISTINCT
    p.patient_id,
    p.first_name,
    p.last_name,
    d.specialty
FROM patients p
INNER JOIN admissions a ON p.patient_id = a.patient_id
INNER JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
  AND d.first_name = 'Lisa';


-- Q35. Temporary password for patients who have had admissions
-- Password = patient_id + length(last_name) + birth_year
SELECT DISTINCT
    p.patient_id,
    CONCAT(p.patient_id, LENGTH(p.last_name), YEAR(p.birth_date)) AS temp_password
FROM patients p
INNER JOIN admissions a ON p.patient_id = a.patient_id
ORDER BY p.patient_id;


-- ============================================================
-- SECTION 3: HANDS-ON EXPLORATION & DATA QUALITY CHECKS
-- ============================================================

-- Inspect indexes and table definitions
SHOW INDEX FROM patients;
SHOW CREATE TABLE patients;
SHOW INDEX FROM admissions;

-- List all tables and their types
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'project_medical_data_history';

-- Enriched patient view with province names (JOIN practice)
SELECT
    p.patient_id, p.first_name, p.last_name, p.province_id, pn.province_name
FROM patients p
INNER JOIN province_names pn ON p.province_id = pn.province_id
LIMIT 10;

-- Patient count per province (aggregation practice)
SELECT
    pn.province_name,
    COUNT(*) AS patient_count
FROM patients p
INNER JOIN province_names pn ON p.province_id = pn.province_id
GROUP BY pn.province_name
ORDER BY patient_count DESC;

-- Data quality checks
-- 1. Admissions that haven't been discharged yet (NULL discharge_date)
SELECT COUNT(*) AS null_discharges
FROM admissions
WHERE discharge_date IS NULL;

-- 2. Impossible dates: discharge before admission (data error indicator)
SELECT COUNT(*) AS impossible_dates
FROM admissions
WHERE discharge_date < admission_date;

-- 3. Unusual weights (potential data entry issues or paediatric cases)
SELECT patient_id, first_name, last_name, weight, height, birth_date
FROM patients
WHERE weight < 10 OR weight > 200
ORDER BY weight;

-- 4. Orphaned admissions (patient_id with no matching patient record)
SELECT COUNT(*) AS orphaned_admissions
FROM admissions a
LEFT JOIN patients p ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- ============================================================
-- END OF FILE
-- ============================================================