USE dental_clinic_dbms_a3;

-- patiendts that have not paid in over a week
SELECT 
    p.Patient_ID,
    p.Patient_Name,
    p.Patient_Phone,
    b.Bill_ID,
    b.Bill_Total,
    b.Bill_Date,
    DATEDIFF(CURDATE(), b.Bill_Date) AS Days_Unpaid
FROM 
    billing b
JOIN 
    patient p ON b.Patient_ID = p.Patient_ID
WHERE 
    b.Bill_Status = 'N'
    AND DATEDIFF(CURDATE(), b.Bill_Date) >= 7
ORDER BY 
    Days_Unpaid DESC;

-- patients who have an appointment in the next week days
SELECT 
    p.Patient_Name,
    a.Appointment_Date,
    a.Appointment_Type,
    d.Dentist_Name
FROM 
    appointment a
JOIN 
    patient p ON a.Appointment_Patient = p.Patient_ID
JOIN 
    dentist d ON a.Appointment_Dentist = d.Dentist_ID
WHERE 
    a.Appointment_Date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY 
    a.Appointment_Date ASC;


-- total revenue collected by each dentist
SELECT 
    d.Dentist_Name,
    SUM(b.Bill_Total) AS Total_Revenue
FROM 
    billing b
JOIN 
    appointment a ON b.Appointment_Info = a.Appointment_ID
JOIN 
    dentist d ON a.Appointment_Dentist = d.Dentist_ID
WHERE 
    b.Bill_Status = 'Y'
GROUP BY 
    d.Dentist_Name
ORDER BY 
    Total_Revenue DESC;

-- Most common treatments performed
SELECT 
    t.Treatment_Name,
    COUNT(tr.Treatment_Info) AS Times_Performed
FROM 
    treatment_records tr
JOIN 
    treatment t ON tr.Treatment_Info = t.Treatment_ID
GROUP BY 
    t.Treatment_Name
ORDER BY 
    Times_Performed DESC;
    
-- Dental Assistants and their assigned roles
SELECT 
    da.Assistant_Name,
    d.Dentist_Name,
    a.Appointment_ID,
    a.Appointment_Type,
    aa.Role
FROM 
    appointment_assistant aa
JOIN 
    dental_assistant da ON aa.Assistant_ID = da.Assistant_ID
JOIN 
    appointment a ON aa.Appointment_ID = a.Appointment_ID
JOIN 
    dentist d ON a.Appointment_Dentist = d.Dentist_ID
ORDER BY 
    da.Assistant_Name;

-- Patients who received the most expensive treatment
SELECT 
    p.Patient_Name,
    t.Treatment_Name,
    t.Treatment_Cost
FROM 
    treatment_records tr
JOIN 
    appointment a ON tr.Appointment_Information = a.Appointment_ID
JOIN 
    patient p ON a.Appointment_Patient = p.Patient_ID
JOIN 
    treatment t ON tr.Treatment_Info = t.Treatment_ID
WHERE 
    t.Treatment_Cost = (
        SELECT MAX(Treatment_Cost) 
        FROM treatment
    );

-- Patients whose bill total is above the average bill amount
SELECT 
    p.Patient_Name,
    b.Bill_Total
FROM 
	billing b
JOIN 
	patient p ON b.Patient_ID = p.Patient_ID
WHERE b.Bill_Total > (
    SELECT AVG(Bill_Total)
    FROM billing
);

-- Correlated subquery: Patients whose bill exceeds their own average
SELECT 
    p.Patient_Name,
    b.Bill_Total
FROM 
	billing b
JOIN 
	patient p ON b.Patient_ID = p.Patient_ID
WHERE b.Bill_Total > (
    SELECT AVG(b2.Bill_Total)
    FROM billing b2
    WHERE b2.Patient_ID = b.Patient_ID
);

-- Ranking dentists by total revenue collected
SELECT 
    d.Dentist_Name,
    SUM(b.Bill_Total) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(b.Bill_Total) DESC) AS Revenue_Rank
FROM 
	billing b
JOIN 
	appointment a ON b.Appointment_Info = a.Appointment_ID
JOIN 
	dentist d ON a.Appointment_Dentist = d.Dentist_ID
GROUP BY d.Dentist_Name;
    
-- patients who recieved the cheapest treatment 
SELECT 
    p.Patient_Name,
    t.Treatment_Name,
    t.Treatment_Cost
FROM 
    treatment_records tr
JOIN 
    appointment a ON tr.Appointment_Information = a.Appointment_ID
JOIN 
    patient p ON a.Appointment_Patient = p.Patient_ID
JOIN 
    treatment t ON tr.Treatment_Info = t.Treatment_ID
WHERE 
    t.Treatment_Cost = (
        SELECT MAX(Treatment_Cost) 
        FROM treatment
    );
    
-- Dental assistants whose salary are above average
SELECT
	da.Assistant_ID,
	da.Assistant_Salary,
    da.Assistant_Name
FROM 
	dental_assistant da
WHERE da.Assistant_Salary > (
		SELECT
			AVG(Assistant_Salary)
		FROM 
			dental_assistant
	);

-- patients who have not had an appointment in the last 6 months
SELECT 
    p.Patient_Name,
    a.Appointment_Date,
    a.Appointment_Type,
    d.Dentist_Name
FROM 
    appointment a
JOIN 
    patient p ON a.Appointment_Patient = p.Patient_ID
JOIN 
    dentist d ON a.Appointment_Dentist = d.Dentist_ID
WHERE 
    a.Appointment_Date BETWEEN CURDATE() AND DATE_SUB(CURDATE(), INTERVAL 180 DAY)
ORDER BY 
    a.Appointment_Date ASC;

-- patients with no health insurance
SELECT
	p.Patient_Name,
	p.Patient_ID,
    p.Patient_Insurance_ID
FROM 
	patient p
WHERE 
	p.Patient_Insurance_ID IS NOT NULL
ORDER BY
	p.Patient_ID;

-- View 1: Total Revenue per Dentist
CREATE VIEW Dentist_Revenue_View AS
SELECT 
    d.Dentist_Name,
    SUM(b.Bill_Total) AS Total_Revenue,
    COUNT(b.Bill_ID) AS Bills_Count
FROM 
	billing b
JOIN 
	appointment a ON b.Appointment_Info = a.Appointment_ID
JOIN 
	dentist d ON a.Appointment_Dentist = d.Dentist_ID
GROUP BY 
	d.Dentist_Name
ORDER BY 
	Total_Revenue DESC;

-- View 2: Patients with Total Amount Spent
CREATE VIEW Patient_Billing_Summary AS
SELECT 
    p.Patient_Name,
    COUNT(b.Bill_ID) AS Number_of_Bills,
    SUM(b.Bill_Total) AS Total_Spent,
    ROUND(AVG(b.Bill_Total), 2) AS Avg_Bill
FROM 
	billing b
JOIN 
	patient p ON b.Patient_ID = p.Patient_ID
GROUP BY 
	p.Patient_Name
ORDER BY 
	Total_Spent DESC;

-- View 3: Upcoming Appointments Summary
CREATE VIEW Upcoming_Appointments AS
SELECT DISTINCT
    a.Appointment_ID,
    p.Patient_Name,
    d.Dentist_Name,
    a.Appointment_Date,
    a.Appointment_Type
FROM 
	appointment a
JOIN 
	patient p ON a.Appointment_Patient = p.Patient_ID
JOIN 
	dentist d ON a.Appointment_Dentist = d.Dentist_ID
WHERE 
	a.Appointment_Date >= CURDATE()
ORDER BY 
	a.Appointment_Date ASC;
