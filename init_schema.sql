-- ============================================================
-- init_schema.sql
-- Table structure for PRCE-001: Medical Data History
-- ============================================================

USE project_medical_data_history;

-- ------------------------------------------------------------
-- Table: patients
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS patients (
    patient_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(130),
    last_name VARCHAR(130),
    gender CHAR(1),
    birth_date DATE,
    city VARCHAR(130),
    province_id VARCHAR(10),
    allergies VARCHAR(130),
    height INT,
    weight INT
);

-- ------------------------------------------------------------
-- Table: doctors
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(130),
    last_name VARCHAR(130),
    specialty VARCHAR(125)
);

-- ------------------------------------------------------------
-- Table: province_names
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS province_names (
    province_id VARCHAR(10) NOT NULL PRIMARY KEY,
    province_name VARCHAR(130)
);

-- ------------------------------------------------------------
-- Table: admissions
-- Composite primary key on (patient_id, admission_date)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS admissions (
    patient_id INT NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    diagnosis VARCHAR(50),
    attending_doctor_id INT,
    PRIMARY KEY (patient_id, admission_date),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (attending_doctor_id) REFERENCES doctors(doctor_id)
);