+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
	.
+resourceNode(A,B,C,D)[source(percept)]:true
	<-true.
	
{ include("cantomaisproximo.asl") }	
{ include("regras.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }