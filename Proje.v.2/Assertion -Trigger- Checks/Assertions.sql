
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******** AIRPLANE -  Max_seats Validation - Assertion *****/
CREATE TRIGGER TOTAL_SEATS_VALIDATION
ON AIRPLANE
INSTEAD OF INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @max_seats int
 
       SELECT @max_seats = Max_seats
       FROM AIRPLANE_TYPE
	   WHERE Airplane_type_name = (select Airplane_type from inserted)    
 
       IF @max_seats < (select Total_number_of_seats from inserted)
       BEGIN
              RAISERROR('Ucagin alabilecegi yolcu sayisi asildi.',16 ,1)
              ROLLBACK
       END
       ELSE
       BEGIN
			INSERT INTO AIRPLANE 
			select * from inserted
       END
END



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER CAN_LAND_and_DATE_VALIDATION
ON LEG_INSTANCE
INSTEAD OF INSERT
AS
BEGIN
       SET NOCOUNT ON;

	   /* ------------ CHECK DEPARTURE TIME ------------- */
BEGIN
	   declare @dateOfDeparture date
	   declare @flightDate date

	   SELECT @dateOfDeparture = CONVERT(date,i.Departure_time),@flightDate = i.date 
	   from inserted as i

	   if @dateOfDeparture != @flightDate
	   begin
			 RAISERROR('Uçuş kalkış zamanı, uçuş gününde olmalıdır.',16 ,1)
              ROLLBACK
       END
END


		 /* ------------ CHECK CAN LAND ------------- */
BEGIN 
	 declare @shouldCheck bit =0
	
	if (select Arrival_airport_code from inserted) != null
	begin
		set @shouldCheck =1
	
       DECLARE @airplaneId int
	   DECLARE @arrivalAirport int
	   DECLARE @arrivalCanLand int

       SELECT @airplaneId = Airplane_id, 
	   @arrivalAirport = Arrival_airport_code
       FROM inserted

	
		
	   SELECT @arrivalCanLand =  count(*)
	   FROM CAN_LAND AS c, AIRPLANE AS a
	   WHERE c.Airplane_type_name = a.Airplane_type and
			a.Airplane_id = @airplaneId and
			c.Airport_code = @arrivalAirport
	   
	   end
	  
       IF @arrivalCanLand <=0 and @shouldCheck = 1
       BEGIN
              RAISERROR('Uçuş, uçağın iniş yapamayacağı bir havaalanı ile eklenemez. ',16 ,1)
              ROLLBACK
       END
END
	 
	/**************** GET DATA FROM FLIGHT_LEG ***************************/
BEGIN

declare @flightNumber int
  declare @legNumber int

  declare @departureAirPort int
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

 if @legNumber >2
	begin 
		declare @rotar int = CAST(RAND()*100 AS INT)
		set @departureDT =  DATEADD(MINUTE,@rotar,@departureDT)
		set @arrivalDT =  DATEADD(MINUTE,@rotar,@arrivalDT)
	end
 end
	
END

	INSERT INTO LEG_INSTANCE 
	SELECT Flight_number,Leg_number,Date,Number_of_available_seats,Airplane_id,@departureAirPort,@departureDT,@arrivalAirport,@arrivalDT
	from inserted

END


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/********** SEAT_RESERVATION - CHECK AVAILABLE SEATS - ASSERTION ****************/
CREATE TRIGGER CHECK_AVAILABLE_SEATS
ON SEAT_RESERVATION
INSTEAD OF INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @available_Seats int
 
      select @available_Seats = l.Number_of_available_seats
	   from LEG_INSTANCE AS l,inserted as i 
	   where l.Flight_number = i.Flight_number
		and l.Leg_number = i.Leg_number
		and l.Date = i.Date
 
       IF @available_Seats < 1
       BEGIN
              RAISERROR('Uçuşta boş koltuk bulunmuyor',16 ,1)
              ROLLBACK
       END
       ELSE
       BEGIN
			INSERT INTO SEAT_RESERVATION 
			select * from inserted
       END
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******** FLIGHT_LEG -  Airport Validation Validation - Assertion *****/
CREATE TRIGGER AIRPORT_VALIDATION
ON FLIGHT_LEG
INSTEAD OF INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @currentLegNumber int
	   DECLARE @lastLegNumber int
	   DECLARE @currentLegDepartureAirport int
	   DECLARE @lastLegArrivalAirport int

       SELECT TOP 1 @lastLegNumber = Leg_number, @lastLegArrivalAirport = Arrival_airport_code
	   FROM FLIGHT_LEG AS f
	   WHERE f.Flight_number = (select Flight_number from inserted)
	   order by f.Leg_number desc

		
	   SELECT @currentLegDepartureAirport = Departure_airport_code
	   from inserted

	   
	  
       IF @lastLegArrivalAirport != @currentLegDepartureAirport
       BEGIN
              RAISERROR('Ucusun kalkis havaalani son ayaktaki inis ile ayni olmalidir. ',16 ,1)
              ROLLBACK
       END
       ELSE
       BEGIN
			
			if @lastLegNumber is null
			begin 
				set @lastLegNumber = 0
			end
		   
		   set @currentLegNumber = @lastLegNumber +1

			while  (select count(*) 
				from FLIGHT_LEG				
				Where Flight_number = (select Flight_number from inserted ) 
				and Leg_number = @currentLegNumber) >0
			begin 
				set @currentLegNumber += 1
			end
			
				INSERT INTO FLIGHT_LEG (Flight_number,Leg_number,Departure_airport_code,Scheduled_departure_time,Arrival_airport_code,Scheduled_arrival_time,Millage)
			 select Flight_number,@currentLegNumber,Departure_airport_code,Scheduled_departure_time,Arrival_airport_code,Scheduled_arrival_time ,Millage
			 from inserted


       END
END
