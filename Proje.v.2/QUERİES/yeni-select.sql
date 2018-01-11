
BEGIN

/***************** 25 NUMARALI YOLCUNUN SON 1 AYDA YAPTIÐI MÝL *****************/
SELECT c.Customer_id, c.Name, sum(f.Mil)
FROM FFC f , CUSTOMER c
WHERE f.Customer_id = c.Customer_id
and f.Date > DATEADD(DAY,-10,GETDATE())
group by c.Customer_id, c.Name
HAVING c.Customer_id = 25

/************** Uçak sayýlarýna göre sýralý hava yolu þirketleri *********************/ 
SELECT c.Name, c.Headquarters ,c.Headquarters, a.Free_bag_limit,a.Total_airplane_count
FROM AIRLANE_COMPANY a , COMPANY c
WHERE c.Company_id = a.Airline_company_id
ORDER BY a.Total_airplane_count DESC



/******************** EN KÖKLÜ UÇAK FÝRMASININ ÜRÜNLERÝ **************************************/

SELECT C.Foundation_date , C.Name , apt.Airplane_type_name , AP.Airplane_id
FROM COMPANY c,AIRPLANE_COMPANY ac, AIRPLANE ap ,AIRPLANE_TYPE apt
WHERE c.Company_id = ac.Airplane_company_id 
and ac.Airplane_company_id = apt.Airplane_company_id
 and apt.Airplane_type_name = ap.Airplane_type 
 and c.Foundation_date in (select top 1 com.Foundation_date 
							from COMPANY com 
							where exists (select * from AIRPLANE_COMPANY aircom where com.Company_id = aircom.Company_id)
							ORDER BY com.Foundation_date asc)

/******************** SON BÝR AYDA EN ÇOK MÝL YAPAN MÜÞTERÝ **************************************/
SELECT *
FROM CUSTOMER c
WHERE c.Customer_id in (select top 1 ffc.Customer_id 
						from FFC ffc
						where ffc.Date > DATEADD(DAY,-30,GETDATE())
						group by ffc.Customer_id
						order by sum(ffc.Mil) desc)
END