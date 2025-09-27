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
