{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
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

+!buscarTarefa
	:	true
	<-	for(todo(ACT,PRI)){
			.print("ACT: ",ACT,", PRI: ",PRI);
		}
		?priotodo(ACTION2);
		for(doing(ACT)){
			.print("ACT: ",ACT);
		}
		.print("Prioridade: ",ACTION2);
		-+doing(ACTION2);
	.

-todo(ACTION,_):true
<-
	-doing(ACTION);
.

{ include("charging.asl") }	
{ include("gathering.asl") }
{ include("posicaoinicial.asl") }		
{ include("regras.asl") }

+step( _ ): not route([]) 
	<-
		action( continue );
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
		.print("estou no exploration steps");
		action( ACT );
		-+explorationsteps(T);
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

+step( _ )
	:	doing( voltarCentro )
	&	stepsVoltarCentro( [] )
	<-	-todo( voltarCentro, _ );
		!buscarTarefa;
	.

+step( _ )
	:	doing( voltarCentro )
	&	stepsVoltarCentro( [H|T] )
	<-	action( H );
		-+stepsVoltarCentro( T );
		.print("voltando ao centro");
	.

+step( _ ): priotodo(ACTION)
	<-
		-+doing(ACTION);
	.
+step( _ ): true
	<-
	action( noAction );
	.
