/*
6. Classroom Schedule Conflict Checker (Comprehensive Date & Time Overlap)
Scenario: When assigning a schedule to a batch, the system must check if the classroom is available. 
A conflict ONLY exists if:
1. The existing batch is Active/Upcoming ('Upcoming', 'Ongoing').
2. The DATE RANGES of the two batches overlap (StartDate <= Existing EndDate AND EndDate >= Existing StartDate).
3. The WEEKDAY and TIME SLOTS overlap.

Question: Write a scalar function `fn_CheckClassroomAvailability` that takes @ClassroomID, @BatchStartDate, @BatchEndDate, @DayOfWeek, @StartTime, and @EndTime. Return 1 if available, 0 if occupied.
*/

CREATE FUNCTION fn_CheckClassroomAvailability
(
    @ClassroomID INT,
    @BatchStartDate DATE,
    @BatchEndDate DATE,
    @DayOfWeek TINYINT,
    @StartTime TIME,
    @EndTime TIME
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsAvailable BIT = 1;

    IF EXISTS (
        SELECT 1 
        FROM BatchSchedules BS
        INNER JOIN CourseBatches CB ON BS.BatchID = CB.BatchID
        WHERE CB.ClassroomID = @ClassroomID
          -- 1. Ignore finished/canceled batches
          AND CB.Status IN ('Upcoming', 'Ongoing')
          
          -- 2. Date Range Overlap Check (الشعبة القادمة تتداخل بتواريخها مع الشعبة الحالية)
          AND (CB.StartDate <= @BatchEndDate AND CB.EndDate >= @BatchStartDate)
          
          -- 3. Day of Week Check
          AND BS.DayOfWeek = @DayOfWeek
          
          -- 4. Time Overlap Check
          AND (BS.StartTime < @EndTime AND BS.EndTime > @StartTime)
    )
    BEGIN
        SET @IsAvailable = 0; -- يوجد تضارب حقيقي في التاريخ والوقت والقاعة
    END

    RETURN @IsAvailable;
END;
GO