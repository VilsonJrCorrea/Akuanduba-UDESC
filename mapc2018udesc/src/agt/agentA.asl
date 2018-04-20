+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
	.

+step(_): name(agentA1)
	<-
		.wait(100);
		for(chargingStation(_,X,Y,_)) {
			addPoint(X,Y);
		}
		buildPolygon;
		getPolygon(X);
		.print(X);
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
+step(10):true
	<-
	-doing(_);
	action(goto(shop1));
	.

+step(30):true
	<-
	+doing(exploration);
	.


{ include("charging.asl") }	
{ include("gathering.asl") }
{ include("posicaoinicial.asl") }		
{ include("regras.asl") }

	
+step( _ ): true
	<-
	action( noAction );
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }