

//+help(AGENT, H , F , PRIO): role(H,_,_,_,_,_,_,_,_,_,_)
//				<-
////				+stepsHelp( [goto(F) ]);
//				-+steps( help, )
//				+todo( help, PRIO);
//				+quemPrecisaAjuda( AGENT );
//				.

+!craftSemParts	:	role(truck,_,_,LOAD,_,_,_,_,_,_,_) & name(NAMEAGENT) 
				& (.count(gathercommitment(_))<.count(item(_,_,_,parts([]))))
	<-	
		?gogather(ITEM);
		addGatherCommitment(NAMEAGENT, ITEM);
		.wait(resourceNode(_,LATRESOUR,LONRESOUR,ITEM));
		?item(ITEM,TAM,_,_);
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
	
+!craftSemParts	:(role(ROLE,_,_,_,_,_,_,_,_,_,_) & ROLE \== truck )|
		(.count(gathercommitment(_))>=.count(item(_,_,_,parts([]))))
		<-	
		true;
		.

-!craftSemParts: true
	<-
		!!craftSemParts;
	.

-doing(X): steps(X, ACTS) & acaoValida(ACT) 
	& .member(X,[craftSemParts,craftComParts])
	<-
		-steps(X, _ );
		+steps(X, [ACT|ACTS]);
		.print("Removi a ", X);
	.

//-doing(craftSemParts): steps(craftSemParts, ACTS) & acaoValida(ACT)
//	<-
//		-steps(craftSemParts, _ );
//		+steps(craftSemParts, [ACT|ACTS]);
//		.print("Removi a craftSemParts");
//	.

+!craftComParts(ITEM):	
					role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  &
					item( ITEM, TAM, roles(LROLES), parts(LPARTS) )&
					storageCentral(STORAGE)	&	
					workshopCentral(WORKSHOP)
									<-	
				.difference(LROLES,[ROLE],[OTHERROLE|_]);
				
				.print("sou um " , ROLE , " e preciso de ", OTHERROLE)
				PASSOS_1 = [goto(STORAGE)];
				!passosPegarItens(PASSOS_1, LPARTS, PASSOS_2);
				.concat( PASSOS_2, [goto(WORKSHOP), 
					help(OTHERROLE), /* Adicionado */
					assemble(ITEM), goto(STORAGE),store(ITEM,_) ], PASSOS_3 );
				.print( PASSOS_3 );		
				-steps( craftComParts, _ );
				+steps( craftComParts, PASSOS_3 );
				+todo(craftComParts,8);	
				.

//-doing(craftComParts): steps(craftComParts, ACTS) & lat(LAT) & lon(LON)
//	<-
//		-steps(craftComParts, _ );
//		+steps(craftComParts, [goto(LAT,LON)|ACTS]);
//		.print("Removi a craftComParts");
//	.
+!builditemlist : true
	<-
	LIST =[];
	+itemlist([]);
	
	for(item(X,Y,Z,H)){
		!additemlist(item(X,Y,Z,H));
//		LIST=[item(X,Y,Z,H)|LIST];
	}
	
	?itemlist(C);
	?qsort(C,SORTED);
	-+itemlist(SORTED);
	TE=(agentA1<agentA2);
	.print(TE);
	.

+!additemlist(H):itemlist(T)
<-
	-+itemlist([H|T]);
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

//+stepHelp( [] ): 	quemPrecisaAjuda(QUEM)
//	<- 	//-todo(help, _); 
////		-stepsHelp([]);
//		-steps( craftSemParts,[] );
//		.send(QUEM, tell, cheguei);
//		-quemPrecisaAjuda(QUEM);
//	.

+steps( craftSemParts, [] ): 	true
	<- 	
//		-stepsCraftSemParts([]);
		-steps( craftSemParts, [] );
		-todo(craftSemParts, _);
		.print( "terminou craftsemParts");
		//procura nova tarefa.
	.

+steps( craftComParts,[] ): 	true
	<- 	
		-steps( craftComParts, []);
		-todo( craftComParts, _);
		.print( "terminou craftComParts");
		//procura nova tarefa.
	.
	
/* Adicionado */
+steps(craftComParts, [help(OTHERROLE)|T]):
	true
	<-.print("CHAMANDO SUPPORTCRAFT");
		!supportCraft(OTHERROLE);
		-steps(craftComParts, [help(OTHERROLE)|T]);
		+steps(craftComParts, T);
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
							R = LST
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


	

	
	
//regra para selecionar o item que da pra fazer
itemacraftar(LISTAPARTS , ROLE , OTHERROLE):- 
			storageCentral(STORAGE) &
			item(NOME,_,roles(LISTAROLES),LISTAPARTS) &
			storage(STORAGE,_,_,_,_,[PARTSWEHAVE]) &
			.member( LISTAPARTS , PARTSWEHAVE ) &
			LISTAPARTS == [ROLE | OTHERROLE] &
			.print("!@#!$@#%#$%@#$ITEM A CRAFTAR")
			.

/* Adicionado */
+!supportCraft(OTHERROLE):
				name(WHONEED) & workshopCentral(WORKSHOP)
			<-	
				.print("%¨$%¨@#%@# name");
				.random(PID) ;
				.broadcast (achieve, help(OTHERROLE, WORKSHOP, PID));
				.wait(.count(helper(PID, COST)[source(_)],N) & N>3, 100);
				?lesscost (PID, AGENT); //regra para achar o menor custo de helper(PID,COST)[source(_)]
				.print("Agente escolhido: ", AGENT);
				.send (AGENT, achieve, confirmhelp( WORKSHOP, WHONEED));
				.abolish(helper(PID, _) );				
			.

//-!supportCraft:
//	name(WHONEED)
//	<-
//		.wait(.count(helper(PID, COST)[source(_)],N) & N>3, 100);
//		?lesscost (PID, AGENT); //regra para achar o menor custo de helper(PID,COST)[source(_)]
//		.send (AGENT, achieve, confirmhelp(WORKSHOP, WHONEED));
//		.abolish(helper(PID, _) );
//		
//	.
	
+doing(craftComParts):
	steps(craftComParts, [assemble|_])
	<-	
	.print("CHAMANDO SUPPORTCRAFT");
		!supportCraft;
	.


+!help(VEHICLE, WORKSHOP, PID)[source(AGENT)]:
	role(VEHICLE,_,_,_,_,_,_,_,_,_,_)
	& lat(XA)
	& lon(YA)
	& workshop(WORKSHOP,XB,YB)
	<-	
//		.print("PASSOU NO HELP");
		?calculatedistance( XA, YA, XB, YB, COST );
		.send(AGENT, tell, helper(PID, COST));
	.

+!confirmhelp(WORKSHOP, QUEMPRECISA):
	true
	<-
		?role(ROLE,_,_,_,_,_,_,_,_,_,_);
		.print("Vou ajudar ",QUEMPRECISA, " e sou um ", ROLE );
	
		+steps(help, [goto(WORKSHOP), assist_assemble(QUEMPRECISA) ]);
		+todo(help, 6);
	.
//------------------------------------------------------
+!ordemPegarItem( ITEM , ROLE , OTHERROLE)
	:
		item(ITEM,_,roles([H,T]),_)
	<-	
		!acharMaiorVolume( H, T , ROLE  , OTHERROLE);
		print("---------------------------------------------------->>>>>>>" , ROLE , " - " , OTHERROLE);
		
		.
+!acharMaiorVolume( H, T, ROLE , OTHERROLE):
					CAPACITY1 >= CAPACITY2
					<-
					ROLE = H;
					OTHERROLE = T;
					.
+!acharMaiorVolume( H, T, ROLE , OTHERROLE):
					CAPACITY1 <= CAPACITY2
					<-
					ROLE = T;
					OTHERROLE = H;
					.


	

//-doing(craftSemParts)
//	:	steps(craftSemParts ,L)
//	&	lat(LAT)
//	&	lon(LON)
//	& 	currentStorage(STORAGE)
//	//&	acaoValida( ACTION )
//	<-	
////		.print("ACTION: ", ACTION);
////		?stepsCraftSemParts( LIST );
////		.print( "1 ", LIST );
//		-steps( craftSemParts, _);
//		+steps( craftSemParts, [goto(STORAGE) | L]);
////		.print( "SLAT: ", SLAT, ", SLON: ", SLON );
////		?stepsCraftSemParts( LIST2 );
////		.print( "2 ",LIST2 );
//	.	

//+!callBuddies([] , F , PRIO)
//	:
//		true
//	<-
//		.print("Entrou no callbuddies vazio");
//	.
				
//+!callBuddies( ROLE, WORKSHOP, PRIO)//[source(MEUNOME)]
//	:
//		name(QUEMPRECISA)
//		&	buddieRole(NAME, ROLE, _)
////		& QUEMPRECISA \== MEUNOME
//	<-
//		.print("Entrou no callbuddies");
//		.print("Name: ", NAME, ", ROLE: ", ROLE);
//		.send(NAME, achieve, help( QUEMPRECISA, ROLE, WORKSHOP, PRIO));
////		.send(agentA10, achieve, help( QUEMPRECISA, ROLE, WORKSHOP, PRIO));
//		//!callBuddies( T , F , PRIO);
//	.

//+!help( QUEMPRECISA, ROLE, WORKSHOP, PRIO)
//	:
//	entity(_,_,_,_,ROLE)
//		<-
//		.print( "WORKSHOP: ", WORKSHOP );
//		+steps(help, [goto(WORKSHOP), assist_assemble(QUEMPRECISA)]);
//		+todo(help, 4);
//	.