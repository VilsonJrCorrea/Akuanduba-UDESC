{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("exploration.asl") }
{ include("gathering.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
//{ include("job.asl") }
{ include("construcao_pocos.asl")}

//+doing(X): step(S) & name(agentA1)
//	<-
//		.print( "step",S,": doing: ",X);
//	.
//-doing(X): step(S) & name(agentA1)
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

//testando uma abordagem de consumo de steps
@consume_steps[atomic]
+lastActionResult( successful ): 
				lastDoing(LD)							& 
				steps(LD,[ACT|T])						& 
				acaoValida( LA )						&
				lastAction(RLA)							&
				RLA\==continue							&
				(RLA\==noAction							|
				 (RLA==noAction & LA=help(OTHERROLE)))	
	<-
		if (T=[]) {
			-todo(LD,_);
			if (name(agentA1)) {
				.print("acabou ",LD, " --------------- ",RLA);	
			}
		}
		else {
			-steps(LD,_);
			+steps(LD,T);
			if (name(agentA1)) {
				.print("atualizou ",LD," -> ",LA, " = ",RLA, " agora ",T);	
			}	
		}
	.

@remove_todo_doing_steps[atomic]
-todo(ACTION,_):true
<-
//	if (name(agentA1)) {
//		.print("removeu doing e steps ",ACTION);
//	}
	-doing(ACTION);
	-steps(ACTION,_);
	!buscarTarefa;
.

@dispara_busca_tarefa[atomic]
+todo(ACTION,PRIORITY): true
	<-
		!buscarTarefa;
	.

//------------------------------------------

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
					.wait(role(VEHICLE,_,_,_,_,_,_,_,_,_,_) &
						name(AGENT));					
					.broadcast(tell,partners(VEHICLE,AGENT));
					!!craftSemParts;
					//!!callCraftComPartsWithDelay										
					!!buildPoligon;
					!!sendcentrals;
					!!droneposition;
					.



//+!buscarTarefa
//	:	.count((todo(_,_)) , QUANTIDADE) 	&
//			QUANTIDADE == 0 & charge(BAT1) 	& 
//			role(_,_,_,BAT2,_,_,_,_,_,_,_)	&
//			BAT1<BAT2*0.9
//	<-	
//		//.print("nada para fazer vou recarregar");
//		?centerStorage(FS);
//		?storage(FS,LAT,LON,_,_,_);
//		!recharge (LAT,LON);
//	.

+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) 	&
			QUANTIDADE == 0 
//			& charge(BAT1) 	& 
//			role(_,_,_,BAT2,_,_,_,_,_,_,_)	&
//			BAT1>=BAT2*0.9
	<-	
		.print("nada para fazer");
	.

	
+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) &
			QUANTIDADE > 0
	<-	
		?priotodo(ACTION2);
		-+doing(ACTION2);
		//.print ("troquei agora -> ",ACTION2);
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

+!sendcentrals : name(A) & A\== agentA20	
	<- true.


@s1[atomic]
+step( _ ): not route([]) &lastDoing(Y) & doing(X) & Y==X
	<-
//		if (name(agentA1)) {
//			.print("1-rota em andamento e doing ",X);	
//		}
		
		action( continue );
.

@s2[atomic]
+step( _ ): 	not route([]) 		&
				lastDoing(Y) 		& 
				doing(X) 			& 
				Y\==X 				& 
				steps(X,[ACT|T])	& 
				steps(Y,L)			&
				acaoValida( LA )	
	<-
//		if (name(agentA1)) {
//			.print("2-rota em andamento e doing ",X);
//		}
		-+lastDoing(X);			
		-steps(X,_);
		+steps(X,T);
    	action( ACT); 
. 

@s13[atomic]
+step( _ ):
		doing(craftComParts) 
		& steps( craftComParts, [store(ITEM,QUANTIDADE)|T])
		& hasItem( ITEM, NOVAQUANTIDADE)
	<-	
		action( store(ITEM,NOVAQUANTIDADE) );
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
		action( retrieve( ITEM, 1 ) );
		-+lastDoing(craftComParts);
		-+acaoValida( retrieve( ITEM, 1) );
	.
	
@gather3[atomic]
+step( _ ):
	doing(craftComParts)	&
	steps(craftComParts, [help(OTHERROLE)|T])
	<-	
		.print("CHAMANDO SUPPORTCRAFT");
		-+lastDoing(craftComParts);
		-+acaoValida( help(OTHERROLE) );
		!supportCraft(OTHERROLE);
		action(noAction);
	.

@s16[atomic]
+step( _ ):
		doing(craftComParts)
		& steps( craftComParts, [retrieve( ITEM, 1)|T])
		& not storagePossueItem( STORAGE, ITEM )
	<-
		action( noAction );
		-+lastDoing(craftComParts);
		-+acaoValida( noAction );
	.

//Doing generico
@s18[atomic]
+step( S ):
		doing(DOING) & steps( DOING, [ACT|T])			
	<-
//		if (name(agentA1)) {
//			.print (S," : ",steps( DOING, ACT));
//		}
		action( ACT );
		-+acaoValida( ACT );
		-+lastDoing(DOING);
	.


@s19[atomic]
+step( _ ): true
	<-
		action( noAction );
	.
