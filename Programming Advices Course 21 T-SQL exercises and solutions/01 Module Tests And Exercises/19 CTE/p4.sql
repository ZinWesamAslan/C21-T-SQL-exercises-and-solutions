-- Business Scenario:
-- Identify duplicate vehicle records matching 'MakeID' and 'Vehicle_Display_Name' using ROW_NUMBER().
-- Keep the first record (RowSeq = 1) and update the Engine string for duplicates using a CTE.

WITH VehicleDuplicatesCTE AS (
    SELECT 
        ID,
        Vehicle_Display_Name,
        Engine,
        ROW_NUMBER() OVER (
            PARTITION BY MakeID, Vehicle_Display_Name 
            ORDER BY ID ASC
        ) AS RowSeq
    FROM VehicleDetails
)
UPDATE VehicleDuplicatesCTE
SET Engine = 'DUPLICATE_ENTRY'
WHERE RowSeq > 1;