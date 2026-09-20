/*
14. System Integration: Multi-object logic for Transcripts

Scenario: The administration needs to print a full academic transcript for a student,
showing only completed batches where the student received a final grade.

Question: 
Part A: Write a function `fn_GetStudentTranscript` returning a table of CourseTitle,
        BatchCode, FinalGrade, and GradeStatus (Pass >= 60, Fail < 60) for a given @StudentID.
Part B: Write a Stored Procedure `sp_PrintTranscript` that validates if the student exists and 
        is active, retrieves their FullName (with SecondName), and selects the data from your function.
*/

-- Part A: Function
CREATE FUNCTION fn_GetStudentTranscript (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        C.CourseTitle,
        CB.BatchCode,
        E.FinalGrade,
        CASE 
            WHEN E.FinalGrade >= 60 THEN 'Pass'
            ELSE 'Fail' 
        END AS GradeStatus
    FROM Enrollments E
    INNER JOIN CourseBatches CB ON E.BatchID = CB.BatchID
    INNER JOIN Courses C ON CB.CourseID = C.CourseID
    WHERE E.StudentID = @StudentID 
      AND E.FinalGrade IS NOT NULL
      AND CB.Status = 'Completed'
);
GO

-- Part B: Stored Procedure
CREATE PROCEDURE sp_PrintTranscript
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StudentName NVARCHAR(150);
    DECLARE @IsActive BIT;

    -- Validate Student
    SELECT 
        @StudentName = P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName,
        @IsActive = S.IsActive
    FROM Students S
    INNER JOIN People P ON S.StudentID = P.PersonID
    WHERE S.StudentID = @StudentID;

    IF (@StudentName IS NULL)
        THROW 50020, 'Student does not exist.', 1;

    IF (@IsActive = 0)
        THROW 50021, 'Cannot generate transcript for an inactive student.', 1;

    -- Output Student Info
    SELECT @StudentID AS StudentID, @StudentName AS StudentFullName, GETDATE() AS PrintDate;

    -- Output Transcript Records using the function
    SELECT * FROM fn_GetStudentTranscript(@StudentID)
    ORDER BY CourseTitle;
END;
GO