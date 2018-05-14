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

+todo(ACTION,PRIORITY): true
	<-
	?priotodo(ACTION);
	-+doing(ACTION);
	.

+step(30):true
	<-
	+todo(exploration,6);	
	.

{ include("charging.asl") }	
{ include("gathering.asl") }
{ include("posicaoinicial.asl") }		
{ include("regras.asl") }

+step( _ ): priotodo(ACTION)
	<-
		-+doing(ACTION);
	.
+step( _ ): true
	<-
	action( noAction );
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }