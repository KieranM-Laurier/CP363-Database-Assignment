
USE dental_clinic_dbms_a2;

-- this code segment generates the 'DESCRIBE table_name;' code for future use 
/*
SELECT CONCAT('DESCRIBE ', table_name, ';') 
FROM information_schema.tables 
WHERE table_schema = DATABASE();
*/

DESCRIBE appointment;
DESCRIBE appointment_assistant;
DESCRIBE billing;
DESCRIBE dental_assistant;
DESCRIBE dentist;
DESCRIBE insurance;
DESCRIBE medicine;
DESCRIBE patient;
DESCRIBE prescription;
DESCRIBE prescription_medicine;
DESCRIBE treatment;
DESCRIBE treatment_records;
