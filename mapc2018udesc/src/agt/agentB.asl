+!help(VEHICLE, WORKSHOP, PID):true
	<-true.

//+step(15): name(agentB10)
//	<-
//		action(goto(48.8978475,2.2718599999999998));
//	.
//	
//+step(25): name(agentB11)
//	<-
//		action(goto(48.8933875,2.4011925));
//	.
//	
+step( S): true
	<-
		action( noAction );
//				action( continue );
	.	
	
	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

