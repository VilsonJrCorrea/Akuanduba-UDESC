+charge(BAT): not todo(recharge,_) &
	 		 lat(CURRENTLAT) & 
	 		 lon(CURRENTLON) &
	 		 calculatenearchargingstation(Facility,CURRENTLAT,CURRENTLON,X1,Y1,DISTANCE) &
			 distanciasemsteps(DISTANCE, NSTEPS ) &
			 BAT - 2*NSTEPS < 8
	<-
		?calculatehowmanystepsrecharge(Facility,STEPSRECHARGE);
		?repeat( charge, STEPSRECHARGE, [], R );
		-steps(recharge,_);
		+steps(recharge,R);
		+todo(recharge,10);
	.

+steps(recharge,[]):true
	<-
		-todo(recharge,_);
	.

+charge(BAT):BAT==0
	<-
		.print("No battery.")
	.	
{ include("regras.asl") }