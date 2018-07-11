qsort( [], [] ).

qsort( [H|U], S ) :- splitBy(H, U, L, R)& qsort(L, SL)& qsort(R, SR)&
 .concat(SL, [H|SR], S).
 
splitBy( _, [], [], []).
splitBy( item(NH,VH,RH,PH), [item(NU,VU,RU,PU)|T], [item(NU,VU,RU,PU)|LS], RS )
		:- VU <= VH & splitBy(item(NH,VH,RH,PH), T, LS, RS).
		
		
splitBy(item(NH,VH,RH,PH), [item(NU,VU,RU,PU)|T], LS, [item(NU,VU,RU,PU)|RS] ) 
:- VU  > VH & splitBy(item(NH,VH,RH,PH), T, LS, RS).		


priotodo(ACTION):- 	todo(ACTION,PRIO1) & not (todo(ACT2,PRIO2)
					& PRIO2 > PRIO1).
					
gogather(ITEM):-item(ITEM,_,roles([]),_) & not gatherCommitment(AGENT,ITEM).
gocraft(ITEM,ROLE) :-item(ITEM,_,roles(R),_) & not craftCommitment(AGENT,ITEM)& .member(ROLE,R).

lesscost(PID, AGENT):-
	helper(PID, COST1)[source(AGENT)]
	&	(not (helper(PID, COST2)[source(AGENT2)]
	&	COST2 < COST1)).// | .count(helper(PID, _),1)).

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
					storage(Facility, X1,Y1,_,_,_) & not (storage(_, X2,Y2,_,_,_)
					& math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
					 math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0))).

centerWorkshopRule(WORKSHOP)
	:-
		centerStorage(STORAGE)
	&	storage(STORAGE,X0,Y0,_,_,_)
	&	workshop(WORKSHOP, X1,Y1)
	&	not (workshop(_,X2,Y2) & 
			math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0)) > 
			math.sqrt((X2-X0)*(X2-X0)+(Y2-Y0)*(Y2-Y0)))
	.
					 							  
calculatenearchargingstation(Facility,X0,Y0,X1,Y1,math.sqrt((X1-X0)*(X1-X0)+(Y1-Y0)*(Y1-Y0))):- 	
					chargingStation(Facility, X1,Y1,_) & 
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

possoContinuar(STEPS,BAT,TESTE):-
	TESTE=(BAT>STEPS)
.	

centerStorageRule(Facility)
	:-
		minLat(MILA) &
		minLon(MILO) &
		maxLat(MALA) &
		maxLon(MALO) &
		X0=(MILA+MALA)/2 &
		Y0=(MILO+MALO)/2 &
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
					NSTEPS=math.ceil((DISTANCIA*120)/VELOCIDADE).

calculatehowmanystepsrecharge(Facility,STEPSRECHARGE):-
						role(_,_,_,BAT,_,_,_,_,_,_,_)&
						chargingStation(Facility,_,_,CAP)&
						STEPSRECHARGE = math.ceil(BAT/CAP)

						.
