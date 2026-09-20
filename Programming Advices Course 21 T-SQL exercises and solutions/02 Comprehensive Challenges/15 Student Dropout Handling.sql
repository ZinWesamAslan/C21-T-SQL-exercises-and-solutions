/*
13. Complex Process: Student Dropout Handling
Scenario: When a student decides to drop out of a batch,
multiple things must be validated and updated safely.

Question: Write a Stored Procedure `sp_DropStudentFromBatch` 
that takes @StudentID, @BatchID, and @UpdatedByUserID. 
Requirements:
1. Validate student and batch existence.
2. Ensure the student is currently 'Enrolled' in this batch
   (cannot drop if already Completed, Failed, or Dropped).
3. Update the enrollment status to 'Dropped' and set the UpdatedDate.
4. Return a summary dataset containing: Student FullName (with SecondName),
   BatchCode, Total Paid Amount so far, and a calculated 'RefundableAmount' 
   (Assume policy: Refundable is TotalPaid - 50% of Course Price. If negative, return 0).
*/

CREATE PROCEDURE sp_DropStudentFromBatch
    @StudentID INT,
    @BatchID INT,
    @UpdatedByUserID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @EnrollmentID INT;
        DECLARE @CurrentStatus NVARCHAR(20);
        DECLARE @CoursePrice DECIMAL(10,2);
        DECLARE @TotalPaid DECIMAL(10,2) = 0;
        DECLARE @Refundable DECIMAL(10,2) = 0;

        -- 1. Validate Enrollment Existence and Status
        SELECT 
            @EnrollmentID = E.EnrollmentID, 
            @CurrentStatus = E.Status,
            @CoursePrice = C.Price
        FROM Enrollments E
        INNER JOIN CourseBatches CB ON E.BatchID = CB.BatchID
        INNER JOIN Courses C ON CB.CourseID = C.CourseID
        WHERE E.StudentID = @StudentID AND E.BatchID = @BatchID;

        IF (@EnrollmentID IS NULL)
            THROW 50010, 'Enrollment record not found for this student and batch.', 1;
            
        IF (@CurrentStatus <> 'Enrolled')
            THROW 50011, 'Student can only be dropped if their current status is Enrolled.', 1;

        -- 2. Update Status
        UPDATE Enrollments
        SET Status = 'Dropped', 
            UpdatedByUserID = @UpdatedByUserID, 
            UpdatedDate = GETDATE()
        WHERE EnrollmentID = @EnrollmentID;

        -- 3. Calculate Financials
        SELECT @TotalPaid = ISNULL(SUM(AmountPaid), 0) 
        FROM Payments 
        WHERE EnrollmentID = @EnrollmentID;

        SET @Refundable = @TotalPaid - (@CoursePrice * 0.50);
        IF (@Refundable < 0) SET @Refundable = 0;

        -- 4. Return Summary
        SELECT 
            P.FirstName + ISNULL(' ' + P.SecondName, '') + ' ' + P.LastName AS FullName,
            CB.BatchCode,
            @TotalPaid AS TotalPaid,
            @Refundable AS RefundableAmount
        FROM People P
        INNER JOIN CourseBatches CB ON CB.BatchID = @BatchID
        WHERE P.PersonID = @StudentID;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO