
+!buildWell( WELLTYPE, AGENT, td, PRIORITY )
	:	maxLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.
	
+!buildWell( WELLTYPE, AGENT, te, PRIORITY )
	:	maxLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

+!buildWell( WELLTYPE, AGENT, bd, PRIORITY )
	:	minLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

+!buildWell( WELLTYPE, AGENT, be, PRIORITY )
	:	minLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

+!buildWell( WELLTYPE, AGENT, LAT, LON, PRIORITY )
	:	true
	<-	getPoint( LAT, LON, P );
		.print( P );
		!getCoordenadasPonto( P, PLAT, PLON );
		!qtdStep( WELLTYPE, AGENT, QTD );
		!buildWellSteps( [goto(PLAT, PLON), build(WELLTYPE)], QTD, R );
		+stepsBuildWell( R );
		+todo(buildWell, PRIORITY);
		//+todo(buildWell, PRIORITY, R );
		.print( "buildWell pronto!!" );
	.

+!getCoordenadasPonto( point( PLAT, PLON ), LAT, LON )
	:	true
	<-	LAT = PLAT;
		LON = PLON;
	.

+!qtdStep( WELLTYPE, AGENT, QTD )
	:	wellType(WELLTYPE,_,_,MIN,MAX)
	&	role(_,_,_,_,_,MINSKILL,MAXSKILL,_,_,_,_)
	<-	QTD = math.round( ( MAX-MIN )/MINSKILL );
		.print("WellType: ", WELLTYPE, ", MIN: ", MIN, ", MAX: ", MAX, ", QTD:", QTD, ", MINSKILL: ", MINSKILL);
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

+!voltarCentro
	:	centerLat( LAT )
	&	centerLon( LON )
	<-	+stepsVoltarCentro( [goto( LAT, LON )] );
		+todo( voltarCentro, 7);
		//+todo( voltarCentro, 8, [goto( LAT, LON )] );
		.print( "voltarCentro" );
	.
