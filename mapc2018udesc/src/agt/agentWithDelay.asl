+!help(VEHICLE, WORKSHOP, PID):true
	<-true.

+step( S )
	:
		true
	<-
//		if( S > 119 ){
//			.wait( 1500 );
//		}
		action( noAction );
.
	
	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

