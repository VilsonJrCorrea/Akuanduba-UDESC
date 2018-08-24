{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("exploration.asl") }
{ include("gathering.asl") }
//{ include("crafting2.asl") }
{ include("crafting.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
{ include("job.asl") }
<<<<<<< HEAD
{ include("mission.asl") }
=======
>>>>>>> master
{ include("construcao_pocos.asl")}
{ include("restartround.asl")}


@consume_steps[atomic]
+!consumestep: 
				lastActionResult( successful )			& 
				doing(LD)								& 
				steps(LD,[ACT|T])						&
				lastAction(RLA)							&
				route(ROUTE)							&
				RLA\==noAction							  						
	<-	
		if (RLA=continue | RLA=goto){
			if ( ROUTE==[]) {
				!refreshlastdoing(LD,T);
			}		
		}
		else {
			!refreshlastdoing(LD,T);
		} 
	.
<<<<<<< HEAD
+!consumestep: true
	<-true.
	
@at[atomic]
+!refreshlastdoing(LD,T) : true
=======

+simStart: not started
					<-
					+started;
					.wait(
						role(VEHICLE,_,_,_,_,_,_,_,_,_,_)
						& name(AGENT)
					);					
					.broadcast(tell,partners(VEHICLE,AGENT));
					!!craftSemParts;
					!!craftComParts;
					!!callCraftComPartsWithDelay										
					!!buildPoligon;
					!!sendcentrals;
					!!droneposition;
					.

+todo(ACTION,PRIORITY): true
>>>>>>> master
	<-
			if (T=[]) {
				!removetodo(LD);
			}
			else {
				-steps(LD,_);
				+steps(LD,T);
			}
	.

@remove_todo_doing_steps[atomic]
+!removetodo(LD):true
<-
	-todo(LD,_);
	-doing(LD);
	-steps(LD,_);
.

<<<<<<< HEAD
+!whattodo
	:	.count((todo(TD,_) & not waiting(TD,_)) , 0)
=======
+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) 	&
			QUANTIDADE == 0 & charge(BAT1) 	& 
			role(_,_,_,BAT2,_,_,_,_,_,_,_)	&
			BAT1<BAT2*0.9
	<-	
		?centerStorage(FS);
		?storage(FS,LAT,LON,_,_,_);
		!recharge (LAT,LON);
	.

+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) 	&
			QUANTIDADE == 0 & charge(BAT1) 	& 
			role(_,_,_,BAT2,_,_,_,_,_,_,_)	&
			BAT1>=BAT2*0.9
>>>>>>> master
	<-	
		-doing(_);
	.
	
+!whattodo
	:	.count((todo(TD,_) & not waiting(TD,_)), QUANTIDADE) &
			QUANTIDADE > 0
	<-			
		
		?priotodo(ACTION2);
		-+doing(ACTION2);
		!checkRollback;
	.

<<<<<<< HEAD
+!checkRollback:not route([]) 		&
				lastDoing(LD) 		& 
				doing(D) 			& 
				LD\==D 				& 
				steps(LD,L)			&
				LD=exploration	
	<-
			?lat(LAT);
			?lon(LON);
			-steps(LD, _ );
			+steps(LD, [goto(LAT,LON)| L]);
	.
	
+!checkRollback:lastDoing(LD) 	& 
				doing(D) 		& 
				LD\==D 			& 
				steps(LD,L)		&
				not job( JOB,_,_,_,_,_ ) 
	<-
		true.	

+!checkRollback:lastDoing(LD) 		& 
				doing(D) 			& 
				LD\==D 				& 
				steps(LD,L)			&
				LD\==exploration	&
				L=[HL|TL]			&
				not (HL=goto(_) |HL=goto(_,_)) 	
	<-
			?expectedplan( LD, EXPP);
			.length(EXPP,QTDEXPP);
			.length(L,QTDL);
			?rollbackcutexpectedrule(EXPP, QTDEXPP-QTDL, LDONED);
			.reverse(LDONED,RLDONED);
			?rollbackrule([goto(_),goto(_,_)], RLDONED, RACTION);			
			//.print("rollback ",LD,": ",[RACTION| L]);									
			-steps(LD, _ );
			+steps(LD, [RACTION| L]);
	.
=======
+!sendcentrals
	:	name(agentA20)
	<-	
		.wait( step(STEP) & STEP>0 );
		?centerStorageRule(STORAGE); 
		+centerStorage(STORAGE);
		 ?centerWorkshopRule(WORKSHOP);
		+centerWorkshop(WORKSHOP);
		.broadcast(tell, centerWorkshop(WORKSHOP) );
		.broadcast(tell, centerStorage(STORAGE) );
.

+!sendcentrals
	:
		name(A)
	&	A\== agentA20	
	<- true.
>>>>>>> master

+!checkRollback :true
	<- true .

@s1[atomic]
<<<<<<< HEAD
+!do: route(R) &lastDoing(X) & doing(X) & not R=[]
	<-	
		action(continue );
.

@s2[atomic]
+!do: 			not route([]) 		&
				lastDoing(Y) 		& 
				doing(X) 			& 
				Y\==X 				& 
				steps(X,[ACT|T])	& 
				steps(Y,L)			&
				Y=exploration	
	<-
			
			-+lastDoing(X);
    		action( ACT);
	. 

@docrafthelp[atomic]
+!do: doing(craftComParts) & steps( craftComParts, [help(OTHERROLES)|T]) 			
	<-
		.length(OTHERROLES,BARRIER);
		+waiting(craftComParts,BARRIER);
		!!supportCraft(OTHERROLES);
=======
+step( _ )
	:	not route([])
	&	lastDoing(Y)
	&	doing(X)
	&	Y==X
	<-
		//.print("rota em andamento e doing ",X);
		action( continue );
.

@s2[atomic]
+step( _ )
	:
		not route([])
	&	lastDoing(Y)
	&	doing(X)
	&	Y\==X
	&	steps(X,[ACT|T])
	&	steps(Y,L)
	&	acaoValida( LA )
	<-
		-+lastDoing(X);			
		-steps(X,_);
		+steps(X,T);
		 if (Y\==exploration) { 
		      .print(	"recuperando de uma troca de contexto ",
		      			Y," -> ", X," ( ",LA," )" ); 
		      if (LA=assemble(_) | LA=assist_assemble(_) ) { 
		        ?centerStorage(STORAGE); 
		        -steps(Y,_); 
		        +steps(Y,[goto(STORAGE)|[LA|L]]); 
		        .print("recuperando ultima acao valida: ---> ",steps(Y,[goto(STORAGE)|[LA|L]]));   
		      } 
		      if (LA=gather) { 
		        ?name(NAME); 
		        ?gatherCommitment(NAME,ITEM); 
		        ?resourceNode(_,LATRESOUR,LONRESOUR,ITEM); 
		        -steps(Y,_); 
		        +steps(Y,[goto(LATRESOUR,LONRESOUR)|[LA|L]]);   
		        .print("recuperando ultima acao valida: ---> ",steps(Y,[goto(LATRESOUR,LONRESOUR)|[LA|L]])); 
		      } 
		      if (LA=assist_assemble(_)) { 
		        ?centerWorkshop(WORKSHOP); 
		        ?workshop(WORKSHOP,LATW,LONW); 
		        -steps(Y,_); 
		        +steps(Y,[goto(LATW,LONW)|[LA]]);   
		        .print("recuperando ultima acao valida: ---> ",steps(Y,[goto(LATRESOUR,LONRESOUR)|[LA|L]]));     
		      } 
		      if (LA=goto(_) | LA=goto(_,_) ) {       
		        -steps(Y,_); 
		        +steps(Y,[LA|L]); 
		        .print("recuperando ultima acao valida: ",steps(Y,[LA|L])); 
		      } 	   
	    } 
    action( ACT ); 
. 

@s6[atomic]
+step(S)
	:	
	lastActionResult( X )&
		(	X == failed_wrong_param | X == failed_unknown_agent |
			X == failed_counterpart | X == failed_tools 		|
			X == failed_location  	| X == partial_success		| 
			X == successful_partial	| X == randomFail			|
			X == failed_item_amount
		)
	&	acaoValida( ACTION )
	&	doing( DOING )
	<-	
		if (X \== successful_partial	) {
			.print( "step ",S,": ",X, " repetindo ", ACTION, " em ", DOING );
		}
		action( ACTION );
	.

@s11[atomic]
+step( _ ): doing(craftSemParts) & 
			steps( craftSemParts, [store(ITEM,QUANTIDADE)|T])
			& hasItem( ITEM, NOVAQUANTIDADE)	
	<-	
//		.print( "Fazendo store em craftSemParts" );
		 action( store(ITEM,NOVAQUANTIDADE) );
		-steps( craftSemParts, _);
		+steps( craftSemParts, T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
		-+lastDoing(craftSemParts);
	.


@s13[atomic]
+step( _ ):
		doing(craftComParts) 
		& steps( craftComParts, [store(ITEM,QUANTIDADE)|T])
		& hasItem( ITEM, NOVAQUANTIDADE)
	<-	
//		.print( "Fazendo store em craftComParts" );
		action( store(ITEM,NOVAQUANTIDADE) );
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
		-+lastDoing(craftComParts);
	.

@s15[atomic]
+step( _ ):
		doing(craftComParts)
		& steps(craftComParts, [retrieve( ITEM, 1)|T])
		& centerStorage(STORAGE)
		& storagePossueItem( STORAGE, ITEM )
	<-
//		.print( "Fazendo retrieve em craftComParts" );
		action( retrieve( ITEM, 1 ) );
>>>>>>> master
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		action(noAction);
	.

@docrafthelp1[atomic]
+!do: doing(help) & steps( help, [ready_to_assist(WHONEED)|T]) 			
	<-
<<<<<<< HEAD
		.send(WHONEED, achieve, ready_to_assist);
		-steps( help, _);
		+steps( help, T);
=======
//		.print("aguardando item em craftComParts ",ITEM);
>>>>>>> master
		action( noAction );
	.


@s18[atomic]
+!do: 	step(S) &
		doing(DOING) & steps( DOING, [ACT|T])			
<<<<<<< HEAD
	<-		
=======
	<-
//		.print( "Doing generico ", ACT, " ", DOING );
		action( ACT );
		-steps( DOING, _);
		+steps( DOING, T);
		-+acaoValida( ACT );
>>>>>>> master
		-+lastDoing(DOING);
		action( ACT );
	.
	
+!do: true
	<-
//		.print( "noAction" );
		action( noAction  );
	.
	
@s19[atomic]
+step( S ): true
	<-
		!testarTrabalho;
		!testarMission;
		!consumestep;
		!whattodo;
		!do;
	.