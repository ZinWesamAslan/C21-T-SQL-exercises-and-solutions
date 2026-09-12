-- Problem Scenario:
-- Rank all vehicles within their respective
-- Fuel Types based on their Year in descending order. 
-- Show both RANK() and DENSE_RANK() in the same query to observe how 
-- tie-breaking gap behavior differs when multiple vehicles share the same production year.

-- Solution:
SELECT 
    ft.FuelTypeName,
    vd.Vehicle_Display_Name,
    vd.Year,
    RANK() OVER (PARTITION BY vd.FuelTypeID ORDER BY vd.Year DESC) AS Rank_WithGaps,
    DENSE_RANK() OVER (PARTITION BY vd.FuelTypeID ORDER BY vd.Year DESC) AS DenseRank_NoGaps
FROM VehicleDetails vd
JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID order by vd.FuelTypeID;