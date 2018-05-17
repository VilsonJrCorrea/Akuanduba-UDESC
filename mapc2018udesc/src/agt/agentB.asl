
+step( _ ): true
	<-
	?maxLat( MAXLAT );
	?maxLon( MAXLON );
	action( goto(MAXLAT -(600/221140),MAXLON - (600/222640)) );
	.	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }