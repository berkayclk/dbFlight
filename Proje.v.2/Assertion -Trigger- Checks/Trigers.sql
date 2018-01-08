use AIRPORT

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******  SEAT_RESERVATION -- MÜÞTERÝLERÝN UÇUÞ MÝLLERÝNÝ KAYDEDER -- TRIGGER ***/
CREATE TRIGGER GET_LOG_CUSTOMER_FLIGHT_INFO
   ON  SEAT_RESERVATION
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;

   
	DECLARE @flightId int
	DECLARE @legNumber int
	DECLARE @flightDate date

	 DECLARE @customerId int
	Declare @datetime datetime
	DECLARE @mil int

	select @flightId = Flight_number, @legNumber = Leg_number,@flightDate = Date , @customerId = Customer_id
	from inserted

	select @datetime = cast(@flightDate as datetime) + CAST(Scheduled_departure_time as datetime) , @mil= Millage
	from FLIGHT_LEG
	WHERE @flightId = Flight_number and @legNumber = Leg_number


	INSERT INTO FFC (Customer_id,Date,Mil)
	VALUES (@customerId,@datetime,@mil)


END



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******  LEG_INSTANCE -- UÇUÞ AÇILDIÐINDA ATANAN UÇAÐIN KOLTUK SAYISI GELÝR -- TRIGGER ***/
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******  SEAT_RESERVATION -- REZERVASYONDAN SONRA UÇUÞUN UYGUN KOLTUK SAYISI AZALTILIR-- TRIGGER ***/
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******  SEAT_RESERVATION -- REZERVASYONDAN ÝPTALÝNDEN SONRA UÇUÞUN UYGUN KOLTUK SAYISI ARTIRILIR -- TRIGGER ***/
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******  FLIGHT -- UÇUÞ SÝLÝNDÝÐÝNDE, TÜM LEG VE INSTANCE'LAR SILINIR-- TRIGGER ***/
CREATE TRIGGER DELETE_FLIGHT
   ON  FLIGHT
   INSTEAD OF DELETE
AS 
BEGIN

	declare @fliegtNumber int 

	select @fliegtNumber = Flight_number
	from deleted

	if(select count(*) from SEAT_RESERVATION WHERE Flight_number = @fliegtNumber ) >0
	begin
		DELETE FROM SEAT_RESERVATION 
		WHERE Flight_number = @fliegtNumber
	end
	
	if(select count(*) from LEG_INSTANCE WHERE Flight_number = @fliegtNumber ) >0
	begin
		DELETE FROM LEG_INSTANCE 
		WHERE Flight_number = @fliegtNumber
	end

	if(select count(*) from FLIGHT_LEG WHERE Flight_number = @fliegtNumber ) >0
	begin
		DELETE FROM FLIGHT_LEG 
		WHERE Flight_number = @fliegtNumber
	end

	if(select count(*) from FLIGHT WHERE Flight_number = @fliegtNumber ) >0
	begin
		DELETE FROM FLIGHT
		WHERE Flight_number = @fliegtNumber    
	end

	

	

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

	if(select count(*) from SEAT_RESERVATION WHERE Flight_number = @fliegtNumber and @legNumber <= Leg_number) >0
	begin
		DELETE FROM SEAT_RESERVATION 
		WHERE Flight_number = @fliegtNumber and 
		(@legNumber <= Leg_number)
	end 
	
	if(select count(*) from LEG_INSTANCE WHERE Flight_number = @fliegtNumber and @legNumber <= Leg_number) >0
	begin
		DELETE FROM LEG_INSTANCE 
		WHERE Flight_number = @fliegtNumber and 
		(@legNumber <= Leg_number)
	end
	if(select count(*) from FLIGHT_LEG WHERE Flight_number = @fliegtNumber and @legNumber <= Leg_number) >0
	begin
		DELETE FROM FLIGHT_LEG 
		WHERE Flight_number = @fliegtNumber and 
		(@legNumber <= Leg_number)
	end


END
GO


