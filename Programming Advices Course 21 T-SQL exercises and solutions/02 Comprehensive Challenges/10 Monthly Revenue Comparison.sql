/*
8. Monthly Revenue Comparison
Scenario: Management needs an executive dashboard comparing monthly
institute revenue against the previous month to analyze growth trends.
Question: Create a View `vw_MonthlyRevenueGrowth` to show PaymentYear, 
PaymentMonth, CurrentMonthRevenue, PreviousMonthRevenue, and RevenueDifference.
*/





CREATE VIEW vw_MonthlyRevenueGrowth
AS
WITH MonthlyRevenue AS (
    SELECT 
        YEAR(PaymentDate) AS PaymentYear,
        MONTH(PaymentDate) AS PaymentMonth,
        SUM(AmountPaid) AS TotalRevenue
    FROM 
        Payments
    GROUP BY 
        YEAR(PaymentDate), MONTH(PaymentDate)
)
SELECT 
    PaymentYear,
    PaymentMonth,
    TotalRevenue AS CurrentMonthRevenue,
    LAG(TotalRevenue, 1, 0) OVER (ORDER BY PaymentYear, PaymentMonth) AS PreviousMonthRevenue,
    TotalRevenue - LAG(TotalRevenue, 1, 0) OVER (ORDER BY PaymentYear, PaymentMonth) AS RevenueDifference
FROM 
    MonthlyRevenue;
GO