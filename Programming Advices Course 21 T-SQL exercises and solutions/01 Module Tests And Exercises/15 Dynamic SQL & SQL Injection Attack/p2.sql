-- Business Scenario:
-- The database maintenance job needs a generic utility procedure 'sp_GetTableRecordCount' 
-- that takes a table name (@TableName VARCHAR(100)) and safely counts total rows dynamically.
-- Validate that the table exists in sys.tables before constructing the query and use QUOTENAME 
-- to sanitize the object identifier against injection attacks.

-- Solution:
CREATE PROCEDURE sp_GetTableRecordCount
    @TableName VARCHAR(100),
    @TotalRows INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Validate object existence in database metadata
    IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = @TableName)
    BEGIN
        RAISERROR('Target table does not exist or access is restricted.', 16, 1);
        SET @TotalRows = 0;
        RETURN;
    END

    -- 2. Construct dynamic query using QUOTENAME for safe identifier wrapping
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @ParamDefinition NVARCHAR(200);

    SET @SQL = N'SELECT @RowCountOUT = COUNT(*) FROM ' + QUOTENAME(@TableName);
    SET @ParamDefinition = N'@RowCountOUT INT OUTPUT';

    -- 3. Execute safely with OUTPUT parameter mapping
    EXEC sp_executesql 
        @stmt = @SQL, 
        @params = @ParamDefinition, 
        @RowCountOUT = @TotalRows OUTPUT;
END;
GO

-- How to call and test it safely:
DECLARE @Count INT;
EXEC sp_GetTableRecordCount @TableName = 'VehicleDetails', @TotalRows = @Count OUTPUT;
SELECT @Count AS TotalVehicleRecords;