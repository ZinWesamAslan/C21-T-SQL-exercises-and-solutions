-- Business Scenario:
-- For every vehicle under 'AC' (or MakeID = 2), list each vehicle's Display Name and Year.
-- Add a column showing the previous vehicle's year using LAG() and the next vehicle's year using LEAD() 
-- ordered by production Year ascending.

-- Solution:
SELECT 
    m.Make,
    vd.Vehicle_Display_Name,
    vd.Year AS CurrentYear,
    LAG(vd.Year, 1) OVER (PARTITION BY vd.MakeID ORDER BY vd.Year ASC, vd.ID ASC) AS PrevModelYear,
    LEAD(vd.Year, 1) OVER (PARTITION BY vd.MakeID ORDER BY vd.Year ASC, vd.ID ASC) AS NextModelYear
FROM VehicleDetails vd
JOIN Makes m ON vd.MakeID = m.MakeID
WHERE vd.MakeID = 2;