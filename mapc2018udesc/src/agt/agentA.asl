{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("posicaoinicial.asl") }
{ include("gathering.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
{ include("job.asl") }
{ include("construcao_pocos.asl")}

ultimoCaminhaoAvisadoResourceNode( 23 ).
caminhoesAvisadosResourceNode( [] ).

+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
	.

	
+!buildPoligon : name(A) & A\== agentA10	
	<- true.

+!buildPoligon: name(agentA10)
	<-
		.wait(step(1));
		for(chargingStation(_,X,Y,_)) {
			addPoint(X,Y);
		}
		for(dump(_,X,Y)) {
			addPoint(X,Y);
		}
		for(shop(_,X,Y)) {
			addPoint(X,Y);
		}
		for(workshop(_,X,Y)) {
			addPoint(X,Y);
		}
		for(storage(_,X,Y,_,_,_)) {
			addPoint(X,Y);
		}
		buildPolygon;
		.print("Poligono pronto !!");
		!buildWell( wellType0, agentA10, 2, 9 );
	.



+!sendcentrals
	:	name(agentA20)
		
	<-	
		.wait( step(1));
		?centerStorage(STORAGE); 
		+storageCentral(STORAGE);
		.broadcast(tell, storageCentral(STORAGE) );
		
		 ?centerWorkshop(WORKSHOP);
		+workshopCentral(WORKSHOP);
		.broadcast(tell, workshopCentral(WORKSHOP) );
.

+!sendcentrals : name(A) & A\== agentA20	
	<- true.

+simStart: not started
					<-
					+started;
					!!craftSemParts;
					!!craftComParts;	
					.wait(name(_));				
					!!buildPoligon;
					!!sendcentrals;
					!!droneposition;
					.
					
+job(NOMEJOB,_,_,_,_,_)
	:
		role(motorcycle,_,_,_,_,_,_,_,_,_,_)
	<-
		!realizarJob( NOMEJOB );
	.

+todo(ACTION,PRIORITY): true
	<-
		!buscarTarefa;
	.

-todo(ACTION,_):true
<-
	-doing(ACTION);
	!buscarTarefa;
.

+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) &
			QUANTIDADE == 0 
	<-	
		true
	.
	
+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) &
			QUANTIDADE > 0
	<-	
		?priotodo(ACTION2);
		-+doing(ACTION2);
	.


@s1[atomic]
+step( _ ): not route([]) &lastDoing(Y) & doing(X) & Y==X
	<-
		//.print("1-rota em andamento e doing ",X);
		action( continue );
.

@s2[atomic]
+step( _ ): not route([]) &lastDoing(Y) & doing(X) & Y\==X & steps(X,[ACT|T])
	<-
		//.print("2-rota em andamento e doing ",X);
		-+lastDoing(X);	
		action( ACT);
		-steps(X,_);
		+steps(X,T);
.

@s3[atomic]
+step( _ )
	:	lastAction(randomFail)
	&	acaoValida( ACTION )
	<-	
		.print( "Fazendo de novo ", ACTION);
		action( ACTION );
	.

@s4[atomic]
+step(_)
	:	lastActionResult(successful_partial)
	&	acaoValida( ACTION )
	<-	.print("corigindo successful_partial");
		action( ACTION );
	.

@s5[atomic]
+step( _ )
	:	doing( help )
	&	steps(help, [ACT|T] )
	<-	
		action( ACT );
		-steps(help, _ );
		+steps(help, T );
		-+lastDoing( help );
		-+acaoValida(ACT);
	.

@s6[atomic]
+step(_)
	:	
	lastActionResult( X )&
		(X == failed_wrong_param | X == failed_unknown_agent |
			X == failed_counterpart | X == failed_tools |
			X ==failed_location
		)
	&	acaoValida( ACTION )
	<-	.print("corrigindo ", X);
		action( ACTION );
	.

@s7[atomic]
+step( _ )
	:	
		doing( buildWell )
		&	steps( buildWell, [] )
	<-	
		-todo( buildWell, _ );
		!buscarTarefa;
	.

@s8[atomic]
+step( _ )
	:	doing( buildWell )
	&	steps( buildWell, [ACT|T] )
	&	todo( buildWell, _ )
	<-	action( ACT );
		-steps( buildWell, _ );
		+steps( buildWell, T );
		-+acaoValida( ACT );
		-+lastDoing(buildWell);
	.

@s9[atomic]
+step( _ ): doing(exploration) &
			steps( exploration, [ACT|T])			
	<-
		//.print( "exploration: ", ACT);
		action( ACT );
		-steps(exploration, _);
		+steps(exploration, T);
		-+acaoValida( ACT );
		-+lastDoing(exploration);
	.

@s10[atomic]
+step( _ ): doing(help) & steps( help, [ACT|T])			
	<-	.print("help: ", ACT);
		action( ACT );
		-steps( help, _);
		+steps( help, T);
		-+acaoValida( ACT );
		-+lastDoing(help);
	.

@s11[atomic]
+step( _ ): doing(craftSemParts) & 
			steps( craftSemParts, [store(ITEM,QUANTIDADE)|T])
			& hasItem( ITEM, NOVAQUANTIDADE)	
	<-	
		action( store(ITEM,NOVAQUANTIDADE) );
		-steps( craftSemParts, _);
		+steps( craftSemParts, T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
		-+lastDoing(craftSemParts);
		.

@s12[atomic]
+step( _ ): doing(craftSemParts) &
			steps( craftSemParts, [ACT|T])			
	<-
		action( ACT );
		-steps( craftSemParts, _);
		+steps( craftSemParts, T);
		-+acaoValida( ACT );
		-+lastDoing(craftSemParts);
	.

@s13[atomic]
+step( _ ):
		doing(craftComParts) 
		& steps( craftComParts, [store(ITEM,QUANTIDADE)|T])
		& hasItem( ITEM, NOVAQUANTIDADE)
	<-	
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
		& storageCentral(STORAGE)
		& storagePossueItem( STORAGE, ITEM )
	<-
		?storage( STORAGE, _, _, _, _, LISTAITENS);
		.print( "Peguei: ", ITEM, ", Storage: ", STORAGE, ", LISTAITENS: ", LISTAITENS );
		action( retrieve( ITEM, 1 ) );
		.print("craftComParts: retrieve( ", ITEM, ", 1 )");
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		-+lastDoing(craftComParts);
		-+acaoValida( retrieve( ITEM, 1) );
	.

@s16[atomic]
+step( _ ):
		doing(craftComParts)
		& steps( craftComParts, [retrieve( ITEM, 1)|T])
	<-
		?storageCentral(STORAGE);
		?storage( STORAGE, _, _, _, _, LISTAITENS);
		action( noAction );
		.print( "Esperando: Storage: ", STORAGE, ", LISTAITENS: ", LISTAITENS );
		-+lastDoing(craftComParts);
		-+acaoValida( retrieve( ITEM, 1) );
	.

@s17[atomic]
+step( _ ): 
		doing(craftComParts)
		& steps( craftComParts, [ACT|T])
	<-
		?storage( STORAGE, _, _, _, _, LISTAITENS);
		.print( "Storage: ", STORAGE, ", LISTAITENS: ", LISTAITENS );
		.print( "craftComParts: ", ACT);
		action( ACT );
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		-+acaoValida( ACT );
		-+lastDoing(craftComParts);
	.

@s18[atomic]
+step( _ ):
		doing(recharge)
	&	steps( recharge, [ACT|T])			
	<-
		?route(ROTA);
//		.print("MINHA ROTA AGORA � ", ROTA, " !!!!!");
//		.print("estou no recharge steps");
		action( ACT );
		-steps( recharge, _);
		+steps( recharge, T);
		-+acaoValida( ACT );
		-+lastDoing(recharge);
	.

@s19[atomic]
+step( _ ): true
	<-
	
	action( noAction );
	.

