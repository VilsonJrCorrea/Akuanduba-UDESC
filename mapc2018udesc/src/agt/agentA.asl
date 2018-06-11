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
		.wait(5000);
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

+!informRole
	:
		true
	<-
	.wait(name(NAME)
		&	role(ROLE,_,_,_,_,_,_,_,_,_,_));
		.broadcast(tell, buddieRole(NAME, ROLE));
		.print("------------> se apresentando<---------")
	.

+simStart
	:	
		name(agentA42)
	&	workshopCentral( WORKSHOP )
	<-	
		-steps( teste, _ );
		+steps( teste, [ goto( WORKSHOP ) ] );
		+todo(teste,4);	
		.

+simStart: not jaMeApresentei &
			not started 
					<-
					!informRole;
					+jaMeApresentei;
					.
+simStart
	:	
	not started
	&	name(agentA10)
//	&	AGENT == agentA10
	<-	
		.print("entrou ");
		
		!buildPoligon;
		+started;
		
	.
+started
	:	name(agentA10)
	<-
		.wait( 10000 );
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
	!buscarTarefa;
.

+!buscarTarefa
	:	true
	<-	
		for(todo(ACT,PRI)){
			.print("1-ACT: ", ACT, ", PRI: ", PRI);
		}
		?priotodo(ACTION2);
		for(todo(ACT, PRI)){
			.print("2-ACT: ", ACT, ", PRI: ", PRI);
		}
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
		.print("chamando craftcomparts");
		!craftComParts(item5, car, drone);
.

//+step( _ ): not route([]) /*&lastDoing(X) & doing(X) */
//	<-
//		.print("rota em andamento e doing ",X);
//		action( continue );
//.

+step( _ ): not route([]) &lastDoing(Y) & doing(X) & Y==X
	<-
		.print("1-rota em andamento e doing ",X);
		action( continue );
.

+step( _ ): not route([]) &lastDoing(Y) & doing(X) & Y\==X & steps(X,[ACT|T])
	<-
		.print("2-rota em andamento e doing ",X);
		-+lastDoing(X);	
		action( ACT);
		-steps(X,_);
		+steps(X,T);
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
	:	doing( help )
	&	steps(help, [ACT|T] )
	<-	
		action( ACT );
		-steps(help, _ );
		+steps(help, T );
		-+lastDoing( help );
		-+acaoValida(ACT);
	.
//+step(_)
//	:	(lastActionResult(failed_counterpart) | lastActionResult(failed_item_type) |lastActionResult(failed_tools) )
//	&	acaoValida( ACTION )
//	& 	not jaChamou
//	& 	entity(_,_,LAT,LON,drone)
//	& 	workshop(WORKSHOP,LAT,LON)
//	<-	.print("corrigindo failed_counterpart e chamando");
////		!!callBuddies( ROLE, WORKSHOP, PRIO);
//		action( ACTION );
//		+jaChamou
//	.


+step(_)
	:	(lastActionResult(failed_counterpart) | lastActionResult(failed_item_type) |lastActionResult(failed_tools) )
	&	acaoValida( ACTION )
	<-	.print("corrigindo failed_counterpart");
		!!callBuddies( ROLE, WORKSHOP, PRIO);
		action( ACTION );
	.

+step( _ )
	:	
		doing( buildWell )
		&	steps( buildWell, [] )
	<-	
		-todo( buildWell, _ );
		!buscarTarefa;
	.

+step( _ )
	:	doing( buildWell )
	&	steps( buildWell, [ACT|T] )
	&	todo( buildWell, _ )
	<-	action( ACT );
		-steps( buildWell, _ );
		+steps( buildWell, T );
		-+acaoValida( ACT );
		-+lastDoing(buildWell);
		
		
//		well(well8126,48.8296,2.39843,wellType1,a,65)
//		?well(WELLNAME,_,_,WELLTYPE,a,INTG);
//		.print( "WellName: ", WELLNAME, ", WellType: ", WELLTYPE, ", INTG: ", INTG );
		
//		role(car,3,5,50,150,8,12,400,800,40,80)
//		?role(_,_,_,_,_,MINSKILL,MAXSKILL,_,_,_,_);
//		.print( "MINSKILL: ", MINSKILL, ", MAXSKILL: ", MAXSKILL );
	.
	
+step( _ ): doing(exploration) &
			steps( exploration, [ACT|T])			
	<-
		.print( "exploration: ", ACT);
		action( ACT );
//		-+lastDoing(exploration , T);
		-steps(exploration, _);
		+steps(exploration, T);
		-+acaoValida( ACT );
		-+lastDoing(exploration);
	.

+step( _ ): doing(help) & steps( help, [ACT|T])			
	<-	.print("help: ", ACT);
		action( ACT );
		-steps( help, _);
		+steps( help, T);
		-+acaoValida( ACT );
		-+lastDoing(help);
	.

+step( _ ): doing(craftSemParts) & 
			steps( craftSemParts, [store(ITEM,QUANTIDADE)|T])
			& hasItem( ITEM, NOVAQUANTIDADE)	
	<-	
		.print( "quantidade: ", NOVAQUANTIDADE, " ITEM: ", ITEM );
		action( store(ITEM,NOVAQUANTIDADE) );
		-steps( craftSemParts, _);
		+steps( craftSemParts, T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
		-+lastDoing(craftSemParts);
		.

+step( _ ): doing(craftSemParts) &
			steps( craftSemParts, [ACT|T])			
	<-
		.print( "craftSemParts: ", ACT);
		action( ACT );
		-steps( craftSemParts, _);
		+steps( craftSemParts, T);
		-+acaoValida( ACT );
		-+lastDoing(craftSemParts);
	.

+step( _ ):
		doing(craftComParts) 
		& steps( craftComParts, [store(ITEM,QUANTIDADE)|T])
		& hasItem( ITEM, NOVAQUANTIDADE)
	<-	
		.print( "quantidade: ", NOVAQUANTIDADE, ", ITEM: ", ITEM );
		action( store(ITEM,NOVAQUANTIDADE) );
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
		-+lastDoing(craftComParts);
	.

+step( _ ):
		doing(craftComParts)
		& steps( craftComParts, [callBuddies( ROLES , FACILITY , PRIORITY)|T])
	<-
		.print("craftComParts: ", callBuddies);
		!!callBuddies( ROLES , FACILITY , PRIORITY);
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		-+lastDoing(craftComParts);
		-+acaoValida( callBuddies( ROLES , FACILITY , PRIORITY) );
	.

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

+step( _ ):
		doing(craftComParts)
		& steps( craftComParts, [retrieve( ITEM, 1)|T])
	<-
		?storageCentral(STORAGE);
		?storage( STORAGE, _, _, _, _, LISTAITENS);
		.print( "Esperando: Storage: ", STORAGE, ", LISTAITENS: ", LISTAITENS );
		-+lastDoing(craftComParts);
		-+acaoValida( retrieve( ITEM, 1) );
	.

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

+step( _ ):
		doing(recharge)
	&	steps( recharge, [ACT|T])			
	<-
		?route(ROTA);
		.print("MINHA ROTA AGORA É ", ROTA, " !!!!!");
		.print("estou no recharge steps");
		action( ACT );
		-steps( recharge, _);
		+steps( recharge, T);
		-+acaoValida( ACT );
		-+lastDoing(recharge);
	.

+step( _ ):
		doing(teste)
		& steps( teste, [ ACT|T ] )
	<-	
		action( ACT );
		-steps( teste, _ );
		+steps( teste, T );
		-+acaoValida( ACT );
		-+lastDoing(teste);
	.

//+step( _ ): true//priotodo(ACTION)
//	<-
////		.print( "priotodo2:", ACTION);
////		-+doing(ACTION);
//		!buscarTarefa;
//	.
+step( _ ): true
	<-
	.print("noAction");
	action( noAction );
	.

