DROP DATABASE IF EXISTS dental_clinic_dbms_a2;
CREATE DATABASE dental_clinic_dbms_a2;

USE dental_clinic_dbms_a2;

CREATE TABLE `dentist` (
  `Dentist_ID` int NOT NULL,
  `Dentist_Name` varchar(45) NOT NULL,
  `Dentist_Specality` varchar(45) NOT NULL,
  `Dentist_Phone` int NOT NULL,
  `Dentist_Email` varchar(45) NOT NULL,
  PRIMARY KEY (`Dentist_ID`),
  UNIQUE KEY `Dentist_ID_UNIQUE` (`Dentist_ID`),
  UNIQUE KEY `Dentist_Phone_UNIQUE` (`Dentist_Phone`),
  UNIQUE KEY `Dentist_Email_UNIQUE` (`Dentist_Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dentist Entity';

CREATE TABLE `insurance` (
  `Insurance_ID` int NOT NULL,
  `Insurance_Name` varchar(45) NOT NULL,
  `Insurance_Plan` varchar(45) NOT NULL,
  `Insurance_Coverage` varchar(45) NOT NULL,
  PRIMARY KEY (`Insurance_ID`),
  UNIQUE KEY `Insurance_ID_UNIQUE` (`Insurance_ID`),
  UNIQUE KEY `Insurance_Name_UNIQUE` (`Insurance_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Insurance Entity';

CREATE TABLE `patient` (
  `Patient_ID` int NOT NULL,
  `Patient_Name` varchar(45) NOT NULL,
  `Patient_DOB` date NOT NULL,
  `Patient_Sex` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `Patient_Phone` int NOT NULL,
  `Patient_Address` varchar(45) NOT NULL,
  `Patient_Insurance_ID` int DEFAULT NULL,
  PRIMARY KEY (`Patient_ID`),
  UNIQUE KEY `Patient_ID_UNIQUE` (`Patient_ID`),
  UNIQUE KEY `Patient_Phone_UNIQUE` (`Patient_Phone`),
  UNIQUE KEY `Patient_Address_UNIQUE` (`Patient_Address`),
  KEY `Patient_Insurance_ID` (`Patient_Insurance_ID`),
  CONSTRAINT `Patient_Insurance_ID` FOREIGN KEY (`Patient_Insurance_ID`) REFERENCES `insurance` (`Insurance_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Patient Entity';

CREATE TABLE `dental_assistant` (
  `Assistant_ID` int NOT NULL,
  `Assistant_Name` varchar(45) NOT NULL,
  `Assistant_Phone` int NOT NULL,
  `Assistant_Shift` datetime NOT NULL,
  `Assistant_Salary` int NOT NULL,
  PRIMARY KEY (`Assistant_ID`),
  UNIQUE KEY `Assistant_ID_UNIQUE` (`Assistant_ID`),
  UNIQUE KEY `Assistant_Phone_UNIQUE` (`Assistant_Phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dental Assistant Entity, added salary attribute';

CREATE TABLE `medicine` (
  `Medicine_ID` int NOT NULL,
  `Medicine_Name` varchar(45) NOT NULL,
  `Medicine_Price` int NOT NULL,
  PRIMARY KEY (`Medicine_ID`),
  UNIQUE KEY `Medicine_ID_UNIQUE` (`Medicine_ID`),
  UNIQUE KEY `Medicine_Name_UNIQUE` (`Medicine_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Medicine Entity';

CREATE TABLE `prescription` (
  `Prescription_ID` int NOT NULL,
  `Dentist_Issuing_ID` int NOT NULL,
  `Patient_Receiving_ID` int NOT NULL,
  `Prescription_Dosage` int NOT NULL COMMENT 'Dosage in mg\n',
  `Prescription_Date` date NOT NULL COMMENT 'Date prescrption issued by dentist',
  PRIMARY KEY (`Prescription_ID`),
  UNIQUE KEY `Prescription_ID_UNIQUE` (`Prescription_ID`),
  UNIQUE KEY `Dentist_ID_UNIQUE` (`Dentist_Issuing_ID`),
  UNIQUE KEY `Patient_ID_UNIQUE` (`Patient_Receiving_ID`),
  CONSTRAINT `Dentist_Issuing_ID` FOREIGN KEY (`Dentist_Issuing_ID`) REFERENCES `dentist` (`Dentist_ID`),
  CONSTRAINT `Patient_Receiving_ID` FOREIGN KEY (`Patient_Receiving_ID`) REFERENCES `patient` (`Patient_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Prescription Entity, removed appointment_id as we felt it unnecessary';

CREATE TABLE `appointment` (
  `Appointment_ID` int NOT NULL,
  `Appointment_Date` datetime NOT NULL,
  `Appointment_Status` tinyint NOT NULL,
  `Appointment_Patient` int NOT NULL,
  `Appointment_Dentist` int NOT NULL,
  `Appointment_Type` varchar(45) NOT NULL,
  PRIMARY KEY (`Appointment_ID`),
  UNIQUE KEY `Appointment_ID_UNIQUE` (`Appointment_ID`),
  UNIQUE KEY `Appointment_Patient_UNIQUE` (`Appointment_Patient`),
  UNIQUE KEY `Appointment_Dentist_UNIQUE` (`Appointment_Dentist`),
  CONSTRAINT `Appointment_Dentist` FOREIGN KEY (`Appointment_Dentist`) REFERENCES `dentist` (`Dentist_ID`),
  CONSTRAINT `Appointment_Patient` FOREIGN KEY (`Appointment_Patient`) REFERENCES `patient` (`Patient_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Appointment Entity, date and time are now one attribute, status is either missed or there';

CREATE TABLE `billing` (
  `Bill_ID` int NOT NULL,
  `Bill_Total` int NOT NULL,
  `Bill_Status` tinyint NOT NULL COMMENT 'again cant make a boolean',
  `Bill_Date` date NOT NULL,
  `Appointment_Info` int NOT NULL,
  PRIMARY KEY (`Bill_ID`),
  UNIQUE KEY `Bill_ID_UNIQUE` (`Bill_ID`),
  UNIQUE KEY `Appointment_Info_UNIQUE` (`Appointment_Info`),
  KEY `Appointment_Info_idx` (`Appointment_Info`),
  CONSTRAINT `Appointment_Info` FOREIGN KEY (`Appointment_Info`) REFERENCES `appointment` (`Appointment_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Billing Entity';

CREATE TABLE `treatment` (
  `Treatment_ID` int NOT NULL,
  `Treatment_Name` varchar(45) NOT NULL,
  `Treatment_Desc` varchar(45) NOT NULL,
  `Treatment_Cost` int NOT NULL,
  PRIMARY KEY (`Treatment_ID`),
  UNIQUE KEY `Treatment_ID_UNIQUE` (`Treatment_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Treatment Entity';

CREATE TABLE `treatment_records` (
  `Record_ID` int NOT NULL,
  `Appointment_Information` int NOT NULL,
  `Treatment_Info` int NOT NULL,
  `Treatment_Notes` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Record_ID`),
  UNIQUE KEY `Record_ID_UNIQUE` (`Record_ID`),
  UNIQUE KEY `Appointment_Info_UNIQUE` (`Appointment_Information`),
  UNIQUE KEY `Treatment_Info_UNIQUE` (`Treatment_Info`),
  CONSTRAINT `Appointment_Information` FOREIGN KEY (`Appointment_Information`) REFERENCES `appointment` (`Appointment_ID`),
  CONSTRAINT `Treatment_Info` FOREIGN KEY (`Treatment_Info`) REFERENCES `treatment` (`Treatment_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Treatment Records Entity';







