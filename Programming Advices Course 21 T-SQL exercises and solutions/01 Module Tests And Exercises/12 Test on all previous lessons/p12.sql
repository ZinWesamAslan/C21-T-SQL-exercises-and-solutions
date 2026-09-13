/*
Question:
Write a SQL query to achieve the following requirements:

Display the vehicle manufacturer name (Make) and the manufacturing year (Year).

Calculate the total number of vehicles produced by each manufacturer for each year individually.

Display the grand total of all vehicles produced by each manufacturer across all manufacturing years in a separate column.

Show the percentage of each year's vehicle production relative to the manufacturer's total production, rounded to two decimal places and appended with a % symbol.
*/

SELECT 
    m.Make,
    vd.Year,
    COUNT(*) AS TotalPerYear,
    SUM(COUNT(*)) OVER (PARTITION BY m.Make) AS TotalMake,
    CONCAT(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY m.Make), 2), '%') AS Percentage
FROM VehicleDetails vd
JOIN Makes m ON vd.MakeID = m.MakeID
GROUP BY 
    m.Make,
    vd.Year
ORDER BY 
    m.Make, 
    vd.Year;