
/********** AIRPORT **********/
CREATE TABLE AIRPORT(
	Airport_code int PRIMARY KEY NOT NULL,
	Name nvarchar(50) NOT NULL,
	City nvarchar(50) NOT NULL,
	State nvarchar(50) NOT NULL
) 
GO

/********** FLIGHT **********/

CREATE TABLE FLIGHT(
	Flight_number int PRIMARY KEY NOT NULL,
	Airline nvarchar(50) NOT NULL,
	Weekdays nvarchar(50) NOT NULL
) 
GO

/********** FLIGHT WEEKDAYS VALIDATION -  CHECK CONSTRAINT **********/

ALTER TABLE FLIGHT ADD CONSTRAINT DAY_VALIDATION
CHECK (Weekdays IN ('Mon','Tue','Wed','Thu','Fri','Sat','Sun'));

GO



/********** FLIGHT LEG **********/

CREATE TABLE FLIGHT_LEG(
	Flight_number int NOT NULL FOREIGN KEY REFERENCES FLIGHT(Flight_number),
	Leg_number int NOT NULL,
	Departure_airport_code int  NOT NULL FOREIGN KEY REFERENCES AIRPORT(Airport_code),
	Scheduled_departure_time time(0)  NOT NULL,
	Arrival_airport_code int  NOT NULL FOREIGN KEY REFERENCES AIRPORT(Airport_code) ,
	Scheduled_arrival_time time(0)  NOT NULL,
	PRIMARY KEY (Flight_number, Leg_number)
) 

GO

/********** AIRPLANE TYPE **********/

CREATE TABLE AIRPLANE_TYPE(
	Airplane_type_name nvarchar(50) PRIMARY KEY NOT NULL,
	Max_seats int NOT NULL,
	Company nvarchar(50) NOT NULL,
) 
GO


/********** CAN LAND **********/

CREATE TABLE CAN_LAND(
	Airplane_type_name nvarchar(50) NOT NULL FOREIGN KEY REFERENCES AIRPLANE_TYPE(Airplane_type_name),
	Airport_code int NOT NULL FOREIGN KEY REFERENCES AIRPORT(Airport_code),
	PRIMARY KEY (Airplane_type_name,Airport_code)
)
GO

/********** AIRPLANE **********/

CREATE TABLE AIRPLANE(
	Airplane_id int NOT NULL PRIMARY KEY,
	Total_number_of_seats int NOT NULL,
	Airplane_type nvarchar(50) NOT NULL FOREIGN KEY REFERENCES AIRPLANE_TYPE(Airplane_type_name),
)

GO

/********** FARE **********/

CREATE TABLE FARE(
	Flight_number int NOT NULL FOREIGN KEY REFERENCES FLIGHT(Flight_number),
	Fare_code int NOT NULL,
	Amount int NOT NULL,
	Restriction nvarchar(50) NULL,
	Primary key(Flight_number,Fare_code)
) 

GO

/********** FARE -  RESTRICTION VALIDATION -  CHECK CONSTRAINT **********/

ALTER TABLE FARE ADD CONSTRAINT RESTRICTION_VALIDATION
CHECK (Restriction IN ('Ekonomi','Bussines Class','First Class'));

GO

/********** LEG INSTANCE **********/

CREATE TABLE LEG_INSTANCE(
	Flight_number int NOT NULL,
	Leg_number int NOT NULL,
	Date date NOT NULL,
	Number_of_available_seats int  NULL,
	Airplane_id int NOT NULL FOREIGN KEY REFERENCES AIRPLANE(Airplane_id),
	Departure_airport_code int  NULL FOREIGN KEY REFERENCES AIRPORT(Airport_code),
	Departure_time datetime  NULL,
	Arrival_airport_code int  NULL FOREIGN KEY REFERENCES AIRPORT(Airport_code),
	Arrival_time datetime  NULL,
	Primary key(Flight_number,Leg_number,Date),
	FOREIGN KEY (Flight_number,Leg_number) REFERENCES  FLIGHT_LEG (Flight_number,Leg_number)
) 

GO

/********** LEG INSTANCE FOREIGN KEY CONSTRAINT **********/

ALTER TABLE LEG_INSTANCE  WITH CHECK ADD  CONSTRAINT FK_LEG_INSTANCE_FLIGHT_LEG FOREIGN KEY(Flight_number, Leg_number)
REFERENCES FLIGHT_LEG (Flight_number, Leg_number)
GO

/***** LEG_INSTANCE- ARRIVAL TIME VALIDATION - CHECK CONSTRAINT ****************/
ALTER TABLE LEG_INSTANCE  WITH CHECK 
ADD CONSTRAINT ARRIVAL_TIME_VALIDATION  
CHECK  ((Arrival_time is null) or (Departure_time < Arrival_time))

GO

/********** SEAT RESERVATION **********/

CREATE TABLE SEAT_RESERVATION(
	Flight_number int NOT NULL,
	Leg_number int NOT NULL,
	Date date NOT NULL,
	Seat_number nvarchar(3) NOT NULL,
	Customer_name nvarchar(50) NOT NULL,
	Customer_phone nvarchar(11) NOT NULL,
	Primary key (Flight_number,Leg_number,Date,Seat_number),
	FOREIGN KEY (Flight_number,Leg_number,Date) REFERENCES  LEG_INSTANCE (Flight_number,Leg_number,Date)
) 

GO

/********** SEAT_RESERVATION - CUSTOMER PHONE VALIDATION -  CHECK CONSTRAINT **********/
ALTER TABLE SEAT_RESERVATION  WITH CHECK ADD  CONSTRAINT CUSTOMER_PHONE_VALIDATION
CHECK  (Customer_phone like '5[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') 

GO



