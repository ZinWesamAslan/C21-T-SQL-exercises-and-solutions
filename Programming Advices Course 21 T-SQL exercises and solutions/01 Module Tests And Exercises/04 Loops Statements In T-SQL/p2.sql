-- Task: Write a WHILE loop that acts as a simple counter starting from 1 up to 10. 
-- Inside the loop, print the counter value, but use a conditional IF statement with a BREAK command 
-- to exit the loop entirely when the counter reaches 5.

DECLARE @LoopCounter INT = 1;

WHILE @LoopCounter <= 10
BEGIN
    PRINT 'Current Counter: ' + CAST(@LoopCounter AS VARCHAR(2));

    IF @LoopCounter = 5
    BEGIN
        PRINT 'Counter reached 5. Breaking the loop.';
        BREAK;
    END

    SET @LoopCounter = @LoopCounter + 1;
END