+charge(BAT): not todo(recharge,10) &
  lat(LATATUAL) & lon(LONATUAL)&
  calculatenearchargingstation(Facility,X1,Y1) &
  calculatedistance( LATATUAL, LONATUAL, X1, Y1,DISTANCIA)&
  coeficienterecarga(COEFICIENTE)&
  distanciasemsteps(DISTANCIA*COEFICIENTE, NSTEPS ) &
  NSTEPS>=BAT &
  step(STEP) 
<-
.print(" ENTREI AQUI NO STEP ",STEP,
" bateria ", BAT, 
" Distancia em graus ", DISTANCIA ,
" COEFICIENTE ",COEFICIENTE,
" ESTACAO DE RECARGA MAIS PROXIMA ",Facility,
" steps calculados ", NSTEPS
);
?calculatehowmanystepsrecharge(Facility,TEMPO);
.concat([goto(Facility)],LS);
!buildstepsrecharge(LS,TEMPO,R);
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
	    .print("removi o todo recharge <-- ");
	    for(todo(ACT,PRI)){
			.print("1-ACT: ", ACT, ", PRI: ", PRI);
		}	
	.


+charge(BAT):BAT==0
	<-
		.print("Acabou minha bateria.")
	.	
{ include("criteriosrecarga.asl") }
{ include("regras.asl") }