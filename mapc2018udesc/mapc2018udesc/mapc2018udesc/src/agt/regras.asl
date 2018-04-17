nearshop(Facility):- 	
					lat(X0) & lon(Y0) 
					& shop(Facility, X1,Y1) & not (shop(_, X2,Y2) 
					& math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).
							  
nearchargingstation(Facility):- 	
					lat(X0) & lon(Y0)
					&    chargingStation(Facility, X1,Y1,_) & 
					not (chargingStation(_, X2,Y2,_) & 
						 math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					  	 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).							  
					  
mycorner(LATME, LONME, CLAT,CLON):- 
			corner(CLAT,CLON) &
			not  (corner(OLAT,OLON)  & 						
			  math.sqrt((CLAT-LATME)*(CLAT-LATME)+(CLON-LONME)*(CLON-LONME)) >
			  math.sqrt((OLAT-LATME)*(OLAT-LATME)+(OLON-LONME)*(OLON-LONME))
			).
			
finddrone(LATC, LONC, AG):- 
			dronepos(AG,CLAT,CLON)[source(_)] &
			not  (dronepos(_,OLAT,OLON)[source(_)]  & 						
			  math.sqrt((CLAT-LATC)*(CLAT-LATC)+(CLON-LONC)*(CLON-LONC)) >
			  math.sqrt((OLAT-LATC)*(OLAT-LATC)+(OLON-LONC)*(OLON-LONC))
			).

/*
finddrones(LATC1, LONC1, AG1,LATC2, LONC2, AG2,
	      LATC3, LONC3, AG3,LATC4, LONC4, AG4):- 
			dronepos(AG1,CLAT1,CLON1)[source(_)] &
			dronepos(AG2,CLAT2,CLON2)[source(_)] &
			dronepos(AG3,CLAT3,CLON3)[source(_)] &
			dronepos(AG4,CLAT4,CLON4)[source(_)] & 
			AG1\==AG2 & AG1\==AG3 & AG1\==AG4 & AG2\==AG3 &
			AG2\==AG4 &  AG3\==AG4 &
			not  (dronepos(O1,OLAT1,OLON1)[source(_)]  &
				  dronepos(O2,OLAT2,OLON2)[source(_)]  &
				  dronepos(O3,OLAT3,OLON3)[source(_)]  &
				  dronepos(04,OLAT4,OLON4)[source(_)]  &
				  O1\==O2 & O1\==O3 & O1\==O4 & O2\==O3 &
				  O2\==O4 & O3\==O4 &
				 						
			  (math.sqrt((CLAT1-LATC1)*(CLAT1-LATC1)+(CLON1-LONC1)*(CLON1-LONC1))+ 
			  math.sqrt((CLAT2-LATC2)*(CLAT2-LATC2)+(CLON2-LONC2)*(CLON2-LONC2))+
			  math.sqrt((CLAT3-LATC3)*(CLAT3-LATC3)+(CLON3-LONC3)*(CLON3-LONC3))+
			  math.sqrt((CLAT4-LATC4)*(CLAT4-LATC4)+(CLON4-LONC4)*(CLON4-LONC4)))			  
			  >
			  (math.sqrt((OLAT1-LATC1)*(OLAT1-LATC1)+(OLON1-LONC1)*(OLON1-LONC1))+
			  math.sqrt((OLAT2-LATC2)*(OLAT2-LATC2)+(OLON2-LONC2)*(OLON2-LONC2))+
			  math.sqrt((OLAT3-LATC3)*(OLAT3-LATC3)+(OLON3-LONC3)*(OLON3-LONC3))+
			  math.sqrt((OLAT4-LATC4)*(OLAT4-LATC4)+(OLON4-LONC4)*(OLON4-LONC4)))
			). */
			
			
			