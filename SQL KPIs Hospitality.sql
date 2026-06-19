use Hospitality;
show tables;
SELECT * FROM dim_date;
SELECT * FROM dim_hotels;
SELECT * FROM dim_rooms ;
SELECT * FROM fact_bookings;
SELECT * FROM fact_aggregated_bookings ;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1.Total Revenue
SELECT SUM(revenue_realized) AS Total_Revenue FROM fact_bookings ;

-- 2.Total Bookings
SELECT count(*) AS Successful_Bookings FROM fact_bookings;

-- 3.Total Capacity
SELECT SUM(Capacity) AS Total_Capacity FROM fact_aggregated_bookings;

-- 4.Occupancy%
SELECT round((sum(successful_bookings)/sum(capacity))*100,2)  AS Occupancy FROM fact_aggregated_bookings;

-- 5.Average Ratings
SELECT round(AVG(ratings_given),2) AS Average_ratings FROM Fact_Bookings Where ratings_given IS NOT NULL;

-- 6.No. oF days
SELECT COUNT(DISTINCT date) AS No_of_Days FROM dim_date;

-- 7.Total cancelled bookings
SELECT COUNT(booking_status) AS Cancelled_Bookings FROM fact_bookings Where booking_status = "Cancelled";

-- 8.Cancellation%
SELECT ROUND((COUNT(CASE WHEN booking_status = "cancelled" THEN 1 END)*100/ Count(booking_id)),2) AS Cancellation_Rate FROM fact_bookings;

-- 9.Total Checked Out
select COUNT(booking_status) FROM fact_bookings WHERE booking_status="Checked out";

-- 10.Total No Show 
SELECT COUNT(booking_status) AS Total_No_Show FROM fact_bookings WHERE booking_status = "No Show";

-- 11.No show Rate
SELECT ROUND((SUM(CASE WHEN booking_status = "No Show" THEN 1  END)*100/COUNT(booking_id)),2) AS No_show_Rate FROM fact_bookings ;

-- 12.Total Successful Bookings
SELECT SUM(successful_bookings) FROM fact_aggregated_bookings;

-- 13.Booking % by platform
SELECT booking_platform, COUNT(*) * 100 / (SELECT COUNT(*) FROM Fact_bookings) AS RATE
FROM fact_bookings
GROUP BY booking_platform
ORDER BY RATE DESC;

-- 14.Booking % by Room Class
SELECT * FROM dim_rooms;
SELECT * FROM fact_bookings;

SELECT room_category, COUNT(*)*100 / (SELECT COUNT(*) FROM fact_bookings) AS Booking_Rate 
FROM fact_bookings 
GROUP BY room_category 
ORDER BY booking_rate DESC;

SELECT r.room_class, COUNT(*)*100 / (SELECT COUNT(*) FROM fact_bookings) AS booking_rate
FROM fact_bookings f
JOIN dim_rooms r ON f.room_category = r.room_id
GROUP BY r.room_class
ORDER BY booking_rate DESC;

-- 15.ADR-Average Daily Rate=sum(revenue)/count(checked out)
SELECT ROUND(SUM(revenue_realized)/count(CASE WHEN booking_status = "Checked Out" Then 1 END),2) AS ADR 
FROM fact_bookings;

-- 16.Realisation%
SELECT ROUND(SUM(CASE WHEN booking_status ="checked out" Then 1 end)*100/COUNT(booking_id),2) AS Realisation 
FROM fact_bookings;

-- 17.RevPAR-Revenue per available Room = Total Revenue / Total Rooms Available
SELECT 
  ROUND(
    SUM(fb.revenue_realized) / 
    SUM(fab.capacity), 2
  ) AS RevPAR
FROM fact_bookings fb
CROSS JOIN (SELECT SUM(capacity) AS capacity FROM fact_aggregated_bookings) fab;
