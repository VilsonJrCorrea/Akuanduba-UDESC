repeat(NNNR , QTD , L ,RR ) :- QTD> 0 & repeat(NNNR , QTD-1 , [NNNR|L] , RR). 						
repeat(NNNR , QTD , L ,L ).

+charge(BAT): not todo(recharge,_) &
	 		 lat(CURRENTLAT) & 
	 		 lon(CURRENTLON) &
	 		 calculatenearchargingstation(Facility,CURRENTLAT,CURRENTLON,X1,Y1,DISTANCE) &
			 distanciasemsteps(DISTANCE, NSTEPS ) &
			 BAT - 2*NSTEPS < 8
	<-
		!!recharge(CURRENTLAT,CURRENTLON);
	.
+!recharge (CURRENTLAT,CURRENTLON): 
			 calculatenearchargingstation(Facility,CURRENTLAT,CURRENTLON,X1,Y1,DISTANCE) 
		<-		
		?calculatehowmanystepsrecharge(Facility,STEPSRECHARGE);
		?repeat( charge, STEPSRECHARGE, [], R );
		-steps(recharge,_);
		+steps(recharge,[goto(Facility)|R]);
		+todo(recharge,10);
	.

+steps(recharge,[]):true
	<-
		-steps( recharge, []);
		-todo(recharge,_);
	.

+charge(BAT):BAT==0
	<-
		.print("No battery.")
	.	
{ include("regras.asl") }