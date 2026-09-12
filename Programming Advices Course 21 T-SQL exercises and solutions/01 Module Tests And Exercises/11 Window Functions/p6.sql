-- Problem Scenario:
-- Implement pagination logic for an API endpoint displaying the vehicle catalog. 
-- Retrieve Page 3 of the results, assuming a page size of 10 items per page. Order the results by Year descending, then by Vehicle Display Name ascending.

-- Solution:
DECLARE @PageNumber INT = 3;
DECLARE @PageSize INT = 10;

SELECT 
    ID,
    Vehicle_Display_Name,
    Year
FROM VehicleDetails
ORDER BY Year DESC, Vehicle_Display_Name ASC
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;