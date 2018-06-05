{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

ultimoCaminhaoAvisadoResourceNode( 23 ).
caminhoesAvisadosResourceNode( [] ).

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
	:	
		name(agentA1)
	&	workshopCentral( WORKSHOP )
	<-	
		-+stepsTeste( [ goto( WORKSHOP ) ] );
		+todo(teste,4);	
		.

+simStart
	:	
	not started
	&	name(agentA10)
//	&	entity(agentA10,_,_,_,_)
//	&	AGENT == agentA10
	<-	
		.print("entrou ", agentA10);
		+started;
		!buildPoligon;
		!buildWell( wellType0, agentA10, 2, 9 );
	.

+simStart
	:	
		name(agentA20)
	<-	
		.wait( centerStorage(STORAGE) );
		+storageCentral(STORAGE);
		.broadcast(tell, storageCentral(STORAGE) );
		.print("Disse para tudo mundo que ", STORAGE, " e o central");
		
		.wait( centerWorkshop(WORKSHOP) );
		+workshopCentral(WORKSHOP);
		.broadcast(tell, workshopCentral(WORKSHOP) );
		.print("Disse para tudo mundo que ", WORKSHOP, " e o central");
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


+resourceNode(NOME,B,C,ITEM)[source(SOURCE)]
	:	name(agentA23)
	&	ultimoCaminhaoAvisadoResourceNode( NUM )
	&	NUM <= 34
	&	SOURCE \== percept
	<-
		.concat( "agentA", NUM, NOMEAGENT );
		.send(NOMEAGENT, achieve, craftSemParts(NOME , ITEM));
		-+ultimoCaminhaoAvisadoResourceNode( NUM+1 );
		.print("NOME: ", NOME, ", NOMEAGENT: ", NOMEAGENT);
	.

+step( X )
	:	X = 3
	&	name (agentA22)
	<-
		//item(item5,5,roles([drone,car]),parts([item4,item1]))
		!craftComParts(item5, car, drone);
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

+step( _ ): doing(help) & stepsHelp([ACT|T])			
	<-	.print("help: ", ACT);
		action( ACT );
		-+stepsHelp(T);
	.

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

+step( _ ):
		doing(craftComParts) 
		& stepsCraftComParts([store(ITEM,QUANTIDADE)|T])
		& hasItem( ITEM, NOVAQUANTIDADE)
	<-	
		.print( "quantidade: ", NOVAQUANTIDADE, ", ITEM: ", ITEM );
		action( store(ITEM,NOVAQUANTIDADE) );
		-+stepsCraftComParts(T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
	.

+step( _ ):
		doing(craftComParts)
		& stepsCraftComParts([callBuddies( ROLES , FACILITY , PRIORITY)|T])
	<-
		//action(ACT);
		.print("craftComParts: ", callBuddies);
		!!callBuddies( ROLES , FACILITY , PRIORITY);
		-+stepsCraftComParts(T);
	.

+step( _ ):
		doing(craftComParts)
		& stepsCraftComParts([retrieve( ITEM, 1)|T])
		& storageCentral(STORAGE)
		& storagePossueItem( STORAGE, ITEM )
	<-
		?storage( STORAGE, _, _, _, _, LISTAITENS);
		.print( "Peguei: ", ITEM, ", Storage: ", STORAGE, ", LISTAITENS: ", LISTAITENS );
		action( retrieve( ITEM, 1 ) );
		.print("craftComParts: retrieve( ", ITEM, ", 1 )");
		-+stepsCraftComParts(T);
	.

+step( _ ):
		doing(craftComParts)
		& stepsCraftComParts([retrieve( ITEM, 1)|T])
	<-
		?storageCentral(STORAGE);
		?storage( STORAGE, _, _, _, _, LISTAITENS);
		.print( "Esperando: Storage: ", STORAGE, ", LISTAITENS: ", LISTAITENS );
	.

+step( _ ): 
		doing(craftComParts)
		& stepsCraftComParts([ACT|T])
	<-
		?storage( STORAGE, _, _, _, _, LISTAITENS);
		.print( "Storage: ", STORAGE, ", LISTAITENS: ", LISTAITENS );
		.print( "craftComParts: ", ACT);
		action( ACT );
		-+stepsCraftComParts(T);
		-+acaoValida( ACT );
	.

+step( _ ):
		doing(recharge)
	&	rechargesteps([ACT|T])			
	<-
		?route(ROTA);
		.print("MINHA ROTA AGORA É ", ROTA, " !!!!!");
		.print("estou no recharge steps");
		action( ACT );
		-+rechargesteps(T);
	.

+step( _ ): priotodo(ACTION)
	<-
		.print( "priotodo:", ACTION);
		-+doing(ACTION);
	.

+step( _ ):
		doing(teste)
		& stepsTeste( [ H|T ] )
	<-	
		action( H );
		-+stepsTeste( T );
	.
+step( _ ): true
	<-
	.print("noAction");
	action( noAction );
	.

