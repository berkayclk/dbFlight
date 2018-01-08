
/*************** COMPANY ****************************************/
INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters) 
	VALUES (1,'Boeing','1916-07-15','Þikago, Illinois, ABD')
INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters)
	VALUES (2,'Airbus','1970-12-18','Blagnac, Fransa')

INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters)
	VALUES (3,'AnadoluJet','2000-07-15','Istanbul,Turkiye')
INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters)  
	VALUES (4,'Atlas','2005-12-18','Istanbul,Turkiye')
	INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters)
	VALUES (5,'Bora','2008-07-15','Antalya,Turkiye')
INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters)
	VALUES (6,'Pegasus','1998-12-18','Izmir,Turkiye')
INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters)
	VALUES (7,'Sun Express','2003-07-15','Istanbul,Turkiye')
INSERT INTO COMPANY(Company_id,Name,Foundation_date,Headquarters)
	VALUES (8,'THY','1985-12-18','Ankara,Turkiye')

/*************** AIRLANE_COMPANY ****************************************/
INSERT INTO AIRLANE_COMPANY(Airline_id,Company_id,Total_airplane_count,Free_bag_limit)
	VALUES(1,3,50,10)
INSERT INTO AIRLANE_COMPANY(Airline_id,Company_id,Total_airplane_count,Free_bag_limit)
	VALUES(2,4,25,8)
INSERT INTO AIRLANE_COMPANY(Airline_id,Company_id,Total_airplane_count,Free_bag_limit)
	VALUES(3,5,35,12)
INSERT INTO AIRLANE_COMPANY(Airline_id,Company_id,Total_airplane_count,Free_bag_limit)
	VALUES(4,6,250,15)
INSERT INTO AIRLANE_COMPANY(Airline_id,Company_id,Total_airplane_count,Free_bag_limit)
	VALUES(5,7,100,15)
INSERT INTO AIRLANE_COMPANY(Airline_id,Company_id,Total_airplane_count,Free_bag_limit)
	VALUES(6,8,500,20)

/*************** AIRPLANE_COMPANY ****************************************/
INSERT INTO AIRPLANE_COMPANY(Airplane_company_id,Company_id,Largest_model)
	VALUES(1,1,'747-8')
INSERT INTO AIRPLANE_COMPANY(Airplane_company_id,Company_id,Largest_model)
	VALUES(2,2,'A380')

	





