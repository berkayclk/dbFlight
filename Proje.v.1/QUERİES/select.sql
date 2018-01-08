use AIRPORT_DB


/********************************************************************************/
/********************* 2'L� Select  *********************************************/
/********************************************************************************/
BEGIN

/********************** BELL� B�R U�U�TA ��MD�YE KADAR U�MU� B�LETL� YOLCULAR *********************************/
SELECT distinct  f.Airline,f.Weekdays , sr.Customer_name,sr.Customer_phone
FROM SEAT_RESERVATION sr, FLIGHT f
WHERE sr.Flight_number = f.Flight_number 
and f.Flight_number = 1000


/********************* U�AKLARIN DETAYLI L�STES� **************************************/
SELECT apt.Company +' '+ apt.Airplane_type_name as "Type", ap.Airplane_id,ap.Total_number_of_seats
FROM AIRPLANE ap, AIRPLANE_TYPE apt 
WHERE ap.Airplane_type = apt.Airplane_type_name



/********************** R�TAR YAPAN U�U�LAR VE R�TAR SURES�  **************************************************/
select fl.Flight_number, fl.Leg_number , fl.Scheduled_departure_time as"Planlanan " , cast(li.Departure_time as time(0))as "Ger�ekle�en",
 cast(DATEDIFF(MINUTE, (cast(li.Date as datetime)+cast(fl.Scheduled_departure_time as datetime)), li.Departure_time) as varchar)+' dk' AS "R�TAR"
from FLIGHT_LEG fl, LEG_INSTANCE li
where fl.Flight_number = li.Flight_number and fl.Leg_number = li.Leg_number
and (cast(li.Date as datetime )+ CAST(fl.Scheduled_departure_time as datetime)) <> 
									li.Departure_time
END

/********************************************************************************/
/********************* 3'L� Select  *********************************************/
/********************************************************************************/
BEGIN

/*************** 250 �st� yolcu ta��yan u�aklar�n inebilece�i havaalanlar� ******/
select distinct a.Name 
from CAN_LAND c, AIRPLANE ap, AIRPORT a
where c.Airport_code = a.Airport_code and ap.Airplane_type = c.Airplane_type_name
and ap.Total_number_of_seats >250

/********** 1001 Numaral� u�u�un planlanan ve ger�ekle�en kalk�� saatlari ***************/
select fl.Flight_number , fl.Leg_number , li.Date,dep.Name , fl.Scheduled_departure_time as "Planlanan Kalk�� Saati" , 
														cast(li.Departure_time as time(0)) as "Kalk�� Saati"
FROM FLIGHT_LEG fl, LEG_INSTANCE li, AIRPORT dep
where fl.Flight_number = li.Flight_number and fl.Leg_number = li.Leg_number
	and fl.Departure_airport_code = dep.Airport_code 
	and fl.Flight_number = 1001

/********** Pegasus - Izm�r => �stanbul U�u�lar� ***************/
SELECT f.Flight_number , fl.Flight_number, f.Weekdays , dep.Name ,arr.Name,fl.Scheduled_departure_time
FROM FLIGHT f, FLIGHT_LEG fl, AIRPORT dep, AIRPORT arr
WHERE f.Flight_number = fl.Flight_number 
and fl.Departure_airport_code = dep.Airport_code 
and fl.Arrival_airport_code =arr.Airport_code
and dep.City = '�zmir' and arr.City = '�stanbul'
and f.Airline = 'Pegasus'

/********** EKONOM� SINIFINDA EN PAHALI U�U� ***************/
select top 1 fd.Flight_number , fd.Airline ,fd.Weekdays ,dep.Name , fd.Departure_time ,arr.Name ,fd.Arrival_time ,fa.Amount ,fa.Restriction
from FARE fa, FLIGHT_DETAILS fd, AIRPORT dep ,AIRPORT arr
where fa.Flight_number = fd.Flight_number 
and fd.Departure_airport_code = dep.Airport_code and fd.Arrival_airport_code = arr.Airport_code
and fa.Restriction='Ekonomi'
ORDER BY fa.Amount desc


END


/********************************************************************************/
/********************* 4'L� Select  *********************************************/
/********************************************************************************/



BEGIN

/********** Boeing firas�n�n u�aklar�n�n ger�ekle�tirdi�i u�aklar ***************/
SELECT li.Flight_number , li.Leg_number , apt.Company + ' '+ apt.Airplane_type_name , a.Airplane_id , 
dep.Name as "Departure Airport",arr.Name as "Arrival Airport"
FROM AIRPLANE a, AIRPLANE_TYPE apt, LEG_INSTANCE li , AIRPORT dep, AIRPORT arr
WHERE a.Airplane_id = li.Airplane_id 
and li.Departure_airport_code = dep.Airport_code and li.Arrival_airport_code = arr.Airport_code
and apt.Airplane_type_name = a.Airplane_type and apt.Company = 'Boeing'


/********** En �ok para kazand�ran u�u� ***************/
SELECT fd.Flight_number , fd.Airline , dep.Name , fd.Departure_time , arr.Name, fd.Arrival_time , fa.Amount , fa.Restriction
FROM FLIGHT_DETAILS fd, AIRPORT dep ,AIRPORT arr ,FARE fa
WHERE fd.Departure_airport_code = dep.Airport_code and fd.Arrival_airport_code = arr.Airport_code
and fa.Flight_number = fd.Flight_number
AND fd.Flight_number in (SELECT TOP 1 sr.Flight_number
						FROM SEAT_RESERVATION sr , FARE fa
						WHERE fa.Flight_number = sr.Flight_number
						GROUP BY sr.Flight_number , fa.Amount
						ORDER BY fa.Amount * COUNT(*) DESC)


/********** EN �OK U�U� YAPAN OYUNCUNUN, EN �OK KULLANDI�I HAVAL�MANI ***************/
 SELECT  TOP 1 dep.Airport_code , dep.Name ,dep.City
 FROM SEAT_RESERVATION sr , FLIGHT_DETAILS fd , AIRPORT dep
 WHERE fd.Departure_airport_code = dep.Airport_code 
 and fd.Flight_number = sr.Flight_number
 and sr.Customer_name in  (SELECT TOP 1 best_customer.Customer_name 
							 FROM SEAT_RESERVATION best_customer
							 GROUP BY best_customer.Customer_name 
							 ORDER BY COUNT(*) DESC)
GROUP BY dep.Airport_code, dep.Name, dep.City
ORDER BY COUNT(*) DESC

END