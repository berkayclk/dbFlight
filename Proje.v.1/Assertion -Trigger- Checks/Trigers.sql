
/*******  LEG_INSTANCE -- SET FIRST VALUE OF AVAILABLE SEATS -- TRIGGER ***/
CREATE TRIGGER SET_FIRST_AVAILABLE_SEATS
ON LEG_INSTANCE
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
		
       declare @number_of_seats int
	   
	   select @number_of_seats = Total_number_of_seats
	   from AIRPLANE
	   where Airplane_id = (select Airplane_id from inserted )

	   UPDATE LEG_INSTANCE 
	   SET Number_of_available_seats = @number_of_seats
	   where Flight_number = (select Flight_number from inserted)
		and	Leg_number = (select Leg_number from inserted)
		and	Date = (select Date from inserted)

END
GO

/*******  SEAT_RESERVATION -- SET AVILABLE SEAT AFTER RESERVATION -- TRIGGER ***/
CREATE TRIGGER SET_AVILABLE_SEAT_AFTER_RESERVATION
ON SEAT_RESERVATION
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
		
         UPDATE LEG_INSTANCE 
	   SET Number_of_available_seats = Number_of_available_seats - 1
	   where Flight_number in (select Flight_number from inserted)
		and	Leg_number in (select Leg_number from inserted)
		and	Date in (select Date from inserted)
		

END
GO

/*******  SEAT_RESERVATION -- SET AVILABLE SEAT AFTER RESERVATION CANCELED -- TRIGGER ***/
CREATE TRIGGER SET_AVILABLE_SEAT_AFTER_RESERVATION_CANCELED
ON SEAT_RESERVATION
AFTER DELETE
AS
BEGIN
       SET NOCOUNT ON;
		
          UPDATE LEG_INSTANCE 
	   SET Number_of_available_seats = Number_of_available_seats +1
	   where Flight_number in (select Flight_number from deleted)
		and	Leg_number in (select Leg_number from deleted)
		and	Date in (select Date from deleted)

END
GO

/*******  FLIGHT -- DELETE FLIGHT-- TRIGGER ***/
CREATE TRIGGER DELETE_FLIGHT
   ON  FLIGHT
   INSTEAD OF DELETE
AS 
BEGIN

	declare @fliegtNumber int 

	select @fliegtNumber = Flight_number
	from deleted


	DELETE FROM SEAT_RESERVATION 
	WHERE Flight_number = @fliegtNumber
	
	DELETE FROM LEG_INSTANCE 
	WHERE Flight_number = @fliegtNumber
		
	DELETE FROM FLIGHT_LEG 
	WHERE Flight_number = @fliegtNumber

	DELETE FROM FLIGHT
	WHERE Flight_number = @fliegtNumber    

END
GO


/*******  FLIGHT_LEG -- DELETE FLIGHT_LEG -- TRIGGER ***/
CREATE TRIGGER DELETE_FLIGHT_LEG
   ON  FLIGHT_LEG
   INSTEAD OF DELETE
AS 
BEGIN

	declare @fliegtNumber int 
	declare @legNumber int

	select @fliegtNumber = Flight_number, @legNumber = Leg_number
	from deleted 


	DELETE FROM SEAT_RESERVATION 
	WHERE Flight_number = @fliegtNumber and 
	(@legNumber <= Leg_number)
	
	DELETE FROM LEG_INSTANCE 
	WHERE Flight_number = @fliegtNumber and 
	(@legNumber <= Leg_number)
		
	DELETE FROM FLIGHT_LEG 
	WHERE Flight_number = @fliegtNumber and 
	(@legNumber <= Leg_number)


END
GO

/************ LEG_INSTANCE  - GET_DATA_FROM_LEG - TRIGGER ************/

CREATE TRIGGER GET_DATA_FROM_LEG
   ON  LEG_INSTANCE
   AFTER INSERT
AS 
BEGIN
	

  declare @flightNumber int
  declare @legNumber int
  declare @flightDate date

  declare @departureAirPort int
  declare @arrivalAirport int 
  declare @departureTime time
  declare @arrivalTime time 

  declare @departureDT datetime
  declare @arrivalDT datetime

  select @flightNumber = Flight_number, @legNumber = Leg_number, @flightDate =Date
  from inserted

  select @departureTime = Scheduled_departure_time, @arrivalTime = Scheduled_arrival_time,
	@departureAirPort = Departure_airport_code, @arrivalAirport = Arrival_airport_code
  from FLIGHT_LEG
  where  @flightNumber = Flight_number and @legNumber = Leg_number

  
  begin

  /* generate datetimes */
 set @departureDT = CAST(@flightDate as datetime)
	
 set @departureDT = DATEADD(MINUTE, datepart(MINUTE,@departureTime),CAST(@departureDT as datetime))
 set @departureDT = DATEADD(HOUR, datepart(HOUR,@departureTime),CAST(@departureDT as datetime))


  set @arrivalDT = CAST(@flightDate as datetime)
	
 set @arrivalDT = DATEADD(MINUTE, datepart(MINUTE,@arrivalTime),CAST(@arrivalDT as datetime))
 set @arrivalDT = DATEADD(HOUR, datepart(HOUR,@arrivalTime),CAST(@arrivalDT as datetime))

  if datepart(HOUR , @departureTime) > datepart(HOUR , @arrivalTime)
	begin
		set @arrivalDT = DATEADD(DAY,1, @arrivalDT)
	end
 end


 UPDATE  LEG_INSTANCE SET Arrival_airport_code = @arrivalAirport , Departure_airport_code = @departureAirPort, 
							Departure_time = @departureDT , Arrival_time = @arrivalDT
 where  @flightNumber = Flight_number and @legNumber = Leg_number and @flightDate = Date
	


END
GO
