USE dental_clinic_dbms_a4;

-- Find total revenue generated each dentist based on completed appointments
SELECT 
    d.Dentist_Name,
    SUM(b.Bill_Total) AS Total_Revenue,
    COUNT(b.Bill_ID) AS Total_Bills
FROM 
	billing b
JOIN 
	appointment a 
	ON b.Appointment_Info = a.Appointment_ID
JOIN 
	dentist d 
	ON a.Appointment_Dentist = d.Dentist_ID
WHERE 
	b.Bill_Status = 'Y'
GROUP BY 
	d.Dentist_ID
ORDER BY 
	Total_Revenue DESC;

-- Compare total billed amount per patient, showing only those with insurance coverage
SELECT 
    p.Patient_Name,
    i.Insurance_Name,
    SUM(b.Bill_Total) AS Total_Spent
FROM 
	billing b
JOIN 
	patient p 
	ON b.Patient_ID = p.Patient_ID
JOIN 
	insurance i 
    ON p.Patient_Insurance_ID = i.Insurance_ID
GROUP BY 
	p.Patient_ID, 
    i.Insurance_Name
HAVING 
	Total_Spent > 0
ORDER BY 
	Total_Spent DESC;

-- Compute average, min, and max cost for treatments performed
SELECT 
    t.Treatment_Name,
    COUNT(tr.Record_ID) AS Num_Performed,
    ROUND(AVG(t.Treatment_Cost), 2) AS Avg_Cost,
    MIN(t.Treatment_Cost) AS Min_Cost,
    MAX(t.Treatment_Cost) AS Max_Cost
FROM 
	treatment_records tr
JOIN 
	treatment t 
    ON tr.Treatment_Info = t.Treatment_ID
GROUP BY
	t.Treatment_Name
ORDER BY
	Avg_Cost DESC;

-- Find patients treated by the same dentist in more than one appointment
SELECT 
    d.Dentist_Name,
    p.Patient_Name,
    COUNT(a.Appointment_ID) AS Visits
FROM 
	appointment a
JOIN 
	dentist d 
    ON a.Appointment_Dentist = d.Dentist_ID
JOIN 
	patient p 
    ON a.Appointment_Patient = p.Patient_ID
GROUP BY 
	d.Dentist_Name,
    p.Patient_Name
HAVING 
	Visits > 1;

-- List dental assistants whose salary is above the clinic’s average
SELECT 
    Assistant_Name,
    Assistant_Salary
FROM
	dental_assistant
WHERE
	Assistant_Salary > (
    SELECT AVG(Assistant_Salary) FROM dental_assistant
)
ORDER BY 
	Assistant_Salary DESC;

-- List all patients, marking whether they have appointments
SELECT 
    p.Patient_Name,
    'Has Appointment' AS Status
FROM 
	patient p
JOIN 
	appointment a 
    ON p.Patient_ID = a.Appointment_Patient
UNION
SELECT 
    p.Patient_Name,
    'No Appointment' AS Status
FROM 
	patient p
WHERE 
	p.Patient_ID NOT IN (
		SELECT 
			Appointment_Patient 
        FROM 
			appointment
	)
ORDER BY 
	Patient_Name;
    
-- Assistants who participated in appointments involving treatments more expensive than the clinic’s average treatment cost.
SELECT DISTINCT 
    da.Assistant_Name,
    t.Treatment_Name,
    t.Treatment_Cost
FROM 
	dental_assistant da
JOIN 
	appointment_assistant aa ON da.Assistant_ID = aa.Assistant_ID
JOIN 
	appointment a 
	ON aa.Appointment_ID = a.Appointment_ID
JOIN 
	treatment_records tr 
    ON a.Appointment_ID = tr.Appointment_Information
JOIN 
	treatment t 
    ON tr.Treatment_Info = t.Treatment_ID
WHERE 
	t.Treatment_Cost > (
    SELECT AVG(Treatment_Cost) FROM treatment
)
ORDER BY 
	t.Treatment_Cost DESC;



-- SELECT: The average bill total per appointment for that dentist

CREATE OR REPLACE VIEW dentist_performance AS
SELECT 
    d.Dentist_ID,
    d.Dentist_Name,
    d.Dentist_Specality,
    (
        SELECT 
			COUNT(*)
        FROM 
			appointment a
        WHERE 
			a.Appointment_Dentist = d.Dentist_ID
    ) AS Total_Appointments,
    (
        SELECT 
			ROUND(AVG(b.Bill_Total), 2)
        FROM 
			billing b
        JOIN
			appointment a2 
            ON b.Appointment_Info = a2.Appointment_ID
        WHERE
			a2.Appointment_Dentist = d.Dentist_ID
    ) AS Avg_Bill_Per_Appointment
FROM 
	dentist d;

-- FROM:



-- WHERE: Patients who spent more than the average bill amount across the entire clinic
CREATE OR REPLACE VIEW v_high_spending_patients AS
SELECT 
    p.Patient_ID,
    p.Patient_Name,
    SUM(b.Bill_Total) AS Total_Spent
FROM 
	patient p
JOIN 
	billing b 
	ON p.Patient_ID = b.Patient_ID
WHERE 
	b.Bill_Total > (
    SELECT AVG(Bill_Total) FROM billing
)
GROUP BY 
	p.Patient_ID, 
    p.Patient_Name;


-- Show all views
SELECT * FROM dentist_performance;
-- SELECT * FROM xxxxxxxxxx
SELECT * FROM v_high_spending_patients;


