
+!buildWell
	:	maxLat( MLAT )
	&	maxLon( MLON )
	<-	getPoint( MLAT, MLON, R );
		!getCoordenadasPonto( R, PLAT, PLON );
		
	.

+!getCoordenadasPonto( R, LAN, LON )
	:	true
	<-	true
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
