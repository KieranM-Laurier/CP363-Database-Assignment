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
  `Patient_Insurance_ID` int NOT NULL,
  PRIMARY KEY (`Patient_ID`),
  UNIQUE KEY `Patient_ID_UNIQUE` (`Patient_ID`),
  UNIQUE KEY `Patient_Phone_UNIQUE` (`Patient_Phone`),
  UNIQUE KEY `Patient_Address_UNIQUE` (`Patient_Address`),
  UNIQUE KEY `Patiend_Insurance_ID_UNIQUE` (`Patient_Insurance_ID`),
  CONSTRAINT `Insurance_ID` FOREIGN KEY (`Patient_Insurance_ID`) REFERENCES `insurance` (`Insurance_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Patient Entity';

