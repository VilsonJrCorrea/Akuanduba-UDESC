+!help(VEHICLE, WORKSHOP, PID):true
	<-true.

+step( S): (laststep(LS) & not LS=S) |
			 (not laststep(LS))
	<-
		-+laststep(S);
		action( noAction );
	.	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }