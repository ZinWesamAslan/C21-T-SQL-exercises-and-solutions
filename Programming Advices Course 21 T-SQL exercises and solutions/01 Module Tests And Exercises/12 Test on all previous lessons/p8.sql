-- Business Scenario:
-- Write a query that assigns a dense rank (DENSE_RANK) to vehicles within 
-- each BodyType based on the number of doors (NumDoors DESC).
-- Also include the total count of vehicles within that same BodyType in 
-- an adjacent window column without using GROUP BY.

-- Solution:
SELECT 
    b.BodyName,
    vd.Vehicle_Display_Name,
    vd.NumDoors,
    DENSE_RANK() OVER (PARTITION BY vd.BodyID ORDER BY vd.NumDoors DESC) AS DoorRank,
    COUNT(*) OVER (PARTITION BY vd.BodyID) AS TotalVehiclesInBodyType
FROM VehicleDetails vd
JOIN Bodies b ON vd.BodyID = b.BodyID order by vd.BodyID , NumDoors desc;