+!help(VEHICLE, WORKSHOP, PID):true
	<-true.


+step(1): name(agentB10)
	<-
		action(goto(48.8424,2.3209));
	.
	
+step(2): name(agentB11)
	<-
		action(goto(48.8525,2.3310));
	.
	
+step(3): name(agentB12)
	<-
		action(goto(48.8626,2.3411));
	.
	
+step(10): name(agentB10)
	<-
		action( build(wellType0));
	.	
+step(20): name(agentB10)
	<-
		action( build(wellType0));
	.	
+step(30): name(agentB10)
	<-
		action( build(wellType0));
	.	

+step(11): name(agentB11)
	<-
		action( build(wellType0));
	.	
+step(21): name(agentB11)
	<-
		action( build(wellType0));
	.	
+step(31): name(agentB11)
	<-
		action( build(wellType0));
	.	
	
+step(13): name(agentB12)
	<-
		action( build(wellType0));
	.	
+step(23): name(agentB12)
	<-
		action( build(wellType0));
	.	
+step(33): name(agentB12)
	<-
		action( build(wellType0));
	.	

+step( S): true
	<-
//		action( noAction );
		action( continue );

	
	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

