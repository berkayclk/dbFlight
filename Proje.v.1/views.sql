
use AIRPORT_DB


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************* UÇUÞ ÝLK-SON AYAK LÝSTESÝ */
CREATE VIEW FLIGHT_DETAILS
AS
select f.Flight_number , f.Airline ,f.Weekdays , dep.Departure_airport_code AS Departure_airport_code , dep.Scheduled_departure_time  AS Departure_time,
	arr.Arrival_airport_code AS Arrival_airport_code ,arr.Scheduled_arrival_time AS Arrival_time, arr.Leg_number as total_leg_count
from FLIGHT f
JOIN FLIGHT_LEG dep  on dep.Flight_number = f.Flight_number and dep.Leg_number =1
JOIN FLIGHT_LEG arr on arr.Flight_number = f.Flight_number 
							and arr.Leg_number in (SELECT TOP 1 arr_legnumber.Leg_number
													FROM FLIGHT_LEG arr_legnumber
													WHERE arr_legnumber.Flight_number = arr.Flight_number	
													ORDER BY arr_legnumber.Leg_number desc	)

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************* HAVAALANLARINA ÝNÝÞ YAPABÝLEN UÇAKLARIN LÝSTESÝ */

CREATE VIEW CANLAND_VIEW
AS
SELECT AIRPORT.Airport_code, AIRPORT.Name, AIRPORT.City, AIRPLANE_TYPE.Company, AIRPLANE_TYPE.Airplane_type_name, AIRPLANE.Airplane_id
FROM     AIRPORT INNER JOIN
                  CAN_LAND ON AIRPORT.Airport_code = CAN_LAND.Airport_code INNER JOIN
                  AIRPLANE ON CAN_LAND.Airplane_type_name = AIRPLANE.Airplane_type INNER JOIN
				  AIRPLANE_TYPE ON AIRPLANE_TYPE.Airplane_type_name=AIRPLANE.Airplane_type
				 

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**************  FLIGH_LEG DETAYLI LÝSTE ********************************/
CREATE VIEW FLIGHT_LEG_VIEW
AS
SELECT FLIGHT.Flight_number, FLIGHT.Airline AS Airline_name, FLIGHT.Weekdays, FLIGHT_LEG.Leg_number, LEG_INSTANCE.Date, 
                  AIRPORT_Departue.Name AS Departure_airport, FLIGHT_LEG.Scheduled_departure_time, AIRPORT_Arrival.Name AS Arrival_airport, FLIGHT_LEG.Scheduled_arrival_time, AIRPLANE_TYPE.Company AS Airplane_Company, 
                  AIRPLANE_TYPE.Airplane_type_name, AIRPLANE.Airplane_id
FROM     LEG_INSTANCE INNER JOIN
                  FLIGHT_LEG ON LEG_INSTANCE.Flight_number = FLIGHT_LEG.Flight_number AND LEG_INSTANCE.Leg_number = FLIGHT_LEG.Leg_number INNER JOIN
                  AIRPORT AS AIRPORT_Departue ON LEG_INSTANCE.Departure_airport_code = AIRPORT_Departue.Airport_code INNER JOIN
                  AIRPORT AS AIRPORT_Arrival ON LEG_INSTANCE.Arrival_airport_code = AIRPORT_Arrival.Airport_code INNER JOIN
                  AIRPLANE  ON AIRPLANE.Airplane_id = LEG_INSTANCE.Airplane_id INNER JOIN
                  FLIGHT ON FLIGHT_LEG.Flight_number = FLIGHT.Flight_number INNER JOIN
				  AIRPLANE_TYPE ON AIRPLANE_TYPE.Airplane_type_name=AIRPLANE.Airplane_type
				 

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************ UÇAKLARIN COMPANY'LER ÝLE BÝRLÝKTE LÝSTESÝ **************/


CREATE VIEW AIRPLANE_VIEW
AS
SELECT AIRPLANE_TYPE.Company, AIRPLANE_TYPE.Airplane_type_name, AIRPLANE.Airplane_id, AIRPLANE.Total_number_of_seats
FROM     AIRPLANE_TYPE INNER JOIN
                  AIRPLANE ON AIRPLANE_TYPE.Airplane_type_name = AIRPLANE.Airplane_type






