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
		//!buildstepsrecharge([goto(Facility)],STEPSRECHARGE,R);
		?repeat( charge, STEPSRECHARGE, [], R );
		-steps(recharge,_);
		+steps(recharge,[goto(Facility)|R]);
		+todo(recharge,10);
	.

//+!buildstepsrecharge(LS,QTD,R):QTD>0
//<-
//	.concat(LS,[charge],NLS);
//	!buildstepsrecharge(NLS,QTD-1,R);
//.
//
//+!buildstepsrecharge(LS,0,R):true
//<-
//	R=LS;
//.

+steps(recharge,[]):true
	<-
		-steps( recharge, []);
		-todo(recharge,_);
//		-timeRecharge(_);
	.

+charge(BAT):BAT==0
	<-
		.print("No battery.")
	.	
{ include("regras.asl") }