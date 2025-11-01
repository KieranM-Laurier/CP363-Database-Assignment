"""
-------------------------------------------------------
[program description]
-------------------------------------------------------
Author:  Kieran Mochrie
ID:      169048254
Email:   moch8254@mylaurier.ca
__updated__ = "2025-11-01"
-------------------------------------------------------
"""
# Imports
import mysql.connector
import os

queries = "dental_clinic_dbms_queries_a4.sql"
schema = "dental_clinic_dbms_a4.sql"
# Configure these for your setup
host = "localhost"
user = "root"
pWord = "your_password"   # change for uploaded verions
name = "Local instance MySQL80"


def dbConnect():
    return mysql.connector.connect(
        host=host,
        user=user,
        password=pWord,
        database=name
    )


def runFile(filename, connection):
    print(f"\nRunning Dental Clinic DBMS.")
    cursor = connection.cursor()
    with open(filename, "r", encoding="utf-8") as f:
        sql_commands = f.read().split(";")
        for command in sql_commands:
            command = command.strip()
            if command:
                try:
                    cursor.execute(command)
                except mysql.connector.Error as err:
                    # Avoid stopping on CREATE/INSERT duplicate or constraint warnings
                    print(f"SQL Warning: {err}")

    connection.commit()
    cursor.close()
    print(f"Finished running Dental Clinic DBMS\n")


def runQuery(connection, query):
    # run a query and get result(s)
    cursor = connection.cursor()
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    rows = cursor.fetchall()

    print("\n--- Query Results ---")
    print(" | ".join(columns))
    print("-" * 100)
    for row in rows:
        print(" | ".join(str(x) if x is not None else "" for x in row))
    print(f"\n{len(rows)} rows returned.\n")

    cursor.close()


def displayQueryMenu():
    print("\n=== Advanced Queries Menu ===")
    print("1. Total revenue per dentist")
    print("2. Total billed amount per insured patient")
    print("3. Treatment cost statistics (avg/min/max)")
    print("4. Patients with multiple visits to same dentist")
    print("5. Assistants earning above average")
    print("6. List all patients (with/without appointments)")
    print("7. Assistants in expensive treatments")
    print("8. Dentist performance view")
    print("9. High-spending patients view")
    print("0. Back")


def displayMenu():
    print("\n=== Dental Clinic Database Menu ===")
    print("1. View all dentists")
    print("2. View all patients")
    print("3. View all appointments")
    print("4. Run advanced queries (A4)")
    print("5. Exit")


def show_all_dentists(connection):
    runQuery(connection, "SELECT Dentist_ID, Dentist_Name, Dentist_Specality, Dentist_Phone FROM dentist;")


def show_all_patients(connection):
    runQuery(
        connection, "SELECT Patient_ID, Patient_Name, Patient_Sex, Patient_Address FROM patient;")


def show_all_appointments(connection):
    runQuery(connection, """
        SELECT a.Appointment_ID, a.Appointment_Date, p.Patient_Name, d.Dentist_Name, a.Appointment_Type
        FROM appointment a
        JOIN patient p ON a.Appointment_Patient = p.Patient_ID
        JOIN dentist d ON a.Appointment_Dentist = d.Dentist_ID;
    """)


def runAdvancedQuery(choice, connection):
    queries = {
        "1": """SELECT d.Dentist_Name, SUM(b.Bill_Total) AS Total_Revenue, COUNT(b.Bill_ID) AS Total_Bills
                FROM billing b
                JOIN appointment a ON b.Appointment_Info = a.Appointment_ID
                JOIN dentist d ON a.Appointment_Dentist = d.Dentist_ID
                WHERE b.Bill_Status = 'Y'
                GROUP BY d.Dentist_ID
                ORDER BY Total_Revenue DESC;""",
        "2": """SELECT p.Patient_Name, i.Insurance_Name, SUM(b.Bill_Total) AS Total_Spent
                FROM billing b
                JOIN patient p ON b.Patient_ID = p.Patient_ID
                JOIN insurance i ON p.Patient_Insurance_ID = i.Insurance_ID
                GROUP BY p.Patient_ID, i.Insurance_Name
                HAVING Total_Spent > 0
                ORDER BY Total_Spent DESC;""",
        "3": """SELECT t.Treatment_Name, COUNT(tr.Record_ID) AS Num_Performed,
                       ROUND(AVG(t.Treatment_Cost), 2) AS Avg_Cost,
                       MIN(t.Treatment_Cost) AS Min_Cost,
                       MAX(t.Treatment_Cost) AS Max_Cost
                FROM treatment_records tr
                JOIN treatment t ON tr.Treatment_Info = t.Treatment_ID
                GROUP BY t.Treatment_Name
                ORDER BY Avg_Cost DESC;""",
        "4": """SELECT d.Dentist_Name, p.Patient_Name, COUNT(a.Appointment_ID) AS Visits
                FROM appointment a
                JOIN dentist d ON a.Appointment_Dentist = d.Dentist_ID
                JOIN patient p ON a.Appointment_Patient = p.Patient_ID
                GROUP BY d.Dentist_Name, p.Patient_Name
                HAVING Visits > 1;""",
        "5": """SELECT Assistant_Name, Assistant_Salary
                FROM dental_assistant
                WHERE Assistant_Salary > (SELECT AVG(Assistant_Salary) FROM dental_assistant)
                ORDER BY Assistant_Salary DESC;""",
        "6": """SELECT p.Patient_Name, 'Has Appointment' AS Status
                FROM patient p
                JOIN appointment a ON p.Patient_ID = a.Appointment_Patient
                UNION
                SELECT p.Patient_Name, 'No Appointment' AS Status
                FROM patient p
                WHERE p.Patient_ID NOT IN (SELECT Appointment_Patient FROM appointment)
                ORDER BY Patient_Name;""",
        "7": """SELECT DISTINCT da.Assistant_Name, t.Treatment_Name, t.Treatment_Cost
                FROM dental_assistant da
                JOIN appointment_assistant aa ON da.Assistant_ID = aa.Assistant_ID
                JOIN appointment a ON aa.Appointment_ID = a.Appointment_ID
                JOIN treatment_records tr ON a.Appointment_ID = tr.Appointment_Information
                JOIN treatment t ON tr.Treatment_Info = t.Treatment_ID
                WHERE t.Treatment_Cost > (SELECT AVG(Treatment_Cost) FROM treatment)
                ORDER BY t.Treatment_Cost DESC;""",
        "8": "SELECT * FROM dentist_performance;",
        "9": "SELECT * FROM v_high_spending_patients;"
    }
    if choice in queries:
        runQuery(connection, queries[choice])
    else:
        print("Invalid selection.")


def main():

    connection = dbConnect()
    runFile(schema, connection)
    runFile(queries, connection)
    connection.close()

    connection = dbConnect(name)

    # loop through options and stuff till user is done
    while True:
        displayMenu()
        choice = input("Choose an option: ")

        if choice == "1":
            show_all_dentists(connection)
        elif choice == "2":
            show_all_patients(connection)
        elif choice == "3":
            show_all_appointments(connection)
        elif choice == "4":
            while True:
                displayQueryMenu()
                sub_choice = input("Choose a query to run: ")
                if sub_choice == "0":
                    break
                runAdvancedQuery(sub_choice, connection)
        elif choice == "5":
            print("Exiting program.")
            break
        else:
            print("Invalid option. Try again.")

    connection.close()


if __name__ == "__main__":
    main()
