nearshop(Facility):- 	
					lat(X0) & lon(Y0) 
					& shop(Facility, X1,Y1) & not (shop(T1, X2,Y2) 
					& math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).
							  
nearcharginstation(Facility):- 	
					lat(X0) & lon(Y0) 
					& chargingstation(Facility, X1,Y1) & not (shop(T1, X2,Y2) 
					& math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					  math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).							  
					  
mycorner(LATME, LONME, CLAT,CLON):- 
			corner(CLAT,CLON) &
			not  (corner(OLAT,OLON)  & 						
			  math.sqrt((CLAT-LATME)*(CLAT-LATME)+(CLON-LONME)*(CLON-LONME)) >
			  math.sqrt((OLAT-LATME)*(OLAT-LATME)+(OLON-LONME)*(OLON-LONME))
			).