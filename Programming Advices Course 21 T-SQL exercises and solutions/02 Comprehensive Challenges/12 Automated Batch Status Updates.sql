/*
10. Automated Batch Status Updates
Scenario: Batch statuses ('Upcoming', 'Ongoing', 'Completed') 
should update automatically based on current date vs StartDate and EndDate.
Question: Create a Stored Procedure `sp_UpdateBatchStatuses` designed to run daily.
It should update 'Upcoming' batches to 'Ongoing' if StartDate <= Today, and 'Ongoing'
batches to 'Completed' if EndDate < Today. Return the count of modified records.
*/

CREATE PROCEDURE sp_UpdateBatchStatuses
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    -- Update to Ongoing for batches that started and have not ended
    UPDATE CourseBatches
    SET Status = 'Ongoing', UpdatedDate = GETDATE()
    WHERE Status = 'Upcoming' AND StartDate <= @Today AND EndDate >= @Today;

    -- Update to Completed for batches that have ended
    UPDATE CourseBatches
    SET Status = 'Completed', UpdatedDate = GETDATE()
    WHERE Status IN ('Upcoming', 'Ongoing') AND EndDate < @Today;
    
    -- Return number of updated batches
    SELECT @@ROWCOUNT AS BatchesUpdatedCount;
END;
GO