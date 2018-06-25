+charge(BAT): not todo(recharge,_) &
	  lat(LATATUAL) & lon(LONATUAL)&
	  calculatenearchargingstation(Facility,LATATUAL,LONATUAL,X1,Y1,DISTANCIA) &
	  distanciasemsteps(DISTANCIA, NSTEPS ) &
//	  NSTEPS>=BAT 
	  BAT - 2*NSTEPS < 8
	<-
		?calculatehowmanystepsrecharge(Facility,TEMPO);
		!buildstepsrecharge([goto(Facility)],TEMPO,R);
		//-+rechargesteps(R);
		-steps(recharge,_);
		+steps(recharge,R);
		+todo(recharge,10);
	.


	
+!proximoPasso(STEPS,BAT):STEPS>=BAT
	<-
		?timerecharge(QTD);
		?nearchargingstation(Facility);
		.concat([goto(Facility),charge],LS);
		.print("Chamando o buildsteps recharge ",LS, " QTD ",QTD, " R ",R)
		!buildstepsrecharge(LS,QTD,R);
		-steps( recharge, _);
		+steps( recharge, R);
		+todo(recharge,10);
	.
	
	
+!proximoPasso(STEPS,BAT):STEPS<BAT
	<-
		true
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
		.print("Acabou minha bateria.")
	.	
{ include("criteriosrecarga.asl") }
{ include("regras.asl") }