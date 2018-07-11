+!craftSemParts	:	role(truck,_,_,LOAD,_,_,_,_,_,_,_) 							  & 
					name(NAMEAGENT)					   							  & 
					(.count(gatherCommitment(_,_))<.count(item(_,_,_,parts([])))) &
				    not craftCommitment(NAMEAGENT,_)							  &
					not gatherCommitment(NAMEAGENT,_)
				
	<-	
	
		?gogather(ITEM);
		addGatherCommitment(NAMEAGENT, ITEM);
		.wait(resourceNode(_,LATRESOUR,LONRESOUR,ITEM));
		?item(ITEM,TAM,_,_);
		QTD = math.floor( (LOAD / TAM) ) ;		
		?repeat( gather, QTD, [], GATHERS );
		.wait(centerStorage(FS));
		.concat([goto(LATRESOUR, LONRESOUR)],GATHERS,[goto(FS),store(ITEM,QTD)],PLAN)
		+steps( craftSemParts, PLAN);
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
					role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  							&
					ROLE\==drone 												& 
					name(NAMEAGENT) 											&
					(.count(craftCommitment(_,_))<.count(item(_,_,_,parts(P))	&
														 P\==[])) 				&
					centerStorage(STORAGE) 										&	
					centerWorkshop(WORKSHOP) 									&
					not craftCommitment(NAMEAGENT,_) 							&
					not gatherCommitment(NAMEAGENT,_)
					 							
				<-				
				?gocraft(ITEM,ROLE);
				addCraftCommitment(NAMEAGENT, ITEM);				
				?item(ITEM,_,roles(LROLES),parts(LPARTS));				
				.difference(LROLES,[ROLE],[OTHERROLE|_]);								
				?retrieveitensrule(LPARTS, [], RETRIEVELIST);				
				.concat( [goto(STORAGE)], RETRIEVELIST, 
						 [goto(WORKSHOP), help(OTHERROLE), 
						  assemble(ITEM), goto(STORAGE),
			   			  store(ITEM,1) ],
						PLAN);
				+steps( craftComParts, PLAN);
				+todo(craftComParts,8);	
				.

+!craftComParts	: role(drone,_,_,_,_,_,_,_,_,_,_)|
				  (.count(craftCommitment(_,_))>=.count(item(_,_,_,parts(P))& P\==[])) 
		<- true; .

-!craftComParts: true
	<-
		!!craftComParts;
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
//					.print(	"preciso da ajuda de um ",OTHERROLE,
//							" agente ",A, " me ajude");
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

+lastActionResult( successful ) :	
	doing(help)						&	
	steps(help, [])					
	<-	
		-todo(help)
	.

@help4[atomic]
-todo(help, _):
	step(S)				
	<-	.print("STEP",S,"ACABOU O HELP");
	.	