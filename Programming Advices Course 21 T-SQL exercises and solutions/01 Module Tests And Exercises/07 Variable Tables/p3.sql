-- Task: Declare a table variable named @TargetModels with a single column ModelID (INT).
-- Insert three specific ModelIDs of your choice into this table variable (e.g., 1, 5, 10).
-- Write a query that INNER JOINs the VehicleDetails table with this table variable (@TargetModels) 
-- to display the vehicle name, year, and model ID for the vehicles matching those specific models.

DECLARE @TargetModels TABLE (
    ModelID INT
);

INSERT INTO @TargetModels (ModelID)
VALUES (1), (5), (10);

SELECT 
    vd.Vehicle_Display_Name,
    vd.Year,
    vd.ModelID
FROM VehicleDetails vd
JOIN @TargetModels tm ON vd.ModelID = tm.ModelID;