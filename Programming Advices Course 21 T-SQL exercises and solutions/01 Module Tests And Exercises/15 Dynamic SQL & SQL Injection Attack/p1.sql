-- Business Scenario:
-- The search API allows clients to filter vehicles dynamically by optional parameters (@MakeID, @Year, @FuelTypeID) 
-- and dynamically set the sort column (@SortColumn) and sort order (@SortDirection: 'ASC' or 'DESC').
-- Write a safe Stored Procedure named 'sp_SearchVehiclesDynamic' using Dynamic SQL with sp_executesql and QUOTENAME 
-- to protect against SQL Injection while maintaining performance via query plan reuse.

-- Solution:
CREATE PROCEDURE sp_SearchVehiclesDynamic
    @MakeID INT = NULL,
    @Year INT = NULL,
    @FuelTypeID INT = NULL,
    @SortColumn VARCHAR(50) = 'Year',
    @SortDirection VARCHAR(4) = 'DESC'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @ParamDefinition NVARCHAR(500);

    -- Base Query
    SET @SQL = N'SELECT vd.ID, vd.Vehicle_Display_Name, vd.Year, m.Make, ft.FuelTypeName
                FROM VehicleDetails vd
                JOIN Makes m ON vd.MakeID = m.MakeID
                LEFT JOIN FuelTypes ft ON vd.FuelTypeID = ft.FuelTypeID
                WHERE 1=1 ';

    -- Dynamic WHERE Clause filtering
    IF @MakeID IS NOT NULL
        SET @SQL = @SQL + N' AND vd.MakeID = @MakeID';

    IF @Year IS NOT NULL
        SET @SQL = @SQL + N' AND vd.Year = @Year';

    IF @FuelTypeID IS NOT NULL
        SET @SQL = @SQL + N' AND vd.FuelTypeID = @FuelTypeID';

    -- Whitelist validation for dynamic ORDER BY to prevent SQL Injection
    IF @SortColumn NOT IN ('Year', 'Vehicle_Display_Name', 'Make')
        SET @SortColumn = 'Year';

    IF UPPER(@SortDirection) NOT IN ('ASC', 'DESC')
        SET @SortDirection = 'DESC';

    SET @SQL = @SQL + N' ORDER BY ' + QUOTENAME(@SortColumn) + N' ' + @SortDirection;

    -- Define parameters for safe execution
    SET @ParamDefinition = N'@MakeID INT, @Year INT, @FuelTypeID INT';

    -- Safe execution using sp_executesql
    EXEC sp_executesql 
        @stmt = @SQL, 
        @params = @ParamDefinition, 
        @MakeID = @MakeID, 
        @Year = @Year, 
        @FuelTypeID = @FuelTypeID;
END;
GO

-- How to call and test it safely:
EXEC sp_SearchVehiclesDynamic @MakeID = 3, @Year = 2020, @SortColumn = 'Vehicle_Display_Name', @SortDirection = 'ASC';