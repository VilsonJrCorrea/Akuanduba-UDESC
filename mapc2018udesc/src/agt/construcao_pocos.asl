// Agent construcao_pocos in project mapc2018udesc

/* Initial beliefs and rules */

/* Initial goals */



/* Plans */

+step( X )
	: 	X = 2
	&	maxLat( LAT )
	&	maxLon( LON )
	&	name( agentA1 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	: 	X = 2
	&	minLat( LAT )
	&	maxLon( LON )
	&	name( agentA2 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	: 	X = 2
	&	minLat( LAT )
	&	minLon( LON )
	&	name( agentA3 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	: 	X = 2
	&	maxLat( LAT )
	&	minLon( LON )
	&	name( agentA4 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	:	X < 2
	<-	true
	.

+point( X, Y )
	:	role(drone,_,_,_,_,_,_,_,_,_,_)
	<-	action( goto( X, Y ) );
		+indo_poco;
	.

+step( _ )
	:	route( [] )
	&	indo_poco
	&	role(drone,_,_,_,_,_,_,_,_,_,_)
	<-	
		action( build( wellType0 ) );
		-point( _, _ );
		-indo_poco;
		+construindo_poco;
		.print( "build(well)" );
	.

+step( _ )
	:	poco_foi_construido
	<-	-construindo_poco;
		action( noAction );
	.

+step( _ )
	:	construindo_poco
	&	role(drone,_,_,_,_,_,_,_,_,_,_)
	<-	
		action( build );
		.print( "build" );
	.

+step( _ )
	: 	role(drone,_,_,_,_,_,_,_,_,_,_)
	<-	action( continue );
		.print( "continue" );
	.

//+!poco_foi_construido( B )
//	:	well( _,_,_,WELL,_,MV)
//	&	wellType( WELL,_,_,_, V)
//	<-	.print( WELL );
//		.print( V );
//		.print( MV );
//		B = (V == MV);
//		.print( B );
//	.
poco_foi_construido
	:-	well( _,_,_,WELL,_,MV)
	&	wellType( WELL,_,_,_, V)
	//well(well9732,48.89009,2.40846,wellType0,A,72)
	&	V == MV
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
