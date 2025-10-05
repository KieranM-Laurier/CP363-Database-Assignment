## Project Version History

### v0.001 — Changes
- Changed `Medicine_Price` data type from `INT` to `DECIMAL`.
- Updated all `VARCHAR(50)` definitions for consistency.
- Increased size of relevant text fields (e.g., notes, descriptions) from `VARCHAR(50)` to `VARCHAR(1000)`.
- Changed `Patient_Sex` from `VARCHAR()` to `CHAR(1)` and added a `CHECK` constraint to ensure one value is picked.
- Standardized all data type definitions to **uppercase** for consistency with examples.
- Modified `Patient_Phone`:  
  - Previously `NOT NULL` → now `DEFAULT NULL` (since a patient may come in without providing a phone number).
- Modified `Assistant_Shift`:  
  - Removed `NOT NULL` constraint (assistants may not always be scheduled).
- Removed unnecessary backticks (\`\`) around variable names.

---

### a2_v0.002 — Data Insertion Updates and Schema Fixes
**Files Modified:** `dental_clinic_dbms_a2.sql`
- Updated all phone number columns (`Dentist_Phone`, `Patient_Phone`, `Assistant_Phone`) to `VARCHAR(50)` to allow flexible formats (e.g., "+1-519-555-1234").
- Populated all tables with **10 sample records** each to enable testing of queries.
- Fixed minor syntax issues in `FOREIGN KEY` constraints.
- Verified all `INSERT` statements to ensure referential integrity across tables.

---

### a3_v0.001 — Query Design and Analytics Development
**Files Modified:** `dental_clinic_dbms_queries_a3.sql`
- Added **6 meaningful SQL queries** covering various operations:
  - Selection with filtering and date comparisons.
  - Aggregation and grouping (`SUM`, `COUNT`, `MAX`).
  - Multiple table joins.
  - Subquery usage to find highest treatment costs.
- Each query is **clearly titled and commented** for readability and grading clarity.
- Removed redundant or erroneous query (`Appointmnet_Date` typo) from earlier draft.
- Ensured all queries are executable without syntax errors and compatible with current database schema.
- Organized and formatted SQL file for professional presentation.

---

### a3_v0.002 — Views, Subqueries, and Window Functions Added
**Files Modified:** `dental_clinic_dbms_queries_a3.sql`
- Added correlated and nested subqueries for advanced data analysis.
- Implemented three views using DISTINCT, GROUP BY, ORDER BY, and calculated fields.
- Introduced window functions (`RANK`, `ROW_NUMBER`) for ranking analysis.
- Enhanced SQL file with consistent formatting and descriptive titles.

