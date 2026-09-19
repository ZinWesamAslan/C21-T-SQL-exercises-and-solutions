/*
2. Server-Side Data Pagination
Scenario: Loading thousands of student records at once in the 
app UI causes performance issues. Data must be retrieved page by page.

Question: Write a Stored Procedure named `sp_GetStudentsPaged`
that accepts @PageNumber and @PageSize,
returning only the requested page of students sorted by RegistrationDate in descending order.
Include FullName (FirstName + SecondName + LastName).
*/














CREATE PROCEDURE sp_GetStudentsPaged
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        S.StudentID,
        P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS FullName,
        P.Phone,
        S.RegistrationDate
    FROM 
        Students S
    INNER JOIN 
        People P ON S.StudentID = P.PersonID
    ORDER BY 
        S.RegistrationDate DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO