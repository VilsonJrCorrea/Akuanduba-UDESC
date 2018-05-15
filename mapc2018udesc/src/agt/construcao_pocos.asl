
+!buildWell( WELLTYPE, AGENT )
	:	maxLat( MLAT )
	&	maxLon( MLON )
	<-	.wait( 500 );
		getPoint( MLAT, MLON, P );
		!getCoordenadasPonto( P, PLAT, PLON );
		!qtdStep( WELLTYPE, AGENT, QTD );
		!buildWellSteps( [goto(PLAT, PLON), build(WELLTYPE)], QTD, R );
		+todo(buildWell);
		+stepsBuildWell( T );
		.print( "pronto" );
	.

+!getCoordenadasPonto( point( PLAT, PLON ), LAN, LON )
	:	true
	<-	LAT = PLAT;
		LON = PLON;
	.

+!buildWellSteps( LS, QTD, R )
	:	QTD > 0
	<-	.concat( LS, [build], NLS );
		!buildWellSteps( NLS, QTD-1, R );
	.

+!buildWellSteps( LS, 0, R )
	:	true
	<-	R = LS;
	.

+!qtdStep( WELLTYPE, AGENT, QTD )
	:	true
	<-	QTD = 3;
	.

+todo( buildWell )
	:	true
	<-	true
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
