+charge(BAT):role(_,_,_,CAP,_,_,_,_,_,_,_) & BAT<((CAP/3)*2) & not todo(recharge,10)
	<-
		.print("calculando recarga");
		!calcular(STEPS);
	.

+!calcular(STEPS):true
	<-
		?charge(BAT);
		?lat(LATATUAL);
		?lon(LONATUAL);
		?calculatenearchargingstation(Facility,X1,Y1);
		!calculatehowmanystepsrecharge(Facility);
		-+nearchargingstation(Facility);
		!calculatedistance( LATATUAL, LONATUAL, X1, Y1, DISTANCIA );
		!calculatesteps(DISTANCIA,STEPS);
		.print(" STEPS CALCULADOS ",STEPS, " BAT ",BAT);
		!proximoPasso(STEPS,BAT);
	.

+!calculatesteps(DISTANCIA,STEPS):true
	<-
		?step(STEP);
		?role(_,VELOCIDADE,_,_,_,_,_,_,_,_,_);
		.wait( constante_folga(CONSTANTE) & minha_media_rota(MEDIAVEICULO));
		TAMANHOROTA=(DISTANCIA*VELOCIDADE)/MEDIAVEICULO;
		STEPSNECESSARIOS=(TAMANHOROTA/VELOCIDADE)+CONSTANTE;
		STEPS=math.round(STEPSNECESSARIOS)+1;	
	.
	
+!proximoPasso(STEPS,BAT):STEPS>=BAT
	<-
		?timerecharge(QTD);
		?nearchargingstation(Facility);
		.concat([goto(Facility),charge],LS);
		.print("Chamando o buildsteps recharge ",LS, " QTD ",QTD, " R ",R)
		!buildstepsrecharge(LS,QTD,R);
		-+rechargesteps(R);
		+todo(recharge,10);
	.
	
	
+!proximoPasso(STEPS,BAT):STEPS<BAT
	<-
		true
	.
	
	
+!buildstepsrecharge(LS,QTD,R):QTD>0
	<-
		.concat(LS,[charge],NLS);
		.print("----------------->",NLS,"<------------")	
		!buildstepsrecharge(NLS,QTD-1,R);
	.

+!buildstepsrecharge(LS,0,R):true
	<-
		R=LS;
	.

+rechargesteps([]):true
	<-
		-todo(recharge,_);
		-rechargesteps([]);
	    .print("removi o todo recharge <-- ");
	    for(todo(ACT,PRI)){
			.print(">< ",ACT," >< ",PRI);
		}	
	.
+!calculatehowmanystepsrecharge(Facility):true
	<-
		?chargingStation(Facility,_,_,CAP);
		?role(_,_,_,BAT,_,_,_,_,_,_,_);
		TEMPO = math.round(BAT/CAP);
		.print("CAPACIDADE RECARGA ",CAP," BATERIA ",BAT," TEMPO NECESSARIO ",TEMPO);		
		-+timerecharge(TEMPO);
	.

+charge(BAT):BAT==0
	<-
		.print("Acabou minha bateria.")
	.	
{ include("criteriosrecarga.asl") }
{ include("regras.asl") }