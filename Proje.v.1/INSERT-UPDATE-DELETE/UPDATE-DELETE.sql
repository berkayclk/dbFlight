use AIRPORT_DB

/************** UPDATE ***************/
UPDATE SEAT_RESERVATION 
SET Customer_name = 'Ahmet Kerim' 
WHERE Flight_number = 1000 and Leg_number = 1 
and Date='2017-08-10' and Seat_number = 17


UPDATE FARE 
SET Amount = 250
WHERE Flight_number = 1000 AND Fare_code = 1


UPDATE FLIGHT 
SET Weekdays = 'Tue'
WHERE  Flight_number = 100 

/************************ DELETE ********************/
DELETE FROM FARE
WHERE Flight_number = 1000 AND Fare_code = 1

DELETE FROM SEAT_RESERVATION
WHERE Flight_number = 1000 and Leg_number = 1 
and Date='2017-08-10' and Seat_number = 17

DELETE FLIGHT 
WHERE  Flight_number = 100 

