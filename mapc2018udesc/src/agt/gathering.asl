

//+help(AGENT, H , F , PRIO): role(H,_,_,_,_,_,_,_,_,_,_)
//				<-
////				+stepsHelp( [goto(F) ]);
//				-+steps( help, )
//				+todo( help, PRIO);
//				+quemPrecisaAjuda( AGENT );
//				.

+!craftSemParts(NOME , ITEM)
	:	role(_,_,_,LOAD,_,_,_,_,_,_,_)
	&	item(ITEM,TAM,_,_)
	<-	
		.wait(resourceNode(NOME,LATRESOUR,LONRESOUR,ITEM));
		LIST = [goto(LATRESOUR, LONRESOUR)];
		QTD = math.floor( (LOAD / TAM) ) ;
		!repeat( [gather], QTD, [], R );
		.concat(LIST, R, NLIST);
		.wait(centerStorage(FS));
		+currentStorage(FS);
		.concat(NLIST, [goto(FS)] , NNLIST);
		.concat(NNLIST, [store(ITEM,_)] , NNNLIST);
		
//		-+stepsCraftSemParts(NNNLIST);
		-steps( craftSemParts, _ );
		+steps( craftSemParts, NNNLIST );
		+todo(craftSemParts,8);
	.

-doing(craftSemParts): steps(craftSemParts, ACTS) & acaoValida(ACT)
	<-
		-steps(craftSemParts, _ );
		+steps(craftSemParts, [ACT|ACTS]);
		.print("Removi a craftSemParts");
	.

+!craftComParts(ITEM, ROLE, OTHERROLE)
	:	
		role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)
	&	item( ITEM, TAM, roles(LROLES), parts(LPARTS) )
	&	storageCentral(STORAGE)
	&	workshopCentral(WORKSHOP)
	<-	
		.print("sou um " , ROLE , "e entrei no craftcomPARTS")
		PASSOS_1 = [callBuddies( ROLE, STORAGE, 7), goto(STORAGE)];
		!passosPegarItens(PASSOS_1, LPARTS, PASSOS_2);
		.concat( PASSOS_2, [goto(WORKSHOP), assemble(ITEM), 
			goto(STORAGE),store(ITEM,_) ], PASSOS_3 );
		.print( PASSOS_3 );
		
//		-+stepsCraftComParts( PASSOS_3 );
		-steps( craftComParts, _ );
		+steps( craftComParts, PASSOS_3 );
		+todo(craftComParts,8);	
	.

-doing(craftComParts): steps(craftComParts, ACTS) & lat(LAT) & lon(LON)
	<-
		-steps(craftComParts, _ );
		+steps(craftComParts, [goto(LAT,LON)|ACTS]);
		.print("Removi a craftComParts");
	.

+!passosPegarItens(LIST, [], LISTARETRIEVE)
	:	true
	<-	
		LISTARETRIEVE = LIST;
	.

+!passosPegarItens(LIST, [H|T], LISTARETRIEVE)
	:	true
	<-	
		.concat(LIST, [retrieve( H, 1)], NLIST);
		!passosPegarItens(NLIST,T,LISTARETRIEVE);
	.

+stepHelp( [] ): 	quemPrecisaAjuda(QUEM)
	<- 	//-todo(help, _); 
//		-stepsHelp([]);
		-steps( craftSemParts,[] );
		.send(QUEM, tell, cheguei);
		-quemPrecisaAjuda(QUEM);
	.

+steps( craftSemParts, [] ): 	true
	<- 	
//		-stepsCraftSemParts([]);
		-steps( craftSemParts, [] );
		-todo(craftSemParts, _);
		.print( "terminou craftsemPartes");
		//procura nova tarefa.
	.

+steps( craftComParts,[] ): 	true
	<- 	
		-steps( craftSemParts, []);
		-todo( craftSemParts, _);
		.print( "terminou craftComPartes");
		//procura nova tarefa.
	.

+!gatherParts([H|T] , LST , R ) :  true
								<-
								.wait(resourceNode( _ , LAT , LON , H ));
//								.print([H|T]);
								//concatena a acao de ir para o resource node e gather em seguida
								.concat(LST , [ goto(LAT , LON) , gather] , NLST);
								//chama recursivamente
//								.print(NLST);
								!gatherParts(T , NLST , R )
								.
								
+!gatherParts([] , LST , R): true
							<- 
//							.print("Entrou no gatherParts Vazio");
							R = LST.

//+!callBuddies([] , F , PRIO)
//	:
//		true
//	<-
//		.print("Entrou no callbuddies vazio");
//	.
				
+!callBuddies( ROLE, WORKSHOP, PRIO)[source(MEUNOME)]
	:
	
		name(QUEMPRECISA)
		&	buddieRole(NAME, ROLE)
		& QUEMPRECISA \== MEUNOME
	<-
		.print("Entrou no callbuddies");
		.send(NAME, achieve, help( QUEMPRECISA, ROLE, WORKSHOP, PRIO));
		
		//!callBuddies( T , F , PRIO);
	.

+!help( QUEMPRECISA, ROLE, WORKSHOP, PRIO)
	:
	entity(_,_,_,_,ROLE)
		<-
		+steps(help, [goto(WORKSHOP), assist_assemble(QUEMPRECISA)]);
		+todo(help, 6);
	.
	
+!repeat(NNNR , QTD , L ,RR ): QTD> 0
							<-
//							.print("Entrou no repeat");
							.concat(L , NNNR , NL );
//							.print(NL);
							!repeat(NNNR , QTD-1 , NL , RR);
							.
							
+!repeat(NNNR , O , L , RR ) : true
							<-
//							.print("Entrou no repeat vazio");
							RR = L
							.

//-doing(exploration): explorationsteps(ACTS) & lat(LAT) & lon(LON)
//	<-
//		-+explorationsteps([goto(LAT,LON)|ACTS]);
//	.
-doing(craftSemParts)
	:	steps(craftSemParts ,L)
	&	lat(LAT)
	&	lon(LON)
	& 	currentStorage(STORAGE)
	//&	acaoValida( ACTION )
	<-	
//		.print("ACTION: ", ACTION);
//		?stepsCraftSemParts( LIST );
//		.print( "1 ", LIST );
		-steps( craftSemParts, _);
		+steps( craftSemParts, [goto(STORAGE) | L]);
//		.print( "SLAT: ", SLAT, ", SLON: ", SLON );
//		?stepsCraftSemParts( LIST2 );
//		.print( "2 ",LIST2 );
	.
	
			
//+step( _ ): doing(craft) & 	stepsCraft([H | T]) & not route([])
//			<-
//			.print("Entrou no step(_)");
//			-+laststepcraft(H);
//			action(H);
//			-+stepsCraft(T);
//			.								
	