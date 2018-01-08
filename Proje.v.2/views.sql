/************ UÇAKLARIN COMPANY'LER ÝLE BÝRLÝKTE LÝSTESÝ **************/

CREATE VIEW AIRPLANE_VIEW
AS
SELECT COMPANY.Company_id,  COMPANY.Name, AIRPLANE_TYPE.Airplane_type_name, AIRPLANE.Airplane_id, AIRPLANE.Total_number_of_seats
FROM     COMPANY INNER JOIN
                  AIRPLANE_COMPANY ON COMPANY.Company_id = AIRPLANE_COMPANY.Company_id INNER JOIN
                  AIRPLANE_TYPE ON AIRPLANE_COMPANY.Airplane_company_id = AIRPLANE_TYPE.Airplane_company_id INNER JOIN
                  AIRPLANE ON AIRPLANE_TYPE.Airplane_type_name = AIRPLANE.Airplane_type

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************* HAVAYOLU ÞÝRKETLERÝ LÝSTESÝ */
CREATE VIEW AIRLINES_VIEW
AS
SELECT AIRLANE_COMPANY.Airline_id, COMPANY.Name, COMPANY.Foundation_date, COMPANY.Headquarters, AIRLANE_COMPANY.Total_airplane_count, AIRLANE_COMPANY.Free_bag_limit
FROM     AIRLANE_COMPANY INNER JOIN
                  COMPANY ON AIRLANE_COMPANY.Company_id = COMPANY.Company_id

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/************* HAVAALANLARINA ÝNÝÞ YAPABÝLEN UÇAKLARIN LÝSTESÝ */

CREATE VIEW CANLAND_VIEW
AS
SELECT AIRPORT.Airport_code, AIRPORT.Name, AIRPORT.City, AIRPLANE_VIEW.Name AS COMPANY_NAME , AIRPLANE_VIEW.Airplane_type_name, AIRPLANE_VIEW.Airplane_id
FROM     AIRPORT INNER JOIN
                  CAN_LAND ON AIRPORT.Airport_code = CAN_LAND.Airport_code INNER JOIN
                  AIRPLANE_VIEW ON CAN_LAND.Airplane_type_name = AIRPLANE_VIEW.Airplane_type_name

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**************  FLIGH_LEG DETAYLI LÝSTE ********************************/
CREATE VIEW FLIGHT_LEG_VIEW
AS
SELECT AIRLINES_VIEW.Airline_id, AIRLINES_VIEW.Name AS Airline_name, FLIGHT.Weekdays, FLIGHT_LEG.Flight_number, FLIGHT_LEG.Leg_number, LEG_INSTANCE.Date, FLIGHT_LEG.Millage, 
                  AIRPORT_Departue.Name AS Departure_airport, FLIGHT_LEG.Scheduled_departure_time, AIRPORT_Arrival.Name AS Arrival_airport, FLIGHT_LEG.Scheduled_arrival_time, AIRPLANE.Name AS Airplane_Company, 
                  AIRPLANE.Airplane_type_name, AIRPLANE.Airplane_id
FROM     LEG_INSTANCE INNER JOIN
                  FLIGHT_LEG ON LEG_INSTANCE.Flight_number = FLIGHT_LEG.Flight_number AND LEG_INSTANCE.Leg_number = FLIGHT_LEG.Leg_number INNER JOIN
                  AIRPORT AS AIRPORT_Departue ON LEG_INSTANCE.Departure_airport_code = AIRPORT_Departue.Airport_code INNER JOIN
                  AIRPORT AS AIRPORT_Arrival ON LEG_INSTANCE.Arrival_airport_code = AIRPORT_Arrival.Airport_code INNER JOIN
                  AIRPLANE_VIEW AS AIRPLANE ON AIRPLANE.Airplane_id = LEG_INSTANCE.Airplane_id INNER JOIN
                  FLIGHT ON FLIGHT_LEG.Flight_number = FLIGHT.Flight_number INNER JOIN
                  AIRLINES_VIEW ON AIRLINES_VIEW.Airline_id = FLIGHT.Airline_id

GO
