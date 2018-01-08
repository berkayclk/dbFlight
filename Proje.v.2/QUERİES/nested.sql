USE AIRPORT

/************************************************************************/
/************************** NESTED  *************************************/
/************************************************************************/


/*** SON 30 GÜNDE EN FAZLA UÇUÞ YAPAN UÇAK  *****************************************/
select a.Airplane_id as "AIRPLANE ID"  , (c.Name + ' ' + a.Airplane_type ) as "AIRPLANE NAME", a.Total_number_of_seats as "SEAT COUNT" 
FROM AIRPLANE a , AIRPLANE_TYPE ap,AIRPLANE_COMPANY ac ,COMPANY c
where a.Airplane_type = ap.Airplane_type_name and ap.Airplane_company_id = ac.Airplane_company_id and c.Company_id = ac.Company_id and
a.Airplane_id in (select TOP 1 l.Airplane_id 
		from LEG_INSTANCE  l
		WHERE cast(l.Date as datetime)> DATEADD(DAY,-30,getdate())
		GROUP BY l.Airplane_id
		ORDER BY COUNT(*) DESC)



/********* TÜM HAVAALANLARININ %90'nýna iniþ yapabilen uçaklar */
SELECT ap.Airplane_id,ap.Airplane_type 
FROM AIRPLANE ap
where ((select count(*) from AIRPORT a)*0.90) < (select count(c.Airport_code)
											from CAN_LAND c 
											where c.Airplane_type_name = ap.Airplane_type)


/********* EN PAHALI UÇUÞUN DETAYLARI */
SELECT f.Flight_number, f.Leg_number,dep.Name,arr.Name , f.Scheduled_arrival_time 
FROM FLIGHT_LEG as f
LEFT JOIN AIRPORT arr on arr.Airport_code = f.Arrival_airport_code
LEFT JOIN AIRPORT dep on dep.Airport_code = f.Departure_airport_code
where f.Flight_number in (select TOP 1 fa.Flight_number
						from FARE fa
						ORDER BY fa.Amount desc)
order by f.Leg_number asc


/****** UÇUÞU EN FAZLA GERÇEKLEÞTÝRÝLEN FLIGHT_LEG***/
select *
from FLIGHT_LEG fl
where cast(fl.Flight_number as varchar)
+cast(fl.Leg_number as varchar) in(select top 1 cast(li.Flight_number as varchar) +cast(li.Leg_number as varchar)
								from LEG_INSTANCE li 
								group by li.Flight_number ,li.Leg_number
								order by count(*) desc)