USE dental_clinic_dbms_a2;

SELECT Appointment_Patient, Appointmnet_Date
FROM appointment
WHERE Appointment_Patient IN(
	SELECT Patient_Insurance_ID
    FROM patient
    WHERE Patient_Insurance_ID IS NULL
);
ORDER BY Appointment_Date