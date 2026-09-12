-- Problem Scenario:
-- Retrieve vehicle entries per Make showing the current vehicle display name and year, 
-- alongside the next vehicle display name and year using LEAD().
-- Filter out rows where there is no subsequent vehicle (i.e., where LEAD produces NULL).

-- Solution:
WITH VehicleLeadStaging AS (
    SELECT 
        m.Make,
        vd.Vehicle_Display_Name AS CurrentVehicle,
        vd.Year AS CurrentYear,
        LEAD(vd.Vehicle_Display_Name, 1) OVER (PARTITION BY vd.MakeID ORDER BY vd.Year ASC, vd.ID ASC) AS NextVehicle,
        LEAD(vd.Year, 1) OVER (PARTITION BY vd.MakeID ORDER BY vd.Year ASC, vd.ID ASC) AS NextYear
    FROM VehicleDetails vd
    JOIN Makes m ON vd.MakeID = m.MakeID
)
SELECT Make, CurrentVehicle, CurrentYear, NextVehicle, NextYear
FROM VehicleLeadStaging
WHERE NextVehicle IS NOT NULL;