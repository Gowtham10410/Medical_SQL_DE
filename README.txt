============================================================
PRCE-001: Medical Data History - SQL Environment
============================================================
Author : GOWTHAMA PRASATH M
Course : Data Engineering (CDE)
Batch  : 16-MAR-26-CDE-BUN-031-WDE2030-ONL
Date   : 18 September 2026

------------------------------------------------------------
OVERVIEW
------------------------------------------------------------
This project demonstrates SQL querying skills on a medical 
database containing patient demographics, hospital admissions,
doctor information, and province data.

The SQL queries answer 35 questions covering:
  - Basic SELECT and filtering
  - JOINs across multiple tables
  - Aggregate functions (COUNT, SUM, MAX, MIN)
  - GROUP BY and HAVING clauses
  - Conditional aggregation
  - String and date functions

------------------------------------------------------------
PROJECT STRUCTURE
------------------------------------------------------------
Dockerfile              - MySQL 8 container definition
docker-compose.yml      - Compose file for easy startup
init_schema.sql         - Database schema (tables + foreign keys)
queries.sql             - All 35 SQL queries
Medical_Data_History_Report.docx - Project report
README.txt              - This file


------------------------------------------------------------
PREREQUISITES
------------------------------------------------------------
  - Docker Desktop (Windows/Mac) or Docker Engine (Linux)
  - A terminal (PowerShell, CMD, or bash)
  - A SQL client (MySQL Workbench, DBeaver, or command-line)

------------------------------------------------------------
HOW TO RUN THE PROJECT
------------------------------------------------------------

Step 1: Build the Docker image
------------------------------------------------------------
  Open a terminal in the project folder and run:

    docker build -t medical-data-history .

Step 2: Run the container
------------------------------------------------------------
    docker run --name medical_db -p 3306:3306 -d medical-data-history

  This starts MySQL on localhost:3306 with:
    - Database: project_medical_data_history
    - User:     dm_team4
    - Password: DM_Team_Password_2024

Step 3: Wait for MySQL to initialize
------------------------------------------------------------
  The container takes ~30 seconds to initialize on first run.
  Check status with:

    docker logs medical_db

  Wait for the message: "ready for connections"

Step 4: Connect and run queries
------------------------------------------------------------
  Option A: Use MySQL Workbench
     - Host:     127.0.0.1
     - Port:     3306
     - User:     dm_team4
     - Password: DM_Team_Password_2024
     - Database: project_medical_data_history

  Option B: Use the command line
     
     docker exec -it medical_db mysql -u dm_team4 -p
     (enter password when prompted)

     Then run:
     USE project_medical_data_history;
     SOURCE /docker-entrypoint-initdb.d/02_queries.sql;

Step 5: Stop and remove the container (when done)
------------------------------------------------------------
    docker stop medical_db
    docker rm medical_db

------------------------------------------------------------
NOTE ON DATA
------------------------------------------------------------
The original project used a remote MySQL server 
(18.136.157.135:3306) with read-only credentials. This 
Dockerfile provides a LOCAL MySQL environment with the same 
schema, so the project can be reproduced without needing 
access to the remote server.

To use real data instead of an empty schema, replace or 
extend init_schema.sql with INSERT statements containing 
the actual patient/admission/doctor records.





============================================================
NOTE ON DOCKER RUNTIME TESTING
============================================================

The Dockerfile in this submission has been VERIFIED to:
  - Build successfully with: docker build --platform linux/amd64 .
  - Produce a valid linux/amd64 image (verified via docker inspect)
  - Correctly copy init_schema.sql and queries.sql into the image
  - Use the official mysql:8.0 base image (correct digest)

During local runtime testing on Windows 11 (build 26200.9457), 
starting ANY Linux container — including the unmodified official 
mysql:8.0 image — failed with:

    exec /usr/local/bin/docker-entrypoint.sh: exec format error

The same error occurred with:
    docker run --rm mysql:8.0 mysql --version

This confirms the failure is caused by the WSL 2 backend on the 
host Windows machine, NOT by the Dockerfile or any project files.

Troubleshooting steps attempted:
  1. Rebuilt image with explicit --platform linux/amd64 flag
  2. Increased Windows paging file from default to 4GB/8GB
  3. Reset Docker Desktop to factory defaults
  4. Unregistered and re-registered the docker-desktop WSL distro
  5. Verified architecture match: client and server both report
     linux/amd64

None of the above resolved the runtime error. The root cause is a
known incompatibility between Docker Desktop's WSL 2 backend and
preview builds of Windows 11.

The Dockerfile is expected to work correctly on:
  - Any Linux host with Docker installed
  - macOS with Docker Desktop
  - Windows 11 with a stable (non-preview) build and healthy WSL 2

To run this project on a working Docker environment:
    docker build --platform linux/amd64 -t medical-data-history .
    docker run --name medical_db -p 3307:3306 -d medical-data-history
    docker logs medical_db  # wait for "ready for connections"
    docker exec -it medical_db mysql -u dm_team4 -p

============================================================
END OF NOTE
============================================================

