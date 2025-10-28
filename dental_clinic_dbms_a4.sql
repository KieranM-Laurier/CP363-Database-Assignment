DROP DATABASE IF EXISTS dental_clinic_dbms_a4;
CREATE DATABASE dental_clinic_dbms_a4;

USE dental_clinic_dbms_a4;

CREATE TABLE  dentist  (
  Dentist_ID  				INT 			NOT NULL	AUTO_INCREMENT,
  Dentist_Name  			VARCHAR(50) 	NOT NULL,
  Dentist_Specality  		VARCHAR(255) 	NOT NULL,
  Dentist_Phone  			VARCHAR(50) 	NOT NULL,
  Dentist_Email  			VARCHAR(50) 	NOT NULL,
  PRIMARY KEY ( Dentist_ID ),
  UNIQUE KEY  Dentist_Phone_UNIQUE  ( Dentist_Phone ),
  UNIQUE KEY  Dentist_Email_UNIQUE  ( Dentist_Email )
);

CREATE TABLE  insurance  (
  Insurance_ID  			INT 			NOT NULL	AUTO_INCREMENT,
  Insurance_Name  			VARCHAR(50) 	NOT NULL,
  Insurance_Plan  			VARCHAR(255) 	NOT NULL,
  Insurance_Coverage  		VARCHAR(255) 	NOT NULL,
  PRIMARY KEY ( Insurance_ID ),
  UNIQUE KEY  Insurance_Name_UNIQUE  ( Insurance_Name )
);

CREATE TABLE  patient  (
  Patient_ID  				INT 			NOT NULL	AUTO_INCREMENT,
  Patient_Name  			VARCHAR(50) 	NOT NULL,
  Patient_DOB  				DATE 			NOT NULL,
  Patient_Sex  				CHAR(1) 		NOT NULL CHECK (Patient_Sex IN ('M', 'F')),
  Patient_Phone  			VARCHAR(50)		DEFAULT NULL,
  Patient_Address  			VARCHAR(255) 	NOT NULL,
  Patient_Insurance_ID  	INT 			DEFAULT NULL,
  PRIMARY KEY ( Patient_ID ),
  UNIQUE KEY  Patient_Phone_UNIQUE  ( Patient_Phone ),
  UNIQUE KEY  Patient_Address_UNIQUE  ( Patient_Address ),
  KEY  Patient_Insurance_ID  ( Patient_Insurance_ID ),
  CONSTRAINT  Patient_Insurance_ID  
	FOREIGN KEY ( Patient_Insurance_ID ) 
    REFERENCES  insurance  ( Insurance_ID )
);

CREATE TABLE  dental_assistant  (
  Assistant_ID  			INT 			NOT NULL	AUTO_INCREMENT,
  Assistant_Name  			VARCHAR(50) 	NOT NULL,
  Assistant_Phone  			VARCHAR(50) 	NOT NULL,
  Assistant_Shift  			DATETIME 		DEFAULT NULL,
  Assistant_Salary  		INT 			NOT NULL,
  PRIMARY KEY ( Assistant_ID ),
  UNIQUE KEY  Assistant_Phone_UNIQUE  ( Assistant_Phone )
);

CREATE TABLE  medicine  (
  Medicine_ID  				INT 			NOT NULL	AUTO_INCREMENT,
  Medicine_Name  			VARCHAR(50) 	NOT NULL,
  Medicine_Price  			DECIMAL(9,2) 	NOT NULL,
  PRIMARY KEY ( Medicine_ID ),
  UNIQUE KEY  Medicine_Name_UNIQUE  ( Medicine_Name )
);

CREATE TABLE  prescription  (
  Prescription_ID  			INT 			NOT NULL	AUTO_INCREMENT,
  Dentist_Issuing_ID  		INT 			NOT NULL,
  Patient_Receiving_ID  	INT 			NOT NULL,
  Prescription_Dosage  		INT 			NOT NULL COMMENT 'Dosage in mg\n',
  Prescription_Date  		DATE 			NOT NULL COMMENT 'Date prescrption issued by dentist',
  PRIMARY KEY ( Prescription_ID ),
  KEY  Dentist_ID_UNIQUE  ( Dentist_Issuing_ID ),
  KEY  Patient_ID_UNIQUE  ( Patient_Receiving_ID ),
  CONSTRAINT  Dentist_Issuing_ID  
	FOREIGN KEY ( Dentist_Issuing_ID ) 
    REFERENCES  dentist  ( Dentist_ID ),
  CONSTRAINT  Patient_Receiving_ID  
	FOREIGN KEY ( Patient_Receiving_ID ) 
    REFERENCES  patient  ( Patient_ID )
);

CREATE TABLE  appointment  (
  Appointment_ID  			INT 			NOT NULL	AUTO_INCREMENT,
  Appointment_Date  		DATETIME 		NOT NULL,
  Appointment_Status  		TINYINT 		NOT NULL,
  Appointment_Patient  		INT 			NOT NULL,
  Appointment_Dentist  		INT 			NOT NULL,
  Appointment_Type  		VARCHAR(255) 	NOT NULL,
  PRIMARY KEY ( Appointment_ID ),
  KEY  Appointment_Patient_UNIQUE  ( Appointment_Patient ),
  KEY  Appointment_Dentist_UNIQUE  ( Appointment_Dentist ),
  CONSTRAINT  Appointment_Dentist  
	FOREIGN KEY ( Appointment_Dentist ) 
    REFERENCES  dentist  ( Dentist_ID ),
  CONSTRAINT  Appointment_Patient  
	FOREIGN KEY ( Appointment_Patient ) 
    REFERENCES  patient  ( Patient_ID )
);

CREATE TABLE  billing  (
  Bill_ID  					INT 			NOT NULL	AUTO_INCREMENT,
  Bill_Total  				DECIMAL(9,2) 	NOT NULL,
  Bill_Status  				CHAR(1)			NOT NULL CHECK (Bill_Status IN ('Y', 'N')),
  Bill_Date  				DATE 			NOT NULL,
  Appointment_Info  		INT 			NOT NULL,
  Patient_ID 				INT 			NOT NULL,
  PRIMARY KEY ( Bill_ID ),
  UNIQUE KEY  Appointment_Info_UNIQUE  ( Appointment_Info ),
  KEY  Appointment_Info_idx  ( Appointment_Info ),
  CONSTRAINT  Appointment_Info  
	FOREIGN KEY ( Appointment_Info ) 
	REFERENCES  appointment  ( Appointment_ID ),
  CONSTRAINT  Patient_ID
	FOREIGN KEY ( Patient_ID )
    REFERENCES  patient  ( Patient_ID )
);

CREATE TABLE  treatment  (
  Treatment_ID  			INT 			NOT NULL	AUTO_INCREMENT,
  Treatment_Name  			VARCHAR(50) 	NOT NULL,
  Treatment_Descripton  	VARCHAR(1000) 	NOT NULL,
  Treatment_Cost  			DECIMAL(9,2)	NOT NULL,
  PRIMARY KEY ( Treatment_ID )
);

CREATE TABLE  treatment_records  (
  Record_ID  				INT 			NOT NULL	AUTO_INCREMENT,
  Appointment_Information  	INT 			NOT NULL,
  Treatment_Info  			INT 			NOT NULL,
  Treatment_Notes 			VARCHAR(1000) 	DEFAULT NULL,
  PRIMARY KEY ( Record_ID ),
  KEY  Appointment_Info_UNIQUE  ( Appointment_Information ),
  KEY  Treatment_Info_UNIQUE  ( Treatment_Info ),
  CONSTRAINT  Appointment_Information  
	FOREIGN KEY ( Appointment_Information ) 
	REFERENCES  appointment  ( Appointment_ID ),
  CONSTRAINT  Treatment_Info  
	FOREIGN KEY ( Treatment_Info ) 
	REFERENCES  treatment  ( Treatment_ID )
);

CREATE TABLE appointment_assistant (
  Appointment_ID 			INT 			NOT NULL,
  Assistant_ID   			INT 			NOT NULL,
  Role         				VARCHAR(50) 	DEFAULT NULL, -- optional, e.g., "prep", "x-ray", etc.
  PRIMARY KEY (Appointment_ID, Assistant_ID),
  CONSTRAINT Appointment_ID
    FOREIGN KEY (Appointment_ID)
    REFERENCES appointment (Appointment_ID),
  CONSTRAINT Assistant_ID
    FOREIGN KEY (Assistant_ID)
    REFERENCES dental_assistant (Assistant_ID)
);

CREATE TABLE prescription_medicine (
  Prescription_ID 			INT 			NOT NULL,
  Medicine_ID   			INT 			NOT NULL,
  PRIMARY KEY (Prescription_ID, Medicine_ID),
  CONSTRAINT Prescription_ID
    FOREIGN KEY (Prescription_ID)
    REFERENCES prescription (Prescription_ID),
  CONSTRAINT Medicine_IDAppointment_ID
    FOREIGN KEY (Medicine_ID)
    REFERENCES medicine (Medicine_ID)
);




-- DENTISTS
INSERT INTO dentist VALUES
(NULL, 'Dr. Smith Johnson', 'Orthodontist', '111-111-1111', 'smith.j@clinic.com'),
(NULL, 'Dr. Alice Brown', 'Endodontist', '111-111-1112', 'alice.b@clinic.com'),
(NULL, 'Dr. Peter White', 'Pediatric Dentist', '111-111-1113', 'peter.w@clinic.com'),
(NULL, 'Dr. Laura Black', 'Oral Surgeon', '111-111-1114', 'laura.b@clinic.com'),
(NULL, 'Dr. James Green', 'Periodontist', '111-111-1115', 'james.g@clinic.com'),
(NULL, 'Dr. Sarah Grey', 'General Dentist', '111-111-1116', 'sarah.g@clinic.com'),
(NULL, 'Dr. Michael Blue', 'Prosthodontist', '111-111-1117', 'michael.b@clinic.com'),
(NULL, 'Dr. Clara Red', 'Cosmetic Dentist', '111-111-1118', 'clara.r@clinic.com'),
(NULL, 'Dr. Thomas Silver', 'Orthodontist', '111-111-1119', 'thomas.s@clinic.com'),
(NULL, 'Dr. Emma Gold', 'General Dentist', '111-111-1120', 'emma.g@clinic.com'),
(NULL, 'Dr. Nina Violet', 'Orthodontist', '111-111-1121', 'nina.v@clinic.com');

-- INSURANCE
INSERT INTO insurance VALUES
(NULL, 'SunLife', 'Gold Plan', 'Covers 80% dental'),
(NULL, 'Manulife', 'Silver Plan', 'Covers 60% dental'),
(NULL, 'BlueCross', 'Basic Plan', 'Covers 40% dental'),
(NULL, 'GreatWest', 'Premium', 'Covers 90% dental'),
(NULL, 'Guardian', 'Standard', 'Covers 50% dental'),
(NULL, 'Desjardins', 'Full Plan', 'Covers 100% dental'),
(NULL, 'GreenShield', 'Student Plan', 'Covers 70% dental'),
(NULL, 'Medavie', 'Employee Plan', 'Covers 75% dental'),
(NULL, 'Empire Life', 'Dental Plan', 'Covers 65% dental'),
(NULL, 'Canada Life', 'Basic Plan', 'Covers 45% dental');

-- PATIENTS
INSERT INTO patient VALUES
(NULL, 'John Doe', '1989-01-15', 'M', '222-111-1111', '123 King St', 1),
(NULL, 'Jane Smith', '2002-05-20', 'F', NULL, '456 Queen St', 2),
(NULL, 'Robert Brown', '1975-09-10', 'M', '222-111-1113', '789 Duke St', NULL),
(NULL, 'Emily Davis', '1998-11-05', 'F', '222-111-1114', '321 Maple St', 4),
(NULL, 'William Johnson', '1965-06-10', 'M', '222-111-1115', '654 Pine St', 5),
(NULL, 'Olivia Wilson', '1992-09-12', 'F', '222-111-1116', '987 Elm St', NULL),
(NULL, 'James Miller', '2005-02-18', 'M', '222-111-1117', '147 Oak St', 7),
(NULL, 'Sophia Taylor', '1983-12-25', 'F', '222-111-1118', '258 Birch St', 8),
(NULL, 'Liam Anderson', '1979-05-30', 'M', NULL, '369 Cedar St', 9),
(NULL, 'Ava Thomas', '2000-08-14', 'F', '222-111-1120', '741 Spruce St', 10),
(NULL, 'Clarens Holmes', '2001-06-12', 'M', NULL, '100 King St', 1),
(NULL, 'Daniel Harris', '1990-03-14', 'M', '222-111-1121', '789 University Ave', 3);

-- DENTAL ASSISTANTS
INSERT INTO dental_assistant VALUES
(NULL, 'Alice Ray', '333-111-1111', '2025-01-01 08:00:00', 40000),
(NULL, 'Bob King', '333-111-1112', '2025-01-02 09:30:00', 42000),
(NULL, 'Cathy Lee', '333-111-1113', '2025-01-03 10:00:00', 41000),
(NULL, 'David Park', '333-111-1114', '2025-01-04 11:15:00', 43000),
(NULL, 'Eva Green', '333-111-1115', NULL, 39000),
(NULL, 'Frank White', '333-111-1116', '2025-02-01 13:00:00', 44000),
(NULL, 'Grace Black', '333-111-1117', '2024-12-20 14:00:00', 39500),
(NULL, 'Henry Brown', '333-111-1118', '2025-03-05 15:45:00', 40500),
(NULL, 'Isla Blue', '333-111-1119', '2025-01-06 16:00:00', 42000),
(NULL, 'Jack Grey', '333-111-1120', '2025-01-10 17:30:00', 40000);

-- MEDICINE
INSERT INTO medicine VALUES
(NULL, 'Amoxicillin', 12.50),
(NULL, 'Ibuprofen', 8.00),
(NULL, 'Paracetamol', 5.50),
(NULL, 'Lidocaine', 15.75),
(NULL, 'Metronidazole', 18.00),
(NULL, 'Hydrocodone', 22.00),
(NULL, 'Naproxen', 10.25),
(NULL, 'Clindamycin', 14.75),
(NULL, 'Tramadol', 20.50),
(NULL, 'Diclofenac', 11.30);

-- PRESCRIPTIONS
INSERT INTO prescription VALUES
(NULL, 1, 1, 500, '2025-01-05'),
(NULL, 2, 2, 200, '2025-01-06'),
(NULL, 3, 3, 250, '2024-12-29'),
(NULL, 4, 4, 300, '2025-02-01'),
(NULL, 5, 5, 100, '2025-01-09'),
(NULL, 6, 6, 150, '2025-01-10'),
(NULL, 7, 7, 400, '2024-11-30'),
(NULL, 8, 8, 350, '2025-01-12'),
(NULL, 9, 9, 450, '2023-12-15'),
(NULL, 10, 10, 250, '2025-03-01'),
(NULL, 2, 1, 250, '2025-02-15'),
(NULL, 1, 2, 200, '2025-02-21'),
(NULL, 5, 3, 400, '2025-03-06'),
(NULL, 4, 4, 300, '2025-03-13'),
(NULL, 6, 5, 350, '2025-04-10'),
(NULL, 7, 6, 150, '2025-04-18'),
(NULL, 8, 7, 250, '2025-05-06'),
(NULL, 9, 8, 200, '2025-06-10'),
(NULL, 10, 9, 150, '2025-06-21'),
(NULL, 3, 10, 300, '2025-07-02');

-- APPOINTMENTS
INSERT INTO appointment VALUES
(NULL, '2025-01-05 09:00:00', 1, 1, 1, 'Checkup'),
(NULL, '2025-01-10 10:15:00', 0, 2, 2, 'Cleaning'),
(NULL, '2024-12-15 11:00:00', 1, 3, 3, 'Root Canal'),
(NULL, '2025-02-01 12:30:00', 1, 4, 4, 'Extraction'),
(NULL, '2025-03-09 13:00:00', 1, 5, 5, 'Whitening'),
(NULL, '2024-11-02 14:45:00', 0, 6, 6, 'Filling'),
(NULL, '2025-04-20 15:00:00', 1, 7, 7, 'Implant'),
(NULL, '2025-05-12 16:10:00', 1, 8, 8, 'Braces Consultation'),
(NULL, '2025-09-22 17:25:00', 1, 9, 9, 'Crown Placement'),
(NULL, '2025-10-01 08:50:00', 0, 10, 10, 'Routine Exam'),
(NULL, '2025-11-01 08:50:00', 0, 10, 10, 'Whitening'),
(NULL, '2025-02-15 09:30:00', 1, 1, 2, 'Whitening'),
(NULL, '2025-02-20 11:00:00', 1, 2, 1, 'Checkup'),
(NULL, '2025-03-05 13:15:00', 0, 3, 5, 'Cleaning'),
(NULL, '2025-03-12 14:00:00', 1, 4, 5, 'Filling'),
(NULL, '2025-04-10 10:00:00', 1, 5, 6, 'Extraction'),
(NULL, '2025-04-18 11:30:00', 0, 6, 7, 'Implant'),
(NULL, '2025-05-05 15:45:00', 1, 7, 8, 'Root Canal'),
(NULL, '2025-06-09 09:15:00', 1, 8, 2, 'Whitening'),
(NULL, '2025-06-20 16:45:00', 1, 9, 3, 'Routine Exam'),
(NULL, '2025-07-01 08:30:00', 0, 10, 4, 'Braces Consultation'),
(NULL, '2025-07-14 09:00:00', 1, 1, 3, 'Crown Placement'),
(NULL, '2025-08-05 10:00:00', 0, 11, 9, 'Cleaning'),
(NULL, '2025-08-12 10:45:00', 1, 4, 10, 'Routine Exam'),
(NULL, '2025-09-09 11:15:00', 0, 7, 1, 'Implant'),
(NULL, '2025-09-18 14:45:00', 1, 2, 8, 'Checkup'),
(NULL, '2025-10-22 12:15:00', 1, 5, 9, 'Whitening');

-- BILLING
INSERT INTO billing VALUES
(NULL, 150.00, 'Y', '2025-01-05', 1, 1),
(NULL, 0.00, 'N', '2025-01-10', 2, 2),
(NULL, 500.00, 'N', '2024-12-20', 3, 3),
(NULL, 255.00, 'Y', '2025-02-02', 4, 4),
(NULL, 185.00, 'Y', '2025-03-10', 5, 5),
(NULL, 120.00, 'N', '2024-11-05', 6, 6),
(NULL, 600.00, 'Y', '2025-04-21', 7, 7),
(NULL, 420.00, 'Y', '2025-05-13', 8, 8),
(NULL, 360.00, 'N', '2025-09-23', 9, 9),
(NULL, 90.00, 'Y', '2025-10-02', 10, 10),
(NULL, 220.00, 'Y', '2025-02-16', 12, 1),
(NULL, 180.00, 'Y', '2025-02-21', 13, 2),
(NULL, 0.00, 'N', '2025-03-06', 14, 3),
(NULL, 120.00, 'Y', '2025-03-13', 15, 4),
(NULL, 300.00, 'N', '2025-04-11', 16, 5),
(NULL, 450.00, 'Y', '2025-05-06', 18, 7),
(NULL, 260.00, 'Y', '2025-06-10', 19, 8),
(NULL, 150.00, 'N', '2025-06-21', 20, 9),
(NULL, 100.00, 'Y', '2025-07-02', 21, 10),
(NULL, 0.00, 'N', '2025-07-15', 22, 1),
(NULL, 180.00, 'Y', '2025-08-13', 23, 4),
(NULL, 0.00, 'N', '2025-09-10', 25, 7),
(NULL, 195.00, 'Y', '2025-09-19', 26, 2);

-- TREATMENTS
INSERT INTO treatment VALUES
(NULL, 'Checkup', 'Routine dental checkup', 100.00),
(NULL, 'Cleaning', 'Teeth cleaning and scaling', 150.00),
(NULL, 'Root Canal', 'Treatment of infected tooth pulp', 500.00),
(NULL, 'Extraction', 'Tooth removal procedure', 200.00),
(NULL, 'Whitening', 'Teeth whitening procedure', 250.00),
(NULL, 'Filling', 'Cavity filling with composite', 120.00),
(NULL, 'Implant', 'Dental implant surgery', 1000.00),
(NULL, 'Braces Consultation', 'Consultation for braces', 80.00),
(NULL, 'Crown Placement', 'Placement of dental crown', 600.00),
(NULL, 'Routine Exam', 'General oral exam', 90.00);

-- TREATMENT RECORDS
INSERT INTO treatment_records VALUES
(NULL, 1, 1, 'Normal checkup, no issues.'),
(NULL, 2, 2, 'Plaque buildup removed, mild gum redness.'),
(NULL, 3, 3, 'Severe pulp infection, full root canal completed.'),
(NULL, 4, 4, 'Wisdom tooth extracted under local anesthesia.'),
(NULL, 5, 5, 'Performed whitening treatment, mild sensitivity reported.'),
(NULL, 6, 6, 'Filling procedure completed successfully.'),
(NULL, 7, 7, 'Dental implant placed; patient scheduled for follow-up.'),
(NULL, 8, 8, 'Braces consultation; recommended Invisalign.'),
(NULL, 9, 9, 'Crown fitted and adjusted properly.'),
(NULL, 10, 10, 'Routine exam; advised bi-annual checkup.'),
(NULL, 12, 5, 'Whitening treatment successful.'),
(NULL, 13, 1, 'Regular checkup, noted early cavity.'),
(NULL, 14, 2, 'Scheduled cleaning rescheduled due to absence.'),
(NULL, 15, 6, 'Small filling done on upper molar.'),
(NULL, 16, 4, 'Extraction performed successfully.'),
(NULL, 18, 3, 'Root canal completed, antibiotics prescribed.'),
(NULL, 19, 5, 'Whitening performed, minor gum irritation.'),
(NULL, 20, 10, 'Routine check, advised flossing daily.'),
(NULL, 21, 9, 'Crown replacement done neatly.'),
(NULL, 23, 10, 'Routine exam for follow-up, healthy teeth.');

-- APPOINTMENT ASSISTANT LINK
INSERT INTO appointment_assistant VALUES
(1, 1, 'Prep'),
(2, 2, 'X-Ray'),
(3, 3, 'Sterilization'),
(4, 4, 'Procedure Assist'),
(5, 5, 'Whitening Support'),
(6, 6, 'Filling Assist'),
(7, 7, 'Surgical Prep'),
(8, 8, 'Braces Consultation'),
(9, 9, 'Crown Support'),
(10, 10, 'Routine Exam Prep'),
(12, 2, 'Prep'),
(13, 1, 'Sterilization'),
(14, 3, 'Cleaning Assist'),
(15, 4, 'Procedure Assist'),
(16, 5, 'Surgical Support'),
(18, 7, 'Root Canal Support'),
(19, 8, 'Whitening Support'),
(20, 9, 'Routine Exam Prep'),
(21, 10, 'Crown Fitting'),
(23, 1, 'Routine Exam Support');

-- PRESCRIPTION-MEDICINE LINK
INSERT INTO prescription_medicine VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 1),
(11, 2),
(12, 3),
(13, 4),
(14, 5),
(15, 6),
(16, 7),
(17, 8),
(18, 9),
(19, 10),
(20, 1),
(20, 9);