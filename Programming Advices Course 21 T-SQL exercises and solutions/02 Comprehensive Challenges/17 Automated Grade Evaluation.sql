/*
15. Automated Grade Evaluation 
Scenario: Instructors update the `FinalGrade` for their students at the end of a batch.
The enrollment status needs to change automatically based on the grade to avoid human error.

Question: Write a database object on the `Enrollments` table.
When `FinalGrade` is updated and is not NULL, 
automatically set the `Status` to 'Completed' if FinalGrade >= 60, 
or 'Failed' if FinalGrade < 60. Make sure to only affect rows where the grade actually changed.
*/

CREATE TRIGGER trg_AutoUpdateEnrollmentStatus
ON Enrollments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if FinalGrade was updated
    IF UPDATE(FinalGrade)
    BEGIN
        UPDATE E
        SET E.Status = CASE 
                          WHEN i.FinalGrade >= 60 THEN 'Completed'
                          ELSE 'Failed'
                       END,
            E.UpdatedDate = GETDATE()
        FROM Enrollments E
        INNER JOIN inserted i ON E.EnrollmentID = i.EnrollmentID
        INNER JOIN deleted d ON E.EnrollmentID = d.EnrollmentID
        -- Ensure the grade actually changed and is not null
        WHERE i.FinalGrade IS NOT NULL 
          AND (d.FinalGrade IS NULL OR i.FinalGrade <> d.FinalGrade);
    END
END;
GO