+charge(BAT): not todo(recharge,_) &
	 		 lat(CURRENTLAT) & 
	 		 lon(CURRENTLON) &
	 		 calculatenearchargingstation(Facility,CURRENTLAT,CURRENTLON,X1,Y1,DISTANCE) &
			 distanciasemsteps(DISTANCE, NSTEPS ) &
			 BAT - 2*NSTEPS < 8
	<-
		?calculatehowmanystepsrecharge(Facility,STEPSRECHARGE);
		!buildstepsrecharge([goto(Facility)],STEPSRECHARGE,R);
		-steps(recharge,_);
		+steps(recharge,R);
		+todo(recharge,10);
	.

+!buildstepsrecharge(LS,QTD,R):QTD>0
<-
	.concat(LS,[charge],NLS);
	!buildstepsrecharge(NLS,QTD-1,R);
.

+!buildstepsrecharge(LS,0,R):true
<-
	R=LS;
.

+steps(recharge,[]):true
	<-
		-todo(recharge,_);
		-timeRecharge(_);
		-steps( recharge, []);
	.

+charge(BAT):BAT==0
	<-
		.print("No battery.")
	.	
{ include("regras.asl") }