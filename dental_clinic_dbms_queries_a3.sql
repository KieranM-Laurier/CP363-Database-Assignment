USE dental_clinic_dbms_a2;
/*
5 queries
*/

-- patiendts that have not payed in over a week
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
    
    
    
SELECT Appointment_Patient, Appointmnet_Date
FROM appointment
WHERE Appointment_Patient IN(
	SELECT Patient_Insurance_ID
    FROM patient
    WHERE Patient_Insurance_ID IS NULL
);
ORDER BY Appointment_Date