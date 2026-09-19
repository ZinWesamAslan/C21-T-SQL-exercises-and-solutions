CREATE PROCEDURE sp_GetStudentsPaged_KeysetByID
    @PageSize INT = 10,
    @LastStudentID INT = NULL -- يترك NULL في الصفحة الأولى، وفي الصفحات التالية نرسل ID آخر طالب ظهر
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@PageSize)
        S.StudentID,
        P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS FullName,
        P.Phone,
        S.RegistrationDate
    FROM 
        Students S
    INNER JOIN 
        People P ON S.StudentID = P.PersonID
    WHERE 
        (@LastStudentID IS NULL OR S.StudentID < @LastStudentID)
    ORDER BY 
        S.StudentID DESC;
END;
GO