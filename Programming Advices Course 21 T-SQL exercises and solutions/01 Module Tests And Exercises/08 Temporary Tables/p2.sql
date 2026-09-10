-- Business Problem:
-- Your company's application needs to fetch a report showing vehicle details along with their fuel types.
-- However, there is a data quality issue: some vehicles in the database have a NULL (missing) fuel type.
-- Your backend task requires you to:
-- 1. Extract the vehicle details and fuel types into a separate working workspace (staging area).
-- 2. Fix the data quality issue inside this workspace by updating any NULL fuel types to read 'Standard Fuel instead.
-- 3. Finally, output the clean, fully updated dataset so the application can consume it.
-- 
-- (Hint: Think about how you would hold data temporarily, modify it midway, and then select the final result).

CREATE TABLE #StagingVehicles (
    VehicleID INT,
    VehicleName VARCHAR(200),
    ModelYear INT,
    FuelType VARCHAR(50)
);

INSERT INTO #StagingVehicles (VehicleID, VehicleName, ModelYear, FuelType)
SELECT vd.ID, vd.Vehicle_Display_Name, vd.Year, ft.FuelTypeName
FROM VehicleDetails vd
JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID;

-- Intermediate data modification step
UPDATE #StagingVehicles
SET FuelType = 'Standard Fuel'
WHERE FuelType IS NULL;

-- Step 3: Return the final processed dataset to the client application
SELECT * FROM #StagingVehicles;
