-- Business Scenario:
-- Write a Stored Procedure 'sp_GetVehiclesPaged' that implements API server-side pagination.
-- Parameters: @PageNumber INT, @PageSize INT.
-- Return vehicles sorted by Year DESC and Vehicle_Display_Name ASC using OFFSET FETCH.
-- Include a safety validation using ISNULL / IIF so that if @PageNumber or @PageSize are <= 0 or NULL, 
-- they default to Page 1 and Page Size 10 respectively.

-- Solution:
CREATE PROCEDURE sp_GetVehiclesPaged
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate and apply default fallback values
    SET @PageNumber = IIF(ISNULL(@PageNumber, 0) <= 0, 1, @PageNumber);
    SET @PageSize   = IIF(ISNULL(@PageSize, 0) <= 0, 10, @PageSize);

    SELECT 
        ID,
        Vehicle_Display_Name,
        Year,
        NumDoors
    FROM VehicleDetails
    ORDER BY Year DESC, Vehicle_Display_Name ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO