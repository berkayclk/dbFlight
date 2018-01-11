USE AIRPORT

/************************************************************************/
/************************** NESTED  *************************************/
/************************************************************************/


/*** SON 30 GÜNDE EN FAZLA UÇUÞ YAPAN UÇAK  *****************************************/
select a.Airplane_id as "AIRPLANE ID"  , (c.Name + ' ' + a.Airplane_type ) as "AIRPLANE NAME", a.Total_number_of_seats as "SEAT COUNT" 
FROM AIRPLANE a , AIRPLANE_TYPE ap,AIRPLANE_COMPANY ac ,COMPANY c
where a.Airplane_type = ap.Airplane_type_name and ap.Airplane_company_id = ac.Airplane_company_id and c.Company_id = ac.Airplane_company_id and
a.Airplane_id in (select TOP 1 l.Airplane_id 
		from LEG_INSTANCE  l
		WHERE cast(l.Date as datetime)> DATEADD(DAY,-30,getdate())
		GROUP BY l.Airplane_id
		ORDER BY COUNT(*) DESC)


