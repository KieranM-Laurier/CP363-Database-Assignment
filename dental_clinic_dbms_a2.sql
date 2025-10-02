DROP DATABASE IF EXISTS dental_clinic_dbms_a2;
CREATE DATABASE dental_clinic_dbms_a2;

USE dental_clinic_dbms_a2;

CREATE TABLE  dentist  (
  Dentist_ID  				INT 			NOT NULL,
  Dentist_Name  			VARCHAR(50) 	NOT NULL,
  Dentist_Specality  		VARCHAR(255) 	NOT NULL,
  Dentist_Phone  			VARCHAR(50) 	NOT NULL,
  Dentist_Email  			VARCHAR(50) 	NOT NULL,
  PRIMARY KEY ( Dentist_ID ),
  UNIQUE KEY  Dentist_ID_UNIQUE  ( Dentist_ID ),
  UNIQUE KEY  Dentist_Phone_UNIQUE  ( Dentist_Phone ),
  UNIQUE KEY  Dentist_Email_UNIQUE  ( Dentist_Email )
);

CREATE TABLE  insurance  (
  Insurance_ID  			INT 			NOT NULL,
  Insurance_Name  			VARCHAR(50) 	NOT NULL,
  Insurance_Plan  			VARCHAR(255) 	NOT NULL,
  Insurance_Coverage  		VARCHAR(255) 	NOT NULL,
  PRIMARY KEY ( Insurance_ID ),
  UNIQUE KEY  Insurance_ID_UNIQUE  ( Insurance_ID ),
  UNIQUE KEY  Insurance_Name_UNIQUE  ( Insurance_Name )
);

CREATE TABLE  patient  (
  Patient_ID  				INT 			NOT NULL,
  Patient_Name  			VARCHAR(50) 	NOT NULL,
  Patient_DOB  				DATE 			NOT NULL,
  Patient_Sex  				CHAR(1) 		NOT NULL CHECK (Patient_Sex IN ('M', 'F')),
  Patient_Phone  			VARCHAR(50)		DEFAULT NULL,
  Patient_Address  			VARCHAR(255) 	NOT NULL,
  Patient_Insurance_ID  	INT 			DEFAULT NULL,
  PRIMARY KEY ( Patient_ID ),
  UNIQUE KEY  Patient_ID_UNIQUE  ( Patient_ID ),
  UNIQUE KEY  Patient_Phone_UNIQUE  ( Patient_Phone ),
  UNIQUE KEY  Patient_Address_UNIQUE  ( Patient_Address ),
  KEY  Patient_Insurance_ID  ( Patient_Insurance_ID ),
  CONSTRAINT  Patient_Insurance_ID  
	FOREIGN KEY ( Patient_Insurance_ID ) 
    REFERENCES  insurance  ( Insurance_ID )
);

CREATE TABLE  dental_assistant  (
  Assistant_ID  			INT 			NOT NULL,
  Assistant_Name  			VARCHAR(50) 	NOT NULL,
  Assistant_Phone  			VARCHAR(50) 	NOT NULL,
  Assistant_Shift  			DATETIME 		DEFAULT NULL,
  Assistant_Salary  		INT 			NOT NULL,
  PRIMARY KEY ( Assistant_ID ),
  UNIQUE KEY  Assistant_ID_UNIQUE  ( Assistant_ID ),
  UNIQUE KEY  Assistant_Phone_UNIQUE  ( Assistant_Phone )
);

CREATE TABLE  medicine  (
  Medicine_ID  				INT 			NOT NULL,
  Medicine_Name  			VARCHAR(50) 	NOT NULL,
  Medicine_Price  			DECIMAL(9,2) 	NOT NULL,
  PRIMARY KEY ( Medicine_ID ),
  UNIQUE KEY  Medicine_ID_UNIQUE  ( Medicine_ID ),
  UNIQUE KEY  Medicine_Name_UNIQUE  ( Medicine_Name )
);

CREATE TABLE  prescription  (
  Prescription_ID  			INT 			NOT NULL,
  Dentist_Issuing_ID  		INT 			NOT NULL,
  Patient_Receiving_ID  	INT 			NOT NULL,
  Prescription_Dosage  		INT 			NOT NULL COMMENT 'Dosage in mg\n',
  Prescription_Date  		DATE 			NOT NULL COMMENT 'Date prescrption issued by dentist',
  PRIMARY KEY ( Prescription_ID ),
  UNIQUE KEY  Prescription_ID_UNIQUE  ( Prescription_ID ),
  UNIQUE KEY  Dentist_ID_UNIQUE  ( Dentist_Issuing_ID ),
  UNIQUE KEY  Patient_ID_UNIQUE  ( Patient_Receiving_ID ),
  CONSTRAINT  Dentist_Issuing_ID  
	FOREIGN KEY ( Dentist_Issuing_ID ) 
    REFERENCES  dentist  ( Dentist_ID ),
  CONSTRAINT  Patient_Receiving_ID  
	FOREIGN KEY ( Patient_Receiving_ID ) 
    REFERENCES  patient  ( Patient_ID )
);

CREATE TABLE  appointment  (
  Appointment_ID  			INT 			NOT NULL,
  Appointment_Date  		DATETIME 		NOT NULL,
  Appointment_Status  		TINYINT 		NOT NULL,
  Appointment_Patient  		INT 			NOT NULL,
  Appointment_Dentist  		INT 			NOT NULL,
  Appointment_Type  		VARCHAR(255) 	NOT NULL,
  PRIMARY KEY ( Appointment_ID ),
  UNIQUE KEY  Appointment_ID_UNIQUE  ( Appointment_ID ),
  UNIQUE KEY  Appointment_Patient_UNIQUE  ( Appointment_Patient ),
  UNIQUE KEY  Appointment_Dentist_UNIQUE  ( Appointment_Dentist ),
  CONSTRAINT  Appointment_Dentist  
	FOREIGN KEY ( Appointment_Dentist ) 
    REFERENCES  dentist  ( Dentist_ID ),
  CONSTRAINT  Appointment_Patient  
	FOREIGN KEY ( Appointment_Patient ) 
    REFERENCES  patient  ( Patient_ID )
);

CREATE TABLE  billing  (
  Bill_ID  					INT 			NOT NULL,
  Bill_Total  				DECIMAL(9,2) 	NOT NULL,
  Bill_Status  				CHAR(1)			NOT NULL CHECK (Bill_Status IN ('Y', 'N')),
  Bill_Date  				DATE 			NOT NULL,
  Appointment_Info  		INT 			NOT NULL,
  Patient_ID 				INT 			NOT NULL,
  PRIMARY KEY ( Bill_ID ),
  UNIQUE KEY  Bill_ID_UNIQUE  ( Bill_ID ),
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
  Treatment_ID  			INT 			NOT NULL,
  Treatment_Name  			VARCHAR(50) 	NOT NULL,
  Treatment_Descripton  	VARCHAR(1000) 	NOT NULL,
  Treatment_Cost  			DECIMAL(9,2)	NOT NULL,
  PRIMARY KEY ( Treatment_ID ),
  UNIQUE KEY  Treatment_ID_UNIQUE  ( Treatment_ID )
);

CREATE TABLE  treatment_records  (
  Record_ID  				INT 			NOT NULL,
  Appointment_Information  	INT 			NOT NULL,
  Treatment_Info  			INT 			NOT NULL,
  Treatment_Notes 			VARCHAR(1000) 	DEFAULT NULL,
  PRIMARY KEY ( Record_ID ),
  UNIQUE KEY  Record_ID_UNIQUE  ( Record_ID ),
  UNIQUE KEY  Appointment_Info_UNIQUE  ( Appointment_Information ),
  UNIQUE KEY  Treatment_Info_UNIQUE  ( Treatment_Info ),
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

INSERT INTO dentist VALUES
(1, 'Dr. Smith Johnson', 'Orthodontist', '111-111-1111', 'smith.j@clinic.com'),
(2, 'Dr. Alice Brown', 'EndodontisAppointment_IDAppointment_Datet', '111-111-1112', 'alice.b@clinic.com'),
(3, 'Dr. Peter White', 'Pediatric Dentist', '111-111-1113', 'peter.w@clinic.com'),
(4, 'Dr. Laura Black', 'Oral Surgeon', '111-111-1114', 'laura.b@clinic.com'),
(5, 'Dr. James Green', 'Periodontist', '111-111-1115', 'james.g@clinic.com'),
(6, 'Dr. Sarah Grey', 'General Dentist', '111-111-1116', 'sarah.g@clinic.com'),
(7, 'Dr. Michael Blue', 'Prosthodontist', '111-111-1117', 'michael.b@clinic.com'),
(8, 'Dr. Clara Red', 'Cosmetic Dentist', '111-111-1118', 'clara.r@clinic.com'),
(9, 'Dr. Thomas Silver', 'Orthodontist', '111-111-1119', 'thomas.s@clinic.com'),
(10, 'Dr. Emma Gold', 'General Dentist', '111-111-1120', 'emma.g@clinic.com');

INSERT INTO insurance VALUES
(1, 'SunLife', 'Gold Plan', 'Covers 80% dental'),
(2, 'Manulife', 'Silver Plan', 'Covers 60% dental'),
(3, 'BlueCross', 'Basic Plan', 'Covers 40% dental'),
(4, 'GreatWest', 'Premium', 'Covers 90% dental'),
(5, 'Guardian', 'Standard', 'Covers 50% dental'),
(6, 'Desjardins', 'Full Plan', 'Covers 100% dental'),
(7, 'GreenShield', 'Student Plan', 'Covers 70% dental'),
(8, 'Medavie', 'Employee Plan', 'Covers 75% dental'),
(9, 'Empire Life', 'Dental Plan', 'Covers 65% dental'),
(10, 'Canada Life', 'Basic Plan', 'Covers 45% dental');

INSERT INTO patient VALUES
(1, 'John Doe', '1990-01-15', 'M', '222-111-1111', '123 King St', 1),
(2, 'Jane Smith', '1985-03-20', 'F', '222-111-1112', '456 Queen St', 2),
(3, 'Robert Brown', '2000-07-25', 'M', '222-111-1113', '789 Duke St', 3),
(4, 'Emily Davis', '1995-11-05', 'F', '222-111-1114', '321 Maple St', 4),
(5, 'William Johnson', '1988-06-10', 'M', '222-111-1115', '654 Pine St', 5),
(6, 'Olivia Wilson', '1992-09-12', 'F', '222-111-1116', '987 Elm St', 6),
(7, 'James Miller', '1978-02-18', 'M', '222-111-1117', '147 Oak St', 7),
(8, 'Sophia Taylor', '2002-12-25', 'F', '222-111-1118', '258 Birch St', 8),
(9, 'Liam Anderson', '1983-05-30', 'M', '222-111-1119', '369 Cedar St', 9),
(10, 'Ava Thomas', '1999-08-14', 'F', '222-111-1120', '741 Spruce St', 10);

INSERT INTO dental_assistant VALUES
(1, 'Alice Ray', '333-111-1111', '2025-01-01 08:00:00', 40000),
(2, 'Bob King', '333-111-1112', '2025-01-01 09:00:00', 42000),
(3, 'Cathy Lee', '333-111-1113', '2025-01-01 10:00:00', 41000),
(4, 'David Park', '333-111-1114', '2025-01-01 11:00:00', 43000),
(5, 'Eva Green', '333-111-1115', '2025-01-01 12:00:00', 39000),
(6, 'Frank White', '333-111-1116', '2025-01-01 13:00:00', 44000),
(7, 'Grace Black', '333-111-1117', '2025-01-01 14:00:00', 39500),
(8, 'Henry Brown', '333-111-1118', '2025-01-01 15:00:00', 40500),
(9, 'Isla Blue', '333-111-1119', '2025-01-01 16:00:00', 42000),
(10, 'Jack Grey', '333-111-1120', '2025-01-01 17:00:00', 40000);

INSERT INTO medicine VALUES
(1, 'Amoxicillin', 12.50),
(2, 'Ibuprofen', 8.00),
(3, 'Paracetamol', 5.50),
(4, 'Lidocaine', 15.75),
(5, 'Metronidazole', 18.00),
(6, 'Hydrocodone', 22.00),
(7, 'Naproxen', 10.25),
(8, 'Clindamycin', 14.75),
(9, 'Tramadol', 20.50),
(10, 'Diclofenac', 11.30);

INSERT INTO prescription VALUES
(1, 1, 1, 500, '2025-01-05'),
(2, 2, 2, 200, '2025-01-06'),
(3, 3, 3, 250, '2025-01-07'),
(4, 4, 4, 300, '2025-01-08'),
(5, 5, 5, 100, '2025-01-09'),
(6, 6, 6, 150, '2025-01-10'),
(7, 7, 7, 400, '2025-01-11'),
(8, 8, 8, 350, '2025-01-12'),
(9, 9, 9, 450, '2025-01-13'),
(10, 10, 10, 250, '2025-01-14');

INSERT INTO appointment VALUES
(1, '2025-01-05 09:00:00', 1, 1, 1, 'Checkup'),
(2, '2025-01-06 10:00:00', 1, 2, 2, 'Cleaning'),
(3, '2025-01-07 11:00:00', 1, 3, 3, 'Root Canal'),
(4, '2025-01-08 12:00:00', 0, 4, 4, 'Extraction'),
(5, '2025-01-09 13:00:00', 1, 5, 5, 'Whitening'),
(6, '2025-01-10 14:00:00', 1, 6, 6, 'Filling'),
(7, '2025-01-11 15:00:00', 0, 7, 7, 'Implant'),
(8, '2025-01-12 16:00:00', 1, 8, 8, 'Braces Consultation'),
(9, '2025-01-13 17:00:00', 1, 9, 9, 'Crown Placement'),
(10, '2025-01-14 18:00:00', 0, 10, 10, 'Routine Exam');

INSERT INTO billing VALUES
(1, 150.00, 'Y', '2025-01-05', 1, 1),
(2, 200.00, 'Y', '2025-01-06', 2, 2),
(3, 500.00, 'N', '2025-01-07', 3, 3),
(4, 250.00, 'Y', '2025-01-08', 4, 4),
(5, 180.00, 'Y', '2025-01-09', 5, 5),
(6, 120.00, 'N', '2025-01-10', 6, 6),
(7, 600.00, 'Y', '2025-01-11', 7, 7),
(8, 400.00, 'Y', '2025-01-12', 8, 8),
(9, 350.00, 'N', '2025-01-13', 9, 9),
(10, 90.00, 'Y', '2025-01-14', 10, 10);

INSERT INTO treatment VALUES
(1, 'Checkup', 'Routine dental checkup', 100.00),
(2, 'Cleaning', 'Teeth cleaning and scaling', 150.00),
(3, 'Root Canal', 'Treatment of infected tooth pulp', 500.00),
(4, 'Extraction', 'Tooth removal procedure', 200.00),
(5, 'Whitening', 'Teeth whitening procedure', 250.00),
(6, 'Filling', 'Cavity filling with composite', 120.00),
(7, 'Implant', 'Dental implant surgery', 1000.00),
(8, 'Braces Consultation', 'Consultation for braces', 80.00),
(9, 'Crown Placement', 'Placement of dental crown', 600.00),
(10, 'Routine Exam', 'General oral exam', 90.00);

INSERT INTO treatment_records VALUES
(1, 1, 1, 'Normal checkup, no issues'),
(2, 2, 2, 'Mild tartar buildup, cleaned'),
(3, 3, 3, 'Severe pulp infection, root canal done'),
(4, 4, 4, 'Wisdom tooth extracted'),
(5, 5, 5, 'Patient opted for whitening'),
(6, 6, 6, 'Cavity filled successfully'),
(7, 7, 7, 'Implant performed successfully'),
(8, 8, 8, 'Discussed braces options'),
(9, 9, 9, 'Crown fitted and adjusted'),
(10, 10, 10, 'Routine exam, healthy teeth');

INSERT INTO appointment_assistant VALUES
(1, 1, 'prep'),
(2, 2, 'x-ray'),
(3, 3, 'assistant'),
(4, 4, 'prep'),
(5, 5, 'x-ray'),
(6, 6, 'assistant'),
(7, 7, 'prep'),
(8, 8, 'x-ray'),
(9, 9, 'assistant'),
(10, 10, 'prep');

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
(10, 10);

