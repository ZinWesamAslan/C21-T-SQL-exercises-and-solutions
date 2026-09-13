-- Business Scenario:
-- Generate a report showing all Makes and their vehicle counts, but with two specific formatting rules:
-- 1. Format the Make name to UPPERCASE and TRIM any accidental spaces.
-- 2. Include a column showing the average vehicle age in years calculated dynamically from the current date's year 
--    using DATEDIFF and YEAR(GETDATE()).

-- Solution:
SELECT 
    UPPER(TRIM(m.Make)) AS CleanMakeName,
    COUNT(vd.ID) AS TotalVehicles,
    AVG(DATEDIFF(YEAR, DATETIMEFROMPARTS(vd.Year, 1, 1, 0, 0, 0, 0), GETDATE())) AS AvgVehicleAgeYears
FROM Makes m
JOIN VehicleDetails vd ON m.MakeID = vd.MakeID 
GROUP BY UPPER(TRIM(m.Make)) ;