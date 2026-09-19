CREATE PROCEDURE sp_GetStudentsPaged_Deferred
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    WITH PagedIDs AS (
        SELECT StudentID
        FROM Students
        ORDER BY RegistrationDate DESC, StudentID DESC
        OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY
    )
    SELECT 
        S.StudentID,
        P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS FullName,
        P.Phone,
        S.RegistrationDate
    FROM 
        PagedIDs Paged
    INNER JOIN 
        Students S ON Paged.StudentID = S.StudentID
    INNER JOIN 
        People P ON S.StudentID = P.PersonID
    ORDER BY 
        S.RegistrationDate DESC, S.StudentID DESC;
END;
GO