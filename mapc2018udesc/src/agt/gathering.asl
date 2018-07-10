repeat(NNNR , QTD , L ,RR ) :- QTD> 0 & repeat(NNNR , QTD-1 , [NNNR|L] , RR). 						
repeat(NNNR , QTD , L ,L ).

+!craftSemParts	:	role(truck,_,_,LOAD,_,_,_,_,_,_,_) & name(NAMEAGENT) 
				& (.count(gatherCommitment(_,_))<.count(item(_,_,_,parts([]))))
	<-	
	
		?gogather(ITEM);
		addGatherCommitment(NAMEAGENT, ITEM);
		.wait(resourceNode(_,LATRESOUR,LONRESOUR,ITEM));
		?item(ITEM,TAM,_,_);
		LIST = [goto(LATRESOUR, LONRESOUR)];
		QTD = math.floor( (LOAD / TAM) ) ;
		
		?repeat( gather, QTD, [], R );
		.concat(LIST, R, NLIST);
		
		.wait(centerStorage(FS));
		.concat(NLIST, [goto(FS)] , NNLIST);
		.concat(NNLIST, [store(ITEM,QTD)] , NNNLIST);
		

		-steps( craftSemParts, _ );
		+steps( craftSemParts, NNNLIST );
		+todo(craftSemParts,8);
	.
	
+!craftSemParts	:(role(ROLE,_,_,_,_,_,_,_,_,_,_) & ROLE \== truck )|
		(.count(gatherCommitment(_,_))>=.count(item(_,_,_,parts([]))))
		<-	
		true;
		.

-!craftSemParts: true
	<-
		!!craftSemParts;
	.
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
+!callCraftComPartsWithDelay: true
	<-
		.wait(step(10));
		!!craftComParts;
	.

+!craftComParts:	
					role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  &
					ROLE\==truck & 
					name(NAMEAGENT) &
					(.count(craftCommitment(_,_))<.count(item(_,_,_,parts(P))&
														 P\==[])) &
					centerStorage(STORAGE) &	
					centerWorkshop(WORKSHOP)  							
				<-				
				?gocraft(ITEM,ROLE);
				addCraftCommitment(NAMEAGENT, ITEM);
				?item(ITEM,_,roles(LROLES),parts(LPARTS));
				.print (ROLE," Commit ",ITEM," ",LROLES,LPARTS);
				.difference(LROLES,[ROLE],[OTHERROLE|_]);
				PASSOS_1 = [goto(STORAGE)];
				!passosPegarItens(PASSOS_1, LPARTS, PASSOS_2);
				.concat( PASSOS_2, [goto(WORKSHOP), 
					help(OTHERROLE), 
					assemble(ITEM), goto(STORAGE),store(ITEM,1) ], PASSOS_3 );
				+steps( craftComParts, PASSOS_3 );
				+todo(craftComParts,8);	
				.

+!craftComParts	: role(truck,_,_,_,_,_,_,_,_,_,_)|
				  (.count(craftCommitment(_,_))>=.count(item(_,_,_,parts(P))& P\==[])) 
		<- true; .

-!craftComParts: true
	<-
		!!craftComParts;
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

@gather1[atomic]
+steps( craftSemParts, [] ): true
	<- 	
		-steps( craftSemParts, [] );
		-todo(craftSemParts, _);
		?name(ME);
		?gatherCommitment(ME,ITEM);
		?step(S);
		.print( "step",S,": terminou craftsemParts ", ITEM);
		//procura nova tarefa.
	.

@gather2[atomic]
+steps( craftComParts,[] ): true
	<- 	
		-steps( craftComParts, []);
		-todo( craftComParts, _);
		.print( "terminou craftComParts");
		//procura nova tarefa.
	.
	
@gather3[atomic]
+steps(craftComParts, [help(OTHERROLE)|T]):
	true
	<-.print("CHAMANDO SUPPORTCRAFT");
		!supportCraft(OTHERROLE);
		-steps(craftComParts, [help(OTHERROLE)|T]);
		+steps(craftComParts, T);
	.


//-doing(X): steps(X, ACTS) & acaoValida(ACT) & ACTS\==[] 
//	& .member(X,[craftSemParts,craftComParts])
//	<-
//		-steps(X, _ );
//		+steps(X, [ACT|ACTS]);
//	.


+!gatherParts([H|T] , LST , R ) :  true
	<-
		?resourceNode( _ , LAT , LON , H );
		.concat(LST , [ goto(LAT , LON) , gather] , NLST);
		!gatherParts(T , NLST , R )
		.
								
+!gatherParts([] , LST , R): true
	<-	R = LST.
							
////regra para selecionar o item que da pra fazer
//itemacraftar(LISTAPARTS , ROLE , OTHERROLE):- 
//			centerStorage(STORAGE) &
//			item(NOME,_,roles(LISTAROLES),LISTAPARTS) &
//			storage(STORAGE,_,_,_,_,[PARTSWEHAVE]) &
//			.member( LISTAPARTS , PARTSWEHAVE ) &
//			LISTAPARTS == [ROLE | OTHERROLE] &
//			.print("!@#!$@#%#$%@#$ITEM A CRAFTAR")
//			.

/* Adicionado */
+!supportCraft(OTHERROLE):
				name(WHONEED) & centerWorkshop(WORKSHOP)
			<-	
				 PID = math.floor(math.random(100000));
				//.broadcast (achieve, help(OTHERROLE, WORKSHOP, PID));
				for (partners(OTHERROLE,A) & 
					 not craftCommitment(A,_) &
					 not gatherCommitment(A,_)
				) {
					.send (A, achieve, help(WORKSHOP, PID));
				}				
				!!waitConfirmHelp;
			.
			
+!waitConfirmHelp: 	.count(helper(PID, COST)[source(_)],N) & N>2 &
					name(WHONEED) & centerWorkshop(WORKSHOP)
	<-
		?lesscost (PID, AGENT); //regra para achar o menor custo de helper(PID,COST)[source(_)]				
		.send (AGENT, achieve, confirmhelp( WORKSHOP, WHONEED));
		.abolish(helper(PID, _) );				
	.

-!waitConfirmHelp: true
	<-
		.wait(50);
		!!waitConfirmHelp;
	.

@help1[atomic]
+!help(WORKSHOP, PID)[source(AGENT)] : not todo(help, _)  & not lockhelp
	<-	
		+lockhelp;
		?lat(XA);
		?lon(YA);
		?workshop(WORKSHOP,XB,YB);
		?calculatedistance( XA, YA, XB, YB, COST );
		.send(AGENT, tell, helper(PID, COST));
	.

@help2[atomic]	
+!help( WORKSHOP, PID): todo(help, _) | lockhelp
	<-	true.

@help3[atomic]
+!confirmhelp(WORKSHOP, QUEMPRECISA):
	true
	<-
		-lockhelp;
		?role(ROLE,_,_,_,_,_,_,_,_,_,_);
		.print("Vou ajudar ",QUEMPRECISA, " e sou um ", ROLE );		
		+steps(help, [goto(WORKSHOP), assist_assemble(QUEMPRECISA) ]);
		+todo(help, 6);
	.

@help4[atomic]
+steps(help, []):
	true
	<-	.print("ACABOU O HELP");
		-doing(help);
		-steps(help, _);
	.