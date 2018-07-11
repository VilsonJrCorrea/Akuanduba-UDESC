
+charge(BAT): not todo(recharge,_) &
	 		 lat(CURRENTLAT) & 
	 		 lon(CURRENTLON) &
	 		 calculatenearchargingstation(Facility,CURRENTLAT,CURRENTLON,X1,Y1,DISTANCE) &
			 distanciasemsteps(DISTANCE, NSTEPS ) &
			 BAT - 2*NSTEPS < 8
	<-
		!!recharge (CURRENTLAT,CURRENTLON);
	.
	
+!recharge (LAT,LON)
	: calculatenearchargingstation(Facility,LAT,LON,X1,Y1,DISTANCE) 
	<-
		?calculatehowmanystepsrecharge(Facility,STEPSRECHARGE);
		//regra para repeticao
		?repeat( charge, STEPSRECHARGE, [], R );
		+steps(recharge,[goto(Facility)|R]);
		if (agentA1) {
			.print(R);	
		}		
		+todo(recharge,10);
	.	
+steps(recharge,[]):true
	<-
		-todo(recharge,_);
	.

+charge(BAT):BAT==0
	<-
		//.print("No battery.")
		true
	.	
{ include("regras.asl") }