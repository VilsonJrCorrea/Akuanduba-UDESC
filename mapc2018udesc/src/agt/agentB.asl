+!help(VEHICLE, WORKSHOP, PID):true
	<-true.

+step( S): true
	<-
		action( noAction );
	.	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }