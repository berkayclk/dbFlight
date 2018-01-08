use AIRPORT
/********** AIRPORT **********/
CREATE TABLE AIRPORT(
	Airport_code int PRIMARY KEY NOT NULL,
	Name nvarchar(50) NOT NULL,
	City nvarchar(50) NOT NULL,
	State nvarchar(50) NOT NULL
) 
GO

/********** COMPANY **********/
CREATE TABLE COMPANY(
	Company_id int PRIMARY KEY NOT NULL ,
	Name nvarchar(50) NOT NULL,
	Foundation_date date  NULL,
	Headquarters nvarchar(50)  NULL
) 
GO
/********** AIRPLANE_COMPANY **********/
CREATE TABLE AIRPLANE_COMPANY(
	Airplane_company_id int PRIMARY KEY NOT NULL ,
	Company_id int NOT NULL foreign key references COMPANY(Company_id),
	Largest_model nvarchar(50) null
	
) 
GO
/********** AIRLANE_COMPANY **********/
CREATE TABLE AIRLANE_COMPANY(
	Airline_id int PRIMARY KEY NOT NULL ,
	Company_id int NOT NULL foreign key references COMPANY(Company_id),
	Total_airplane_count int null,
	Free_bag_limit int null
) 
GO


/********** FLIGHT **********/

CREATE TABLE FLIGHT(
	Flight_number int PRIMARY KEY NOT NULL,
	Airline_id int not null foreign key references AIRLANE_COMPANY(Airline_id),
	Weekdays nvarchar(50) NOT NULL
) 
GO



/********** FLIGHT LEG **********/

CREATE TABLE FLIGHT_LEG(
	Flight_number int NOT NULL FOREIGN KEY REFERENCES FLIGHT(Flight_number),
	Leg_number int NOT NULL,
	Departure_airport_code int  NOT NULL FOREIGN KEY REFERENCES AIRPORT(Airport_code),
	Scheduled_departure_time time(0)  NOT NULL,
	Arrival_airport_code int  NOT NULL FOREIGN KEY REFERENCES AIRPORT(Airport_code) ,
	Scheduled_arrival_time time(0)  NOT NULL,
	Millage int NULL
	PRIMARY KEY (Flight_number, Leg_number)
) 

GO

/********** AIRPLANE TYPE **********/

CREATE TABLE AIRPLANE_TYPE(
	Airplane_type_name nvarchar(50) PRIMARY KEY NOT NULL,
	Max_seats int NOT NULL,
	Airplane_company_id int null foreign key references AIRPLANE_COMPANY(Airplane_company_id),
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



/********** CUSTOMER **********/
CREATE TABLE CUSTOMER(
	Customer_id int NOT NULL PRIMARY KEY,
	Name nvarchar(50) NULL,
	Phone_number nvarchar(10) NULL,
	Email nvarchar(50) null,
	Adress nvarchar(50) NULL,
	Country nvarchar(50) NULL,
	Pasaport_number int NULL

) 

/********** SEAT RESERVATION **********/

CREATE TABLE SEAT_RESERVATION(
	Flight_number int NOT NULL,
	Leg_number int NOT NULL,
	Date date NOT NULL,
	Seat_number nvarchar(3) NOT NULL,
	Customer_id int foreign key references CUSTOMER(Customer_id)
	Primary key (Flight_number,Leg_number,Date,Seat_number),
	FOREIGN KEY (Flight_number,Leg_number,Date) REFERENCES  LEG_INSTANCE (Flight_number,Leg_number,Date)
) 

GO


/********** FFC **********/

CREATE TABLE FFC(
	FFC_id int not null primary key identity(1,1),
	Customer_id int not null  foreign key references CUSTOMER(Customer_id),
	Date datetime not null,
	Mil int not null

) 
GO



