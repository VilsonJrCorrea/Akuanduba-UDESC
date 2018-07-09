+!help(VEHICLE, WORKSHOP, PID):true
	<-true.

+step( _ ): true
	<-

	action( noAction );
	.	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }