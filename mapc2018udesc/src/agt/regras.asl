repeat(TERM , QTD , L ,RR ) :- QTD> 0 & repeat(TERM , QTD-1 , [TERM|L] , RR). 						
repeat(TERM , QTD , L ,L ).

rollbackcutexpectedrule([HEXPECTED|TEXPECTED], QTD, DONNED) :- 
	QTD>0 & DONNED=[HEXPECTED|DON] & rollbackcutexpectedrule(TEXPECTED, QTD-1, DON).
	
rollbackcutexpectedrule(_, QTD, DONNED) :- 
	QTD=0 & DONNED=[].


rollbackrule(LISTWHATSEARCH, [HLISTSOURCE|TLISTSOURCE], ACTION) :-
	.member(HLISTSOURCE,LISTWHATSEARCH) & ACTION=HLISTSOURCE.

rollbackrule(LISTWHATSEARCH, [HLISTSOURCE|TLISTSOURCE], ACTION) :-
	not .member(HLISTSOURCE,LISTWHATSEARCH) & rollbackrule(LISTWHATSEARCH, TLISTSOURCE, ACTION).

minimumqtd([HLPARTS|TLPARTS],LSTORAGE) :- 
					(	.member(item(HLPARTS,QTD,_),LSTORAGE)	& 
						QTD>1									&
						minimumqtd (TLPARTS,LSTORAGE)).
minimumqtd([],LSTORAGE).

retrieveitensrule([], RETRIEVE, RETRIEVELIST) :- 
    RETRIEVELIST = RETRIEVE.
 
retrieveitensrule([H|T], RETRIEVE, RETRIEVELIST) :-
	 retrieveitensrule(T, [retrieve( H, 1)|RETRIEVE], RETRIEVELIST).


qsort( [], [] ).

qsort( [H|U], S ) :- splitBy(H, U, L, R)& qsort(L, SL)& qsort(R, SR)&
 .concat(SL, [H|SR], S).
 
splitBy( _, [], [], []).
splitBy( item(NH,VH,RH,PH), [item(NU,VU,RU,PU)|T], [item(NU,VU,RU,PU)|LS], RS )
		:- VU <= VH & splitBy(item(NH,VH,RH,PH), T, LS, RS).
		
		
splitBy(item(NH,VH,RH,PH), [item(NU,VU,RU,PU)|T], LS, [item(NU,VU,RU,PU)|RS] ) 
:- VU  > VH & splitBy(item(NH,VH,RH,PH), T, LS, RS).		


priotodo(ACTION):- 	todo(ACTION,PRIO1) & not waiting(ACTION,_) & 
						not (todo(ACT2,PRIO2) & not waiting(ACT2,_) & PRIO2 > PRIO1).
					
gogather(ITEM):-item(ITEM,_,roles([]),_) & not gatherCommitment(AGENT,ITEM).

gocraft(ITEM,ROLE,QTD) :-	item(ITEM,_,roles(R),_) 			&
							numberAgRequired(ITEM,QTD)			&	
							.count(craftCommitment(_,ITEM))<QTD &
							.member(ROLE,R).

sumvolrule([ITEM|T],VOL):-	item(ITEM,V,_,_) 			& 
							((  T\==[] 					&
							  	sumvolrule(T,VA)   		&
							  	VOL=V+VA)				|
							(	T=[]					&
								VOL=V)).			

sumvolruleJOB([required(ITEM,QTD)|T],VOL):-	item(ITEM,V,_,_) 			& 
							((  T\==[] 					&
							  	sumvolruleJOB(T,VA)   		&
							  	VOL=V*QTD+VA)				|
							(	T=[]					&
								VOL=QTD*V)).

lesscost(PID, AGENT):-
	helper(PID, COST1)[source(AGENT)]	&	
	not (helper(PID, COST2)[source(AGENT2)] & COST2 < COST1).

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
					  			
finddrone(LATC, LONC, AG):- 
			dronepos(AG,CLAT,CLON)[source(_)] &
			not  (dronepos(_,OLAT,OLON)[source(_)]  & 						
			  math.sqrt((CLAT-LATC)*(CLAT-LATC)+(CLON-LONC)*(CLON-LONC)) >
			  math.sqrt((OLAT-LATC)*(OLAT-LATC)+(OLON-LONC)*(OLON-LONC))
			).

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

calculatedistance( XA, YA, XB, YB, DISTANCIA )
					:- DISTANCIA =  math.sqrt((XA-XB)*(XA-XB)+(YA-YB)*(YA-YB)).

distanciasemsteps(DISTANCIA, NSTEPS ):-
					role(_,VELOCIDADE,_,_,_,_,_,_,_,_,_) &
					NSTEPS=math.ceil((DISTANCIA*120)/VELOCIDADE).

calculatehowmanystepsrecharge(Facility,STEPSRECHARGE):-
						role(_,_,_,BAT,_,_,_,_,_,_,_)&
						chargingStation(Facility,_,_,CAP)&
<<<<<<< HEAD
						STEPSRECHARGE = math.ceil(BAT/CAP).
						
possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO )
	:-
		job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
	&	centerStorage( STORAGE )
	&	storage( STORAGE, STORAGELAT, STORAGELON, _, _, _)
	&	storage( LOCALENTREGA, DESTINOLAT, DESTINOLON, _, _, _)
	&	lat( MEULAT )
	&	lon( MEULON )
	&	calculatedistance( MEULAT, MEULON, STORAGELAT, STORAGELON, DISTANCIASTORAGE )
	&	distanciasemsteps( DISTANCIASTORAGE, STEPSSTORAGE )
	&	calculatedistance( STORAGELAT, STORAGELON, DESTINOLAT, DESTINOLON, DISTANCIADESTINO )
	&	distanciasemsteps( DISTANCIADESTINO, STEPSDESTINO )
	&	qtdItens( ITENS, 0, NUMEROITENS )
	&	TEMPONECESSARIO = ( NUMEROITENS + STEPSDESTINO + STEPSSTORAGE + 10)
	.

possuoTempoParaRealizarMISSION( NOMEMISSION, TEMPONECESSARIO )
	:-
		mission(NOMEMISSION,LOCALENTREGA,_,STEPINICIAL,STEPFINAL,_,_,_,ITENS)
=======
						STEPSRECHARGE = math.ceil(BAT/CAP)
						.

possuoTempoParaRealizarJob( NOMEJOB, TAMANHOLISTAPASSOS )
	:-
//		true
		job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
>>>>>>> master
	&	centerStorage( STORAGE )
	&	storage( STORAGE, STORAGELAT, STORAGELON, _, _, _)
	&	storage( LOCALENTREGA, DESTINOLAT, DESTINOLON, _, _, _)
	&	lat( MEULAT )
	&	lon( MEULON )
	&	calculatedistance( MEULAT, MEULON, STORAGELAT, STORAGELON, DISTANCIASTORAGE )
<<<<<<< HEAD
	&	distanciasemsteps( DISTANCIASTORAGE, STEPSSTORAGE )
	&	calculatedistance( STORAGELAT, STORAGELON, DESTINOLAT, DESTINOLON, DISTANCIADESTINO )
	&	distanciasemsteps( DISTANCIADESTINO, STEPSDESTINO )
	&	qtdItens( ITENS, 0, NUMEROITENS )
	&	TEMPONECESSARIO = ( NUMEROITENS + STEPSDESTINO + STEPSSTORAGE + 10)
	.

qtdItens( [], QTDATUAL, QTDTOTAL )
	:-
		QTDTOTAL=QTDATUAL
	.
qtdItens( [required(_,QTD)|T], QTDATUAL, QTDTOTAL )
	:-
		NQTD=QTDATUAL+QTD
	&	qtdItens( T, NQTD, QTDTOTAL)
	.

temTodosItens( ITENS, ITENSSTORAGE )
	:-
		buscarNomesItensJOB( ITENS, [], NOMES )
	&	buscarNomesItensSTORAGE( ITENSSTORAGE, [], NOMESSTORAGE )
	&	.difference( NOMES, NOMESSTORAGE, DIFF )
	&	DIFF==[]
	.

buscarNomesItensJOB( [], LISTA, RETORNO )
	:-
		RETORNO=LISTA
	.

buscarNomesItensJOB( [required(ITEM,_)|T], LISTA, RETORNO )
	:-
		.concat( [ITEM], LISTA, N_LISTA )
	&	buscarNomesItensJOB( T, N_LISTA, RETORNO)
	.

buscarNomesItensSTORAGE( [], LISTA, RETORNO )
	:-
		RETORNO=LISTA
	.

buscarNomesItensSTORAGE( [item(ITEM,_,_)|T], LISTA, RETORNO )
	:-
		.concat( [ITEM], LISTA, N_LISTA )
	&	buscarNomesItensSTORAGE( T, N_LISTA, RETORNO)
	.

buildStore( L, R )
	:-
		hasItem( I, Q ) &
		not .member( store( I, Q ), L) &
//		.print( "1-I: ", I, ", Q: ", Q, ", L: ", L ) &
		buildStore( [store( I, Q ) | L ], R ).

buildStore( L, R )
	:-
//		not hasItem( I, Q ) &
//		.print( "2-I: ", I, ", Q: ", Q, ", L: ", L ) &
//		.member( store( I, Q ), L ) &
		R = L.

buscarItensDependentes( [], LISTA, RETORNO )
	:-
		.print( "[], LISTA: ", LISTA, ", RETORNO: ", RETORNO ) &
		RETORNO=LISTA
	.

buscarItensDependentes( [item(ITEM, _, _, parts( [] ) ) | RESTOS_DOS_ITENS ], LISTA, RETORNO )
	:-
		.print( "[], LISTA: ", LISTA, ", RETORNO: ", RETORNO ) &
		.concat( LISTA, [ retrieve( ITEM, 1) ], NLISTA ) &
		buscarItensDependentes( RESTOS_DOS_ITENS, LISTA, RETORNO )
		
	.

buscarItensDependentes( [item(ITEM, _, _, parts( SUBITENS ) ) | RESTOS_DOS_ITENS ], LISTA, RETORNO )
	:-
		buscarItensDependentes( SUBITENS, [], SUBRETORNO ) &
		buscarItensDependentes( RESTOS_DOS_ITENS, LISTA, RETORNO )
		
	.


=======
	&	calculatedistance( MEULAT, MEULON, DESTINOLAT, DESTINOLON, DISTANCIADESTINO )
	&	distanciasemsteps( DISTANCIASTORAGE, STEPSSTORAGE )
	&	distanciasemsteps( DISTANCIADESTINO, STEPSDESTINO )
	&	( STEPFINAL - STEPINICIAL ) > ( TAMANHOLISTAPASSOS + STEPSDESTINO + STEPSSTORAGE + 10)
	.

possoCarregarTudo( CAPACIDADE, VOLUMETOTAL )
	:-
		CAPACIDADE > VOLUMETOTAL
	.

>>>>>>> master
