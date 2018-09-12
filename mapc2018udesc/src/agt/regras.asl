repeat(TERM , QTD , L ,RR ) :- QTD> 0 & repeat(TERM , QTD-1 , [TERM|L] , RR). 						
repeat(TERM , QTD , L ,L ).

//rollbackcutexpectedrule([HEXPECTED|TEXPECTED], QTD, DONNED) :- 
//	QTD>0 & DONNED=[HEXPECTED|DON] & rollbackcutexpectedrule(TEXPECTED, QTD-1, DON).
//	
//rollbackcutexpectedrule(_, QTD, DONNED) :- 
//	QTD=0 & DONNED=[].
//
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


priotodo(TASK):- 	task(TASK,PRIO1,_,_)			&	 
					not waiting(TASK,_) 			& 					
					not  ( 	task(TASK2,PRIO2,_,_) 	& 
							not waiting(TASK2,_) 	& 
							PRIO2 > PRIO1).
							
//priotodo(ACTION):-   todo(ACTION,PRIO1) & not waiting(ACTION,_) & 
//            not (todo(ACT2,PRIO2) & not waiting(ACT2,_) & PRIO2 > PRIO1).

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

sumvolruleJOB([required(ITEM,QTD)|T],VOL):-	item(ITEM,V,_,_) 	& 
							((  T\==[] 							&
							  	sumvolruleJOB(T,VA)   			&
							  	VOL=V*QTD+VA)					|
							(	T=[]							&
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

//resourceNode(node6,48.8576,2.37992,item0)
nearResourceNodeWithItem( X1,Y1, X0, Y0, ITEM ):- 	
					resourceNode(RESOURCENODE,X1,Y1,ITEM) & not (resourceNode(_, X2, Y2, ITEM)
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

qtdItens( [], QTDATUAL, QTDTOTAL )
	:-
		QTDTOTAL=QTDATUAL
	.
qtdItens( [required(_,QTD)|T], QTDATUAL, QTDTOTAL )
	:-
		NQTD=QTDATUAL+QTD
	&	qtdItens( T, NQTD, QTDTOTAL)
	.

/**
 * Início da procura de todos os itens do job pra saber se estão no depósito.
 */

procurarItemSTORAGE( ITEM1, QTD1, [] )
	:-
		false
	.
	
procurarItemSTORAGE( ITEM1, QTD1, [item(ITEM2, QTD2, _)|T] )
	:-
		ITEM1 == ITEM2	&
		QTD2 >= QTD1
	.
	
procurarItemSTORAGE( ITEM1, QTD1, [item(ITEM2, QTD2, _)|T] )
	:-
		ITEM1 \== ITEM2	&
		procurarItemSTORAGE( ITEM1, QTD1, T )
	.
	
procurarTodosItens( [], ITENSSTORAGE)
	:-
		true
	.
	
procurarTodosItens( [required(ITEM1,QTD1)|T], ITENSSTORAGE )
:-
	procurarItemSTORAGE( ITEM1, QTD1, ITENSSTORAGE )	&
	procurarTodosItens(T, ITENSSTORAGE)
.	

/**
 * Fim da procura dos itens do Job no depósito.
 */

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


//******************************************************************************************

dependencia( [ required( ITEM, QTD ) | RESTO ], LISTA, RETORNO )
	:-
		item( ITEM, _, _, parts( PARTS ) )			&
		PARTS \== []								&
		.concat( LISTA, [ item( ITEM, QTD ) ], NR )	&
		dependencia( RESTO, LISTA, NR )
	.

dependencia( [], LISTA, RETORNO )
	:-
		RETORNO = LISTA
	.

separaritens( [ item( ITEM, QTD ) | RESTO ], LISTA, RETORNO )
	:-
		adicionariten( ITEM, QTD, LISTA, N_LISTA )	&
		separaritens( RESTO, LISTA, RETORNO )
	.

separaritens( [], LISTA, RETORNO )
	:-
		RETORNO = LISTA
	.

adicionariten( ITEM, QTD, [ item( ITEM, QTD2 ) | RESTO ], N_LISTA )
	:-
		true
	.


betterWell(WELL)
	:-
		wellType(WELL,CUSTO1,EFIC1,_,_) & 
		not (wellType(_,CUSTO2,EFIC2,_,_) &
		(CUSTO1/EFIC1)<(CUSTO2/EFIC2))
	.

/************************************************************************** */
lessqtt( LISTA, LABEL1 )
	:-
		item( LABEL1, _, roles( [] ), parts( [] ) )	&
		resourceNode( _,_,_,LABEL1)					&
		not .member( item( LABEL1, _, _ ), LISTA ).


lessqtt( LISTA, LABEL1 )
	:-
	item( LABEL1, _, roles( [] ), parts( [] ) )				&
	resourceNode( _,_,_,LABEL1)								&
	.member( item( LABEL1, QTD1, _ ), LISTA )				&
		not ( item( LABEL2, _, roles( [] ), parts( [] ) )	&
			resourceNode( _,_,_,LABEL2)						&
			.member( item( LABEL2, QTD2, _ ), LISTA ) 		&
			QTD2 < QTD1).
					
//lessqtt( LISTA, LABEL1 )
//	:-
//		LISTA=[] & item( LABEL1, _, roles( [] ), parts( [] ) )	&
//		resourceNode( _,_,_,LABEL1).

