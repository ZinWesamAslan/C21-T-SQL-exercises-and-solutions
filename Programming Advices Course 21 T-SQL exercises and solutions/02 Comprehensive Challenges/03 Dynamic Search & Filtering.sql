/*
1. Dynamic Search & Filtering
Scenario: In the application UI, there is a student search form where the user can enter a Name (First, Second, or Last), Email, or Active Status, or leave some fields empty.
Question: Write a Stored Procedure named `sp_SearchStudents` that accepts 3 optional parameters (@SearchText, @Email, @IsActive). 
If a parameter is NULL, it should be ignored in filtering. If a value is provided, filter the students using it.
*/

CREATE PROCEDURE sp_SearchStudents
    @SearchText NVARCHAR(50) = NULL,
    @Email NVARCHAR(100) = NULL,
    @IsActive BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        S.StudentID,
        P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS FullName,
        P.Email,
        P.Phone,
        S.RegistrationDate,
        S.IsActive
    FROM 
        Students S
    INNER JOIN 
        People P ON S.StudentID = P.PersonID
    WHERE 
        (@SearchText IS NULL OR P.FirstName LIKE '%' + @SearchText + '%' 
                            OR P.SecondName LIKE '%' + @SearchText + '%' 
                            OR P.LastName LIKE '%' + @SearchText + '%')
        AND 
        (@Email IS NULL OR P.Email LIKE '%' + @Email + '%')
        AND 
        (@IsActive IS NULL OR S.IsActive = @IsActive);
END;
GO