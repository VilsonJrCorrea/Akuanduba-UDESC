{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

ultimoCaminhaoAvisadoResourceNode( 23 ).

+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		.print( "Nome ResourceNode: ", A);
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
	.

+!buildPoligon: true
	<-
		.wait(100);
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
	.

{ include("construcao_pocos.asl")}
//{ include("charging.asl") }	
//{ include("gathering.asl") }
//{ include("posicaoinicial.asl") }		
//{ include("regras.asl") }

+simStart
	:	not started
	&	entity( AGENT,_,_,_,_)
//	&	name( agentA10 )
	&	AGENT == agentA10
	<-	+started;
		!buildPoligon;
//		!buildWell( wellType0, AGENT, 1, 9 );
		!buildWell( wellType1, AGENT, 2, 9 );
		//!voltarCentro;
	.

+todo(ACTION,PRIORITY): true
	<-
		!buscarTarefa;
	.

-todo(ACTION,_):true
<-
	-doing(ACTION);
.

+!buscarTarefa
	:	true
	<-	
//		for(todo(ACT,PRI)){
//			.print("ACT: ",ACT,", PRI: ",PRI);
//		}
		?priotodo(ACTION2);
//		for(doing(ACT)){
//			.print("ACT: ",ACT);
//		}
		.print("Prioridade: ",ACTION2);
		-+doing(ACTION2);
	.



{ include("gathering.asl") }
{ include("posicaoinicial.asl") }	
{ include("charging.asl") }		
{ include("regras.asl") }
//{ include("itens.asl") }
/*[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept) */
+resourceNode(NOME,B,C,ITEM)[source(SOURCE)]
	:	name(agentA23)
	&	ultimoCaminhaoAvisadoResourceNode( NUM )
	&	NUM <= 34
	&	SOURCE \== percept
		<-
//		.send(agentA24, achieve, craftSemParts(NOME));
		.concat( "agentA", NUM, NOMEAGENT );
		.send(NOMEAGENT, achieve, craftSemParts(NOME , ITEM));
		-+ultimoCaminhaoAvisadoResourceNode( NUM+1 );
		.print("NOME: ", NOME, ", NOMEAGENT: ", NOMEAGENT);
		.

+step( _ ): not route([]) 
	<-	.print("continue");
		action( continue );
	.

+step( _ )
	:	lastAction(randomFail)
	&	acaoValida( ACTION )
	<-	
		.print( "Fazendo de novo ", ACTION);
		action( ACTION );
	.

+step(_)
	:	lastActionResult(successful_partial)
	&	acaoValida( ACTION )
	<-	.print("corigindo partial_success");
		action( ACTION );
	.

+step( _ )
	:	doing( buildWell )
	&	stepsBuildWell( [] )
	<-	-todo( buildWell, _ );
		!buscarTarefa;
	.

+step( _ )
	:	doing( buildWell )
	&	stepsBuildWell( [H|T] )
	&	todo( buildWell, _ )
	<-	action( H );
		-+stepsBuildWell( T );
		
//		well(well8126,48.8296,2.39843,wellType1,a,65)
//		?well(WELLNAME,_,_,WELLTYPE,a,INTG);
//		.print( "WellName: ", WELLNAME, ", WellType: ", WELLTYPE, ", INTG: ", INTG );
		
//		role(car,3,5,50,150,8,12,400,800,40,80)
//		?role(_,_,_,_,_,MINSKILL,MAXSKILL,_,_,_,_);
//		.print( "MINSKILL: ", MINSKILL, ", MAXSKILL: ", MAXSKILL );
	.
	
+step( _ ): doing(exploration) &
			explorationsteps([ACT|T])			
	<-
		.print( "exploration: ", ACT);
		action( ACT );
		-+explorationsteps(T);
	.


+step( _ ): doing(craft) &	stepsCraft([callBuddies( ROLES , FACILITY , PRIORITY)|T])			
	<-
	//action(ACT);
	.print("craft: ", callBuddies);
	!!callBuddies( ROLES , FACILITY , PRIORITY);
	-+stepsCraft(T);
	.

+step( _ ): doing(help) & stepsHelp([ACT|T])			
	<-	.print("help: ", ACT);
		action( ACT );
		-+stepsHelp(T);
	.

//+step( _ ): doing(craftSemParts) & 
//			stepsCraftSemParts([store(ITEM,QUANTIDADE)|T])
//			& hasItem( ITEM, NOVAQUANTIDADE)
//			& lat(LATAG) & lon(LONAG) & currentStorage(STORAGE) &
//			//storage(storage2,48.86243,2.30345,9401,0,[])
//			storage(STORAGE , LATSTR , LONSTR , _ , _ )
//	<-
//		
//		.

+step( _ ): doing(craftSemParts) & 
			stepsCraftSemParts([store(ITEM,QUANTIDADE)|T])
			& hasItem( ITEM, NOVAQUANTIDADE)
			
	<-	
		
		.print( "quantidade: ", NOVAQUANTIDADE, " ITEM: ", ITEM );
		action( store(ITEM,NOVAQUANTIDADE) );
		-+stepsCraftSemParts(T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
	.



+step( _ ): doing(craftSemParts) &
			stepsCraftSemParts([ACT|T])			
	<-
		.print( "craftSemParts: ", ACT);
		action( ACT );
		-+stepsCraftSemParts(T);
		-+acaoValida( ACT );
	.
	
+step( _ ): doing(craft) & stepsCraft([ACT|T])			
	<-
		.print( "craft:", ACT);
		action( ACT );
		-+stepsCraft(T);
		-+acaoValida( ACT );
	.

+step( _ ): doing(recharge) &
			rechargesteps([ACT|T])			
	<-
		?route(ROTA);
		.print("MINHA ROTA AGORA É !!!!!",ROTA);
		.print("estou no recharge steps");
		action( ACT );
		-+rechargesteps(T);
	.

+step( _ ): priotodo(ACTION)
	<-
		.print( "priotodo:", ACTION);
		-+doing(ACTION);
	.
	
+step( _ ): true
	<-
	.print("noAction");
	action( noAction );
	.

