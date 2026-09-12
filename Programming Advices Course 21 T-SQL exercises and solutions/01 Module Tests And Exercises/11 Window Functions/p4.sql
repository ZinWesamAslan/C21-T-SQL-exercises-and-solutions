-- Problem Scenario:
-- For each vehicle Model, display its name,
-- production year, and use LAG to display the production year of the previous vehicle record under the same Model.
-- Include a calculated column showing the year difference between the current vehicle and its predecessor.

-- Solution:

SELECT 
    mm.ModelName,
    vd.Vehicle_Display_Name,
    vd.Year AS CurrentVehicleYear,
    LAG(vd.Year, 1) OVER (PARTITION BY vd.ModelID ORDER BY vd.Year ASC, vd.ID ASC) AS PreviousVehicleYear,
    vd.Year - LAG(vd.Year, 1) OVER (PARTITION BY vd.ModelID ORDER BY vd.Year ASC, vd.ID ASC) AS YearsGap
FROM VehicleDetails vd
JOIN MakeModels mm ON vd.ModelID = mm.ModelID;