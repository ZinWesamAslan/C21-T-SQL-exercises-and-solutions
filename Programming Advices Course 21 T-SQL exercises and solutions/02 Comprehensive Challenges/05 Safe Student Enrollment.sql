/*
3. Safe Student Enrollment (Comprehensive Validation)
Scenario: When enrolling a student into a batch, the system must perform full validation: verify student existence and active status, batch existence and valid registration status ('Upcoming' or 'Ongoing'), capacity limits, and prevent duplicate enrollments.
Question: Write a Stored Procedure `sp_EnrollStudent` to enroll a student in a batch with complete data integrity and error handling.
*/

CREATE PROCEDURE sp_EnrollStudent
    @StudentID INT,
    @BatchID INT,
    @CreatedByUserID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @CurrentEnrolled INT;
        DECLARE @MaxStudents INT;
        DECLARE @BatchStatus NVARCHAR(20);
        DECLARE @IsStudentActive BIT;

        -- 1. Validate Student Existence and Active Status
        SELECT @IsStudentActive = IsActive 
        FROM Students 
        WHERE StudentID = @StudentID;

        IF (@IsStudentActive IS NULL)
        BEGIN
            THROW 50001, 'Student record does not exist.', 1;
        END

        IF (@IsStudentActive = 0)
        BEGIN
            THROW 50002, 'Cannot enroll an inactive student.', 1;
        END

        -- 2. Validate Batch Existence and Status
        SELECT @MaxStudents = MaxStudents, @BatchStatus = Status 
        FROM CourseBatches 
        WHERE BatchID = @BatchID;

        IF (@BatchStatus IS NULL)
        BEGIN
            THROW 50003, 'Course batch does not exist.', 1;
        END

        IF (@BatchStatus IN ('Completed', 'Cancelled'))
        BEGIN
            THROW 50004, 'Cannot enroll in a completed or cancelled batch.', 1;
        END

        -- 3. Validate Batch Capacity
        SELECT @CurrentEnrolled = COUNT(*) 
        FROM Enrollments 
        WHERE BatchID = @BatchID AND Status <> 'Dropped';

        IF (@CurrentEnrolled >= @MaxStudents)
        BEGIN
            THROW 50005, 'Cannot enroll student. The batch has reached its maximum capacity.', 1;
        END

        -- 4. Validate Duplicate Enrollment
        IF EXISTS (SELECT 1 FROM Enrollments WHERE StudentID = @StudentID AND BatchID = @BatchID)
        BEGIN
            THROW 50006, 'Student is already enrolled in this batch.', 1;
        END

        -- Execute Enrollment Insert
        INSERT INTO Enrollments (StudentID, BatchID, EnrollmentDate, Status, CreatedByUserID)
        VALUES (@StudentID, @BatchID, GETDATE(), 'Enrolled', @CreatedByUserID);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        -- Re-throw exception to application layer
        THROW;
    END CATCH
END;
GO