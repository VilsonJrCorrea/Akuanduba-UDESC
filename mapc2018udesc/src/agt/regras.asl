priotodo(ACTION):- 	todo(ACTION,PRIO1) & not (todo(ACT2,PRIO2)
					& PRIO2 > PRIO1).

nearshop(Facility):- 	
					lat(X0) & lon(Y0) 
					& shop(Facility, X1,Y1) & not (shop(_, X2,Y2) 
					& math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).
						
nearworkshop(Facility):- 	
					lat(X0) & lon(Y0) 
					& workshop(Facility, X1,Y1) & not (workshop(_, X2,Y2) 
					& math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).

//storage(storage0,48.8242,2.30026,10271,0,[])
nearstorage(Facility, X0, Y0):- 	
					/*lat(X0) & lon(Y0) &*/ 
					storage(Facility, X1,Y1,_,_,_) & not (storage(_, X2,Y2,_,_,_)
					& math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).

centerWorkshop(WORKSHOP)
	:-
		storageCentral(STORAGE)
	&	storage(STORAGE,X0,Y0,_,_,_)
	&	workshop(WORKSHOP, X1,Y1)
	&	not (workshop(_,X2,Y2) & 
			math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
			math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0)))
	.
					 							  
calculatenearchargingstation(Facility,X1,Y1):- 	
					lat(X0) & lon(Y0)
					&    chargingStation(Facility, X1,Y1,_) & 
					not (chargingStation(_, X2,Y2,_) & 
						 math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					  	 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).								  
					  
mycorner(LATME, LONME, CLAT,CLON):- 
			corner(CLAT,CLON) &
			not  (corner(OLAT,OLON)  & 						
			  math.sqrt((CLAT-LATME)*(CLAT-LATME)+(CLON-LONME)*(CLON-LONME)) >
			  math.sqrt((OLAT-LATME)*(OLAT-LATME)+(OLON-LONME)*(OLON-LONME))
			).
			
finddrone(LATC, LONC, AG):- 
			dronepos(AG,CLAT,CLON)[source(_)] &
			not  (dronepos(_,OLAT,OLON)[source(_)]  & 						
			  math.sqrt((CLAT-LATC)*(CLAT-LATC)+(CLON-LONC)*(CLON-LONC)) >
			  math.sqrt((OLAT-LATC)*(OLAT-LATC)+(OLON-LONC)*(OLON-LONC))
			).
			
+!calculatedistance( XA, YA, XB, YB, DISTANCIA )
	<- DISTANCIA =  math.sqrt((XA-XB)*(XA-XB)+(YA-YB)*(YA-YB)).
	
	

possoContinuar(STEPS,BAT,TESTE):-
	TESTE=(BAT>STEPS)
.	

centerStorage(Facility)
	:-
		centerLat(X0) &
		centerLon(Y0) & 
		//storage(storage0,48.8242,2.30026,10271,0,[])
		storage(Facility, X1,Y1,_ ,_ , _) & 
		not ( storage(_, X2,Y2,_ ,_ , _) & 
			math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
			math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).

storagePossueItem( STORAGE, ITEM )
	:-
		storage( STORAGE, _, _, _, _, LISTAITENS)
	&	.member( item(ITEM,_,_), LISTAITENS )
	.

calculatedistance( XA, YA, XB, YB, DISTANCIA )
					:- DISTANCIA =  math.sqrt((XA-XB)*(XA-XB)+(YA-YB)*(YA-YB)).

distanciasemsteps(DISTANCIA, NSTEPS ):-
					role(_,VELOCIDADE,_,_,_,_,_,_,_,_,_) &
					NSTEPS=math.ceil((DISTANCIA*111.12)/VELOCIDADE). 


calculatehowmanystepsrecharge(Facility,TEMPO):-
						role(_,_,_,BAT,_,_,_,_,_,_,_)&
						chargingStation(Facility,_,_,CAP)&
						TEMPO = math.ceil(BAT/CAP)
						.
						
coeficienterecarga(COEFICIENTE):-
				(role(drone,_,_,_,_,_,_,_,_,_,_)& COEFICIENTE=15)
				 |(not role(drone,_,_,_,_,_,_,_,_,_,_)& COEFICIENTE=15)
				.	