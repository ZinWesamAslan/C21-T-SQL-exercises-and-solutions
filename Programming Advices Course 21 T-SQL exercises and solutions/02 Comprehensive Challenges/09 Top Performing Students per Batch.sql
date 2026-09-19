/*
7. Top Performing Students per Batch
Scenario: At the end of a course, certificates are awarded to top students.
We need a way to rank students based on their final grades within each batch.
Question: Create a View `vw_TopStudentsPerBatch`
to display StudentName (FullName including SecondName)
, BatchCode, FinalGrade, and StudentRank
where the student with the highest grade in a batch gets rank 1.
*/

CREATE VIEW vw_TopStudentsPerBatch
AS
SELECT 
    CB.BatchCode,
    P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS StudentName,
    E.FinalGrade,
    RANK() OVER (PARTITION BY E.BatchID ORDER BY E.FinalGrade DESC) AS StudentRank
FROM 
    Enrollments E
INNER JOIN 
    CourseBatches CB ON E.BatchID = CB.BatchID
INNER JOIN 
    People P ON E.StudentID = P.PersonID
WHERE 
    E.FinalGrade IS NOT NULL;
GO

select * from vw_TopStudentsPerBatch;