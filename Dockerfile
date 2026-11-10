# ============================================================
# PRCE-001: Medical Data History - SQL Environment
# Author: GOWTHAMA PRASATH M
# Course: Data Engineering (CDE)
# Batch: 16-MAR-26-CDE-BUN-031-WDE2030-ONL
# Date: 18 September 2026
# ============================================================

# Base image: Official MySQL 8.0 server
FROM mysql:8.0

# Metadata
LABEL maintainer="GOWTHAMA PRASATH M"
LABEL description="MySQL environment for PRCE-001 Medical Data History project"
LABEL version="1.0"

# Environment variables for MySQL initialization
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=project_medical_data_history
ENV MYSQL_USER=dm_team4
ENV MYSQL_PASSWORD=DM_Team_Password_2024

# Copy initialization SQL scripts.
# Any .sql file placed in /docker-entrypoint-initdb.d/ is automatically
# executed by the MySQL container on first startup.
COPY init_schema.sql /docker-entrypoint-initdb.d/01_schema.sql
COPY queries.sql /docker-entrypoint-initdb.d/02_queries.sql

# Expose the default MySQL port
EXPOSE 3306

# The base image already includes the default CMD to run mysqld.
# No need to override unless custom configuration is required.