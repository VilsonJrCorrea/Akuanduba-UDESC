{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("posicaoinicial.asl") }
{ include("gathering.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
{ include("job.asl") }
{ include("construcao_pocos.asl")}

//+doing(X): step(S)
//	<-
//		.print( "step",S,": doing: ",X);
//	.
//-doing(X): step(S)
//	<-
//		.print( "step",S,": stop doing: ",X);
//	.

//depuracao das falhas
//+lastActionResult( X ) :
//	lastAction(ACTION)		&
//	lastActionParams(PA)	&
//	step(S) 				&
//	ACTION=assist_assemble
//	//acaoValida( ACTION )
//	<-	
//			.print( "Depuracao step",S,": ",X, " acao ", ACTION,PA );
//	.

//depuracao das falhas
+lastAction(ACTION):
	lastActionResult( X )	&
	lastActionParams(PA)	&
	step(S) 				&
	ACTION=assist_assemble
	<-	
			.print( "Depuracao step",S,": ",X, " acao ", ACTION,PA );
	.


+lastActionResult( failed_capacity ) :
		lastdoing(LD)
	<-
		.print (LD, " failed_capacity")
	. 	

+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
	.

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
	<-
		!buscarTarefa;
	.

-todo(ACTION,_):true
<-
	-doing(ACTION);
	-steps(ACTION,_);
	!buscarTarefa;
.

+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) 	&
			QUANTIDADE == 0 & charge(BAT1) 	& 
			role(_,_,_,BAT2,_,_,_,_,_,_,_)	&
			BAT1<BAT2*0.9
	<-	
		//.print("nada para fazer vou recarregar");
		?centerStorage(FS);
		?storage(FS,LAT,LON,_,_,_);
		!recharge (LAT,LON);
	.

+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) 	&
			QUANTIDADE == 0 & charge(BAT1) 	& 
			role(_,_,_,BAT2,_,_,_,_,_,_,_)	&
			BAT1>=BAT2*0.9
	<-	
		.print("nada para fazer");
	.

	
+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) &
			QUANTIDADE > 0
	<-	
		?priotodo(ACTION2);
		-+doing(ACTION2);
	.

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


@s1[atomic]
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
		.print( "Fazendo store em craftSemParts" );
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
		.print( "Fazendo store em craftComParts" );
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
		.print( "Fazendo retrieve em craftComParts" );
		action( retrieve( ITEM, 1 ) );
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		-+lastDoing(craftComParts);
		-+acaoValida( retrieve( ITEM, 1) );
	.

@s16[atomic]
+step( _ ):
		doing(craftComParts)
		& steps( craftComParts, [retrieve( ITEM, 1)|T])
		& not storagePossueItem( STORAGE, ITEM )
	<-
		.print("aguardando item em craftComParts ",ITEM);
		action( noAction );
		-+lastDoing(craftComParts);
		-+acaoValida( noAction );
	.

//Doing generico
@s18[atomic]
+step( _ ):
		doing(DOING) & steps( DOING, [ACT|T])			
	<-
		.print( "Doing generico ", ACT, " ", DOING );
		action( ACT );
		-steps( DOING, _);
		+steps( DOING, T);
		-+acaoValida( ACT );
		-+lastDoing(DOING);
	.


@s19[atomic]
+step( _ ): true
	<-
//		.print( "noAction" );
		action( noAction  );
	.
