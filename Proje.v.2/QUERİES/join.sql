use AIRPORT
/*********************************************************************/
/****************** JOIN *********************************************/
/********************************************************************/

/**************** Tüm uçuþlarýn ilk ayaklarýnýn nereden kaltýðý ve son ayaðýn nereye indiðini gösterir.**************/
select dep_fl.Flight_number ,  c.Name , f.Weekdays ,dep.Name,arr.Name ,dep_fl.Scheduled_departure_time,arr_fl.Scheduled_arrival_time
from FLIGHT_LEG dep_fl
JOIN FLIGHT f on f.Flight_number = dep_fl.Flight_number
JOIN AIRPORT dep on dep.Airport_code = dep_fl.Departure_airport_code
JOIN FLIGHT_LEG arr_fl on arr_fl.Flight_number = dep_fl.Flight_number /* SON UÇUÞ AYAÐINI BULMAK ÝCÝN*/
JOIN AIRPORT arr on arr.Airport_code = arr_fl.Arrival_airport_code 
LEFT JOIN AIRLANE_COMPANY ac on ac.Airline_id = f.Airline_id 
LEFT JOIN COMPANY c on c.Company_id = ac.Company_id
where dep_fl.Leg_number = 1 and arr_fl.Leg_number in (select count(*)
											   from FLIGHT_LEG fl3
											   where arr_fl.Flight_number=fl3.Flight_number)


/************************* EN ÇOK YOLCU TAÞIYAN UÇUÞ ***********************************************/

SELECT distinct li.Flight_number , li.Leg_number , li.Date , dep.Name , li.Departure_time, arr.Name , li.Arrival_time
FROM LEG_INSTANCE li
left JOIN SEAT_RESERVATION sr on li.Flight_number=sr.Flight_number and li.Leg_number = sr.Leg_number
							and li.Date = sr.Date
LEFT JOIN AIRPORT dep on dep.Airport_code =li.Departure_airport_code 
LEFT JOIN AIRPORT arr on arr.Airport_code = li.Arrival_airport_code 
where cast(li.Flight_number as varchar)+CAST(li.Leg_number as varchar)+CAST(li.Date as varchar) in 
		(select top 1 cast(s.Flight_number as varchar)+CAST(s.Leg_number as varchar)+CAST(s.Date as varchar)
		 from SEAT_RESERVATION s
		 group by s.Flight_number,s.Leg_number,s.Date
		 order by count(*) desc)
		 

/*********    UÇUÞ ÜCRETLERÝ    *******/
SELECT f.Flight_number , C.Name, f.Weekdays,  fa.Amount, fa.Restriction
FROM FLIGHT f
JOIN FARE fa on fa.Flight_number = f.Flight_number
LEFT JOIN AIRLANE_COMPANY ac on ac.Airline_id = f.Airline_id 
LEFT JOIN COMPANY c on c.Company_id = ac.Company_id