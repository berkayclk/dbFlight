use AIRPORT
/********************************************************************************/
/********************* 2'L� Select  *********************************************/
/********************************************************************************/
BEGIN

/***************** 25 NUMARALI YOLCUNUN SON 1 AYDA YAPTI�I M�L *****************/
SELECT c.Customer_id, c.Name, sum(f.Mil)
FROM FFC f , CUSTOMER c
WHERE f.Customer_id = c.Customer_id
and f.Date > DATEADD(DAY,-10,GETDATE())
group by c.Customer_id, c.Name
HAVING c.Customer_id = 25

/************** U�ak say�lar�na g�re s�ral� hava yolu �irketleri *********************/ 
SELECT c.Name, c.Headquarters ,c.Headquarters, a.Free_bag_limit,a.Total_airplane_count
FROM AIRLANE_COMPANY a , COMPANY c
WHERE c.Company_id = a.Company_id
ORDER BY a.Total_airplane_count DESC



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




/********************************************************************************/
/********************* 4'L� Select  *********************************************/
/********************************************************************************/

/********************** BELL� B�R U�U�TA ��MD�YE KADAR U�MU� B�LETL� YOLCULAR *********************************/

BEGIN

SELECT distinct  com.Name,f.Weekdays , c.Name,c.Email,c.Phone_number
FROM SEAT_RESERVATION sr, FLIGHT f, CUSTOMER c , AIRLANE_COMPANY a ,COMPANY com
WHERE sr.Flight_number = f.Flight_number 
and f.Airline_id = a.Airline_id 
and com.Company_id = a.Company_id 
and sr.Customer_id = c.Customer_id
and f.Flight_number = 1000

/********************* U�AKLARIM L�STES� **************************************/
SELECT c.Name +' '+ apt.Airplane_type_name as "Type", ap.Airplane_id,ap.Total_number_of_seats
FROM AIRPLANE ap, AIRPLANE_TYPE apt , AIRPLANE_COMPANY ac , COMPANY c 
WHERE ap.Airplane_type = apt.Airplane_type_name
and ac.Airplane_company_id = apt.Airplane_company_id 
and ac.Company_id = c.Company_id


/********************* EN K�KL� U�AK F�RMASININ �R�NLER� **************************************/

SELECT C.Foundation_date , C.Name , apt.Airplane_type_name , AP.Airplane_id
FROM COMPANY c,AIRPLANE_COMPANY ac, AIRPLANE ap ,AIRPLANE_TYPE apt
WHERE c.Company_id = ac.Company_id 
and ac.Airplane_company_id = apt.Airplane_company_id
 and apt.Airplane_type_name = ap.Airplane_type 
 and c.Foundation_date in (select top 1 com.Foundation_date 
							from COMPANY com 
							where exists (select * from AIRPLANE_COMPANY aircom where com.Company_id = aircom.Company_id)
							ORDER BY com.Foundation_date asc)

END