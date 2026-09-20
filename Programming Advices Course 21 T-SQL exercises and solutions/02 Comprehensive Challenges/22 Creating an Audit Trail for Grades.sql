/*
20. Creating an Audit Trail for Grades
Scenario: Academic records are sensitive. Any change to a student's `FinalGrade` 
must be logged for auditing purposes.

Question: 
Part A: Create a table named `GradeAuditLog` to store LogID, EnrollmentID, 
        OldGrade, NewGrade, and ChangeDate.
Part B: Write a database object on the `Enrollments` table that automatically 
        captures and inserts a record into `GradeAuditLog` whenever a `FinalGrade` 
		is updated (changed from one value to another, or from NULL to a value).
*/

-- Part A: Create Audit Table
CREATE TABLE GradeAuditLog (
    LogID INT IDENTITY(1,1) CONSTRAINT PK_GradeAudit PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    OldGrade DECIMAL(5,2) NULL,
    NewGrade DECIMAL(5,2) NULL,
    ChangeDate DATETIME NOT NULL CONSTRAINT DF_GradeAudit_Date DEFAULT GETDATE(),
    CONSTRAINT FK_GradeAudit_Enrollments FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID) ON DELETE CASCADE
);
GO

-- Part B: Trigger
CREATE TRIGGER trg_AuditGradeChanges
ON Enrollments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Only proceed if FinalGrade column was part of the UPDATE statement
    IF UPDATE(FinalGrade)
    BEGIN
        INSERT INTO GradeAuditLog (EnrollmentID, OldGrade, NewGrade)
        SELECT 
            i.EnrollmentID, 
            d.FinalGrade, 
            i.FinalGrade
        FROM inserted i
        INNER JOIN deleted d ON i.EnrollmentID = d.EnrollmentID
        -- Only log if the grade actually changed values (handling NULLs)
        WHERE ISNULL(i.FinalGrade, -1) <> ISNULL(d.FinalGrade, -1);
    END
END;
GO