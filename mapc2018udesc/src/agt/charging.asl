+charge(BAT):not task(recharge,_,_,_) &
	 		 lat(CURRENTLAT) & 
	 		 lon(CURRENTLON) &
	 		 calculatenearchargingstation(Facility,CURRENTLAT,CURRENTLON,X1,Y1,DISTANCE) &
			 distanciasemsteps(DISTANCE, NSTEPS ) &
			 ((role(drone,_,_,_,_,_,_,_,_,_,_) & BAT - 2*NSTEPS < 8)|
			 (not role(drone,_,_,_,_,_,_,_,_,_,_) & BAT - 2*NSTEPS < 11))
	<-
		!!recharge (CURRENTLAT,CURRENTLON);
	.

+!recharge (LAT,LON)
	: calculatenearchargingstation(Facility,LAT,LON,X1,Y1,DISTANCE) 
	<-
		?calculatehowmanystepsrecharge(Facility,STEPSRECHARGE);
		//regra para repeticao
		?repeat( charge, STEPSRECHARGE, [], R );
//		+steps(recharge,[goto(Facility)|R]);
//		+todo(recharge,10);

		!addtask(recharge,10,[goto(Facility)|R],[]);
	.	

+charge(BAT):BAT==0
	<-
		.print("No battery.")
//		true
	.	
