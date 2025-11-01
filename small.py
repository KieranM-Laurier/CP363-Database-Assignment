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


def display_menu():
    print("\n=== Dental Clinic Advanced Queries Menu ===")
    print("1. Total revenue per dentist (completed appointments)")
    print("2. Total billed amount per insured patient")
    print("3. Treatment cost statistics (avg/min/max)")
    print("4. Patients treated multiple times by same dentist")
    print("5. Assistants earning above average salary")
    print("6. List all patients with/without appointments")
    print("7. Assistants involved in expensive treatments")
    print("8. Dentist performance view")
    print("9. High-spending patients view")
    print("0. Exit")


def run_query(conn, query):
    cursor = conn.cursor()
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    rows = cursor.fetchall()

    print("\n--- Query Results ---")
    print(" | ".join(columns))
    print("-" * 80)
    for row in rows:
        print(" | ".join(str(x) if x is not None else "" for x in row))
    print(f"\n{len(rows)} rows returned.\n")

    cursor.close()


def main():
    connect = dbConnect()

    while True:
        display_menu()
        choice = input("Choose an option: ")

        if choice == "1":
            run_query(connect, """
                SELECT d.Dentist_Name, SUM(b.Bill_Total) AS Total_Revenue, COUNT(b.Bill_ID) AS Total_Bills
                FROM billing b
                JOIN appointment a ON b.Appointment_Info = a.Appointment_ID
                JOIN dentist d ON a.Appointment_Dentist = d.Dentist_ID
                WHERE b.Bill_Status = 'Y'
                GROUP BY d.Dentist_ID
                ORDER BY Total_Revenue DESC;
            """)
        elif choice == "2":
            run_query(connect, """
                SELECT p.Patient_Name, i.Insurance_Name, SUM(b.Bill_Total) AS Total_Spent
                FROM billing b
                JOIN patient p ON b.Patient_ID = p.Patient_ID
                JOIN insurance i ON p.Patient_Insurance_ID = i.Insurance_ID
                GROUP BY p.Patient_ID, i.Insurance_Name
                HAVING Total_Spent > 0
                ORDER BY Total_Spent DESC;
            """)
        elif choice == "3":
            run_query(connect, """
                SELECT t.Treatment_Name, COUNT(tr.Record_ID) AS Num_Performed,
                       ROUND(AVG(t.Treatment_Cost), 2) AS Avg_Cost,
                       MIN(t.Treatment_Cost) AS Min_Cost,
                       MAX(t.Treatment_Cost) AS Max_Cost
                FROM treatment_records tr
                JOIN treatment t ON tr.Treatment_Info = t.Treatment_ID
                GROUP BY t.Treatment_Name
                ORDER BY Avg_Cost DESC;
            """)
        elif choice == "4":
            run_query(connect, """
                SELECT d.Dentist_Name, p.Patient_Name, COUNT(a.Appointment_ID) AS Visits
                FROM appointment a
                JOIN dentist d ON a.Appointment_Dentist = d.Dentist_ID
                JOIN patient p ON a.Appointment_Patient = p.Patient_ID
                GROUP BY d.Dentist_Name, p.Patient_Name
                HAVING Visits > 1;
            """)
        elif choice == "5":
            run_query(connect, """
                SELECT Assistant_Name, Assistant_Salary
                FROM dental_assistant
                WHERE Assistant_Salary > (SELECT AVG(Assistant_Salary) FROM dental_assistant)
                ORDER BY Assistant_Salary DESC;
            """)
        elif choice == "6":
            run_query(connect, """
                SELECT p.Patient_Name, 'Has Appointment' AS Status
                FROM patient p
                JOIN appointment a ON p.Patient_ID = a.Appointment_Patient
                UNION
                SELECT p.Patient_Name, 'No Appointment' AS Status
                FROM patient p
                WHERE p.Patient_ID NOT IN (SELECT Appointment_Patient FROM appointment)
                ORDER BY Patient_Name;
            """)
        elif choice == "7":
            run_query(connect, """
                SELECT DISTINCT da.Assistant_Name, t.Treatment_Name, t.Treatment_Cost
                FROM dental_assistant da
                JOIN appointment_assistant aa ON da.Assistant_ID = aa.Assistant_ID
                JOIN appointment a ON aa.Appointment_ID = a.Appointment_ID
                JOIN treatment_records tr ON a.Appointment_ID = tr.Appointment_Information
                JOIN treatment t ON tr.Treatment_Info = t.Treatment_ID
                WHERE t.Treatment_Cost > (SELECT AVG(Treatment_Cost) FROM treatment)
                ORDER BY t.Treatment_Cost DESC;
            """)
        elif choice == "8":
            run_query(connect, "SELECT * FROM dentist_performance;")
        elif choice == "9":
            run_query(connect, "SELECT * FROM v_high_spending_patients;")
        elif choice == "0":
            print("Exiting now.")
            break
        else:
            print("Please select a valid option.")

    connect.close()


if __name__ == "__main__":
    main()
