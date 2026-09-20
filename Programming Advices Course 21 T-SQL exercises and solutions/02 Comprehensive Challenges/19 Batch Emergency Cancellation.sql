/*
17. Batch Emergency Cancellation
Scenario: Occasionally, a batch must be cancelled entirely due to unforeseen circumstances before it finishes.
Question: Write a Stored Procedure `sp_CancelBatch` taking @BatchID and @UpdatedByUserID.
Requirements:
1. Validate batch exists and is NOT 'Completed' or already 'Cancelled'.
2. Change the batch Status to 'Cancelled'.
3. Change ALL related 'Enrolled' student statuses in this batch to 'Dropped'.
4. Return the total number of affected (dropped) students.
Ensure this entire process is executed as a single unit of work (transaction).
*/

CREATE PROCEDURE sp_CancelBatch
    @BatchID INT,
    @UpdatedByUserID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @BatchStatus NVARCHAR(20);
        DECLARE @AffectedStudents INT;

        -- Validate Batch
        SELECT @BatchStatus = Status FROM CourseBatches WHERE BatchID = @BatchID;

        IF (@BatchStatus IS NULL)
            THROW 50030, 'Batch does not exist.', 1;

        IF (@BatchStatus IN ('Completed', 'Cancelled'))
            THROW 50031, 'Cannot cancel a batch that is already Completed or Cancelled.', 1;

        -- Update Batch
        UPDATE CourseBatches
        SET Status = 'Cancelled', 
            UpdatedByUserID = @UpdatedByUserID, 
            UpdatedDate = GETDATE()
        WHERE BatchID = @BatchID;

        -- Update Enrollments
        UPDATE Enrollments
        SET Status = 'Dropped',
            UpdatedByUserID = @UpdatedByUserID,
            UpdatedDate = GETDATE()
        WHERE BatchID = @BatchID AND Status = 'Enrolled';

        SET @AffectedStudents = @@ROWCOUNT;

        SELECT @AffectedStudents AS DroppedStudentsCount;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO