{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("posicaoinicial.asl") }
{ include("gathering.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
{ include("construcao_pocos.asl")}

ultimoCaminhaoAvisadoResourceNode( 23 ).
caminhoesAvisadosResourceNode( [] ).

+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		.print( "Nome ResourceNode: ", A);
//		buscarAgenteParaResourceNode( truck, NOMEAGENTE );
//		.send(NOMEAGENTE, achieve, craftSemParts( A, D));
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

+!informRole
	:
		true
	<-
	.wait(name(NAME)	&	role(ROLE,_,_,CAPACITY,_,_,_,_,_,_,_));
	.substring(NUMBER,NAME,7);
	.broadcast(tell, buddieRole(NAME, ROLE, CAPACITY, NUMBER));
//	cadastrarAgente( NAME, ROLE, CAPACITY);
		//.print("------------> se apresentando<---------")
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
	:	.count((todo(_,_)) , QUANTIDADE) &
			QUANTIDADE == 0 
	<-	
	
	.print("só entrou----------------------------------------");
	.
	
+!buscarTarefa
	:	.count((todo(_,_)) , QUANTIDADE) &
			QUANTIDADE > 0
	<-	
	
	.print("QUANTIDADE DE TODO ---------------------------- " , QUANTIDADE);
	for(todo(ACT,PRI)){
		
		.print("acao: " , ACT , " PRIORIDADE " , PRI);	
	}
	

		?priotodo(ACTION2);

		.print("Prioridade: ",ACTION2);
		-+doing(ACTION2);
	.


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
	&	name (agentA13)
	<-
		//item(item6,5,roles([motorcycle,truck]),parts([item4,item2,item0,item1,item3]))
		.print("chamando craftcomparts");
		//!ordemPegarItem( item6 , ROLE , OTHERROLE);
		!builditemlist;
		!craftComParts(item7);
.


//+step( X )
//	:	X = 3
//	&	name (agentA8)
//	<-
//		//item(item5,5,roles([drone,car]),parts([item4,item1]))
//		//item(item6,5,roles([motorcycle,truck]),parts([item4,item2,item0,item1,item3]))
//		.print("chamando craftcomparts");
//		//!ordemPegarItem( item10 , ROLE , OTHERROLE);
//		!craftComParts(item10, car, motorcycle);
//.

//+step( X )
//	:	X = 3
//	&	name (agentA21)
//	<-
//		//item(item5,5,roles([drone,car]),parts([item4,item1]))
//		.print("chamando craftcomparts");
//		//!ordemPegarItem( item5 , ROLE , OTHERROLE);
//		!craftComParts(item5, car, drone);
//.				

//+step( _ ): not route([]) /*&lastDoing(X) & doing(X) */
//	<-
//		.print("rota em andamento e doing ",X);
//		action( continue );
//.

@s1[atomic]
+step( _ ): not route([]) &lastDoing(Y) & doing(X) & Y==X
	<-
		.print("1-rota em andamento e doing ",X);
		action( continue );
.

@s2[atomic]
+step( _ ): not route([]) &lastDoing(Y) & doing(X) & Y\==X & steps(X,[ACT|T])
	<-
		.print("2-rota em andamento e doing ",X);
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
		//!!callBuddies( ROLE, WORKSHOP, PRIO);
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
		.print( "exploration: ", ACT);
		action( ACT );
		-steps(exploration, _);
		+steps(exploration, T);
		.print( ">>>>>>>>>>>>>> ACT: ", ACT, ", T: ", T);
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
		.print( "quantidade: ", NOVAQUANTIDADE, " ITEM: ", ITEM );
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
		.print( "craftSemParts: ", ACT);
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
		.print( "quantidade: ", NOVAQUANTIDADE, ", ITEM: ", ITEM );
		action( store(ITEM,NOVAQUANTIDADE) );
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		-+acaoValida( store(ITEM,NOVAQUANTIDADE) );
		-+lastDoing(craftComParts);
	.

@s14[atomic]
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

//+steps(craftComParts, [assemble(_)|_]):
//	true
//	<-.print("CHAMANDO SUPPORTCRAFT");
//		!supportCraft;
//	.

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
		.print("MINHA ROTA AGORA É ", ROTA, " !!!!!");
		.print("estou no recharge steps");
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

