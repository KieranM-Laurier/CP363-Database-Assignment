DROP DATABASE IF EXISTS dental_clinic_dbms_a2;
CREATE DATABASE dental_clinic_dbms_a2;

USE dental_clinic_dbms_a2;

CREATE TABLE  dentist  (
  Dentist_ID  				INT 			NOT NULL,
  Dentist_Name  			VARCHAR(50) 	NOT NULL,
  Dentist_Specality  		VARCHAR(255) 	NOT NULL,
  Dentist_Phone  			INT 			NOT NULL,
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
  Patient_Phone  			INT 			DEFAULT NULL,
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
  Assistant_Phone  			INT 			NOT NULL,
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
  PRIMARY KEY ( Bill_ID ),
  UNIQUE KEY  Bill_ID_UNIQUE  ( Bill_ID ),
  UNIQUE KEY  Appointment_Info_UNIQUE  ( Appointment_Info ),
  KEY  Appointment_Info_idx  ( Appointment_Info ),
  CONSTRAINT  Appointment_Info  
	FOREIGN KEY ( Appointment_Info ) 
	REFERENCES  appointment  ( Appointment_ID )
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
  CONSTRAINT Medicine_ID
    FOREIGN KEY (Medicine_ID)
    REFERENCES medicine (Medicine_ID)
);





