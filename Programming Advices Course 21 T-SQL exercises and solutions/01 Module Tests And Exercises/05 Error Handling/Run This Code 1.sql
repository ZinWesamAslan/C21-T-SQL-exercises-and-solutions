BEGIN TRY
    SELECT 1 / 0;
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER()    AS [Error Number],
        ERROR_SEVERITY()  AS [Severity],
        ERROR_STATE()     AS [State],
        ERROR_PROCEDURE() AS [Procedure],
        ERROR_LINE()      AS [Line Number],
        ERROR_MESSAGE()   AS [Message];
END CATCH

