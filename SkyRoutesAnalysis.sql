USE SkyRoutes;

-- =========================================
-- 1. Top 10 Most Frequent Routes
-- =========================================

SELECT 
    RouteCode,
    COUNT(*) AS TotalFlights
FROM AirlineRoutes
GROUP BY RouteCode
ORDER BY TotalFlights DESC
LIMIT 10;

-- =========================================
-- 2. Average Revenue, Cost, and Profit Per Route
-- =========================================

SELECT 
    RouteCode,
    ROUND(AVG(Revenue), 2) AS AvgRevenue,
    ROUND(AVG(OperationalCost), 2) AS AvgOperationalCost,
    ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit
FROM AirlineRoutes
GROUP BY RouteCode
ORDER BY AvgProfit DESC;

-- =========================================
-- 3. Underperforming Routes with Negative Profit
-- =========================================

SELECT 
    RouteCode,
    ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit
FROM AirlineRoutes
GROUP BY RouteCode
HAVING AvgProfit < 0
ORDER BY AvgProfit ASC;

-- =========================================
-- 4. Seat Occupancy Percentage Per Route
-- =========================================

SELECT 
    RouteCode,
    ROUND(
        (SUM(SeatsSold) * 100.0) / SUM(SeatsAvailable),
        2
    ) AS OccupancyRate
FROM AirlineRoutes
GROUP BY RouteCode
ORDER BY OccupancyRate DESC;

-- =========================================
-- 5. Monthly Trend of Profit Per Route
-- =========================================

SELECT 
    RouteCode,
    MONTH(FlightDate) AS MonthNumber,
    ROUND(SUM(Revenue - OperationalCost), 2) AS MonthlyProfit
FROM AirlineRoutes
GROUP BY RouteCode, MONTH(FlightDate)
ORDER BY RouteCode, MonthNumber;

-- =========================================
-- 6. Domestic vs International Profitability
-- =========================================

SELECT 
    CASE
        WHEN LEFT(RouteCode, 3) = RIGHT(RouteCode, 3)
        THEN 'Domestic'
        ELSE 'International'
    END AS RouteType,

    ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit

FROM AirlineRoutes
GROUP BY RouteType;

-- =========================================
-- 7. Rank Routes Based on Revenue Per Minute
-- =========================================

SELECT 
    RouteCode,

    ROUND(
        SUM(Revenue) / SUM(FlightDurationMins),
        2
    ) AS RevenuePerMinute

FROM AirlineRoutes
GROUP BY RouteCode
ORDER BY RevenuePerMinute DESC;