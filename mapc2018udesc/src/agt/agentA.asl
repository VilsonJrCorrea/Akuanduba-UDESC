+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
	.

+step( 0 ): name(agentA1)
	<-
		//.wait(100);
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
		for(chargingStation(_,X,Y,_)) {
			addPoint(X,Y);
		}
		for(storage(_,X,Y,_,_,_)) {
			addPoint(X,Y);
		}
		buildPolygon;
		getPolygon(X);
		.println("Poligono pronto !!");
		+X;
	.

//^!join_workspace(_,_,_) :true
//	<-
//	true;
//	.
//
//^!X[state(Y)] :true
//	<-
//	.print(X," - ",Y)
//.
//+step(10):true
//	<-
//	-doing(_);
//	action(goto(shop1));
//	.

//+step(30):true
//	<-
//	+doing(exploration);
//	.s

//{ include("construcao_pocos.asl")}
//{ include("charging.asl") }	
//{ include("gathering.asl") }
//{ include("posicaoinicial.asl") }		
//{ include("regras.asl") }

	
+step( _ ): not name( agentA2 )
	<-
	action( noAction );
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }