
+charge(BAT): not todo(recharge,_) &
	 		 lat(CURRENTLAT) & 
	 		 lon(CURRENTLON) &
	 		 calculatenearchargingstation(Facility,CURRENTLAT,CURRENTLON,X1,Y1,DISTANCE) &
			 distanciasemsteps(DISTANCE, NSTEPS ) &
			 BAT - 2*NSTEPS < 8
	<-
		!!recharge (CURRENTLAT,CURRENTLON);
	.
@inicia_todo_recharge[atomic]	
+!recharge (LAT,LON)
	: calculatenearchargingstation(Facility,LAT,LON,X1,Y1,DISTANCE) 
	<-
		?calculatehowmanystepsrecharge(Facility,STEPSRECHARGE);
		//regra para repeticao
		?repeat( charge, STEPSRECHARGE, [], R );
		+steps(recharge,[goto(Facility)|R]);
		if (name(agentA2)) {
			.print("criou ->",steps(recharge,[goto(Facility)|R]));	
		}		
		+todo(recharge,10);
	.	

+charge(BAT):BAT==0
	<-
		//.print("No battery.")
		true
	.	
{ include("regras.asl") }