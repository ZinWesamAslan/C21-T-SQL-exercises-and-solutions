-- Business Scenario:
-- During data integration, duplicate vehicle records might accidentally exist per MakeID with the same Vehicle_Display_Name and Year.
-- Write a script that uses a Temporary Table (#UniqueVehicles) and ROW_NUMBER() to identify and isolate only 
-- the first occurrence of each vehicle (partitioned by MakeID and Vehicle_Display_Name, ordered by ID), then select the clean dataset.

-- Solution:
WITH RankedVehicles AS (
    SELECT 
        ID,
        MakeID,
        ModelID,
        SubModelID,
        Vehicle_Display_Name,
        Year,
        ROW_NUMBER() OVER (
            PARTITION BY MakeID, Vehicle_Display_Name 
            ORDER BY ID ASC
        ) AS RowSeq
    FROM VehicleDetails
)
SELECT ID, MakeID, ModelID, SubModelID, Vehicle_Display_Name, Year
INTO #UniqueVehicles
FROM RankedVehicles
WHERE RowSeq = 1;

SELECT * FROM #UniqueVehicles;