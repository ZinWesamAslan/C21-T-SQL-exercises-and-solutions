-- Vulnerable Authentication Procedure (Do NOT use in production):
CREATE PROCEDURE sp_UnsafeUserLogin
    @Username VARCHAR(50),
    @Password VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL VARCHAR(MAX);

    -- VULNERABLE: Direct concatenation of credentials allows logic manipulation
    SET @SQL = 'SELECT UserID, Username, Role 
                FROM Users 
                WHERE Username = ''' + @Username + ''' AND Password = ''' + @Password + '''';

    EXEC(@SQL);
END;
GO

-- Attacker execution call:
EXEC sp_UnsafeUserLogin 
    @Username = 'admin'' OR ''1''=''1', 
    @Password = 'any_password';



