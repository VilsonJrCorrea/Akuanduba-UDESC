
+!buildWell( WELLTYPE, AGENT )
	:	minLat( MLAT )
	&	maxLon( MLON )
	<-	getPoint( MLAT, MLON, P );
		!getCoordenadasPonto( P, PLAT, PLON );
		!qtdStep( WELLTYPE, AGENT, QTD );
		!buildWellSteps( [goto(PLAT, PLON), build(WELLTYPE)], QTD, R );
		!voltarCentro( R, NR );
		.print( NR );
		.print( "QTD: ", QTD );
		+stepsBuildWell( NR );
		+todo(buildWell, 9);
		.print( "buildWell pronto!!" );
	.

+!voltarCentro( R, NR )
	:	centerLat( LAT )
	&	centerLon( LON )
	<-	.concat( R, [goto( LAT, LON )], NR );
	.

+!getCoordenadasPonto( point( PLAT, PLON ), LAT, LON )
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
	:	wellType(WELLTYPE,_,_,MIN,MAX)
	<-	QTD = 5 + math.round( ( MAX-MIN-5 )/7 ) + 1;
		.print("WellType: ", WELLTYPE, ", MIN: ", MIN, ", MAX: ", MAX, ", QTD:", QTD);
	.

