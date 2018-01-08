use AIRPORT
/************************************************************************/
/************************** NOT EXISTS  **********************************/
/************************************************************************/

/*********  TEK AYAKTA GERÇEKLEÞEN UÇUÞLAR ***************************/
select *
from FLIGHT_LEG f
where not exists ( select * 
				from FLIGHT_LEG l
				where l.Flight_number = f.Flight_number
				and	l.Leg_number <> f.Leg_number)

/**** ADNAN MENDERESE EN ÇOK ÝNEN UÇAK ****************/

select c.Name, apt.Airplane_type_name 
from AIRPLANE_TYPE apt, AIRPLANE_COMPANY ac, COMPANY c
where apt.Airplane_type_name in (select top 1 ap.Airplane_type 
								from AIRPORT a, AIRPLANE ap
								WHERE EXISTS (select *
												from CAN_LAND c
												where a.Airport_code = c.Airport_code 
												and	ap.Airplane_type = c.Airplane_type_name)
								and a.Name LIKE '%Adnan Menderes%'
								GROUP BY ap.Airplane_type
								ORDER BY COUNT(*) desc)
and c.Company_id = ac.Company_id and apt.Airplane_company_id = ac.Airplane_company_id