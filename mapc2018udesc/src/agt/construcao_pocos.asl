+!validar( R )
	: 	true
	<-	?well( _,_,_,WELL,_,MV);
	//	well(well9732,48.89009,2.40846,wellType0,A,72)
		?wellType( WELL,_,_,_, V);
	//	wellType(wellType0,600,4,36,73)
		if( V == MV ){
			R = true;
		}else{
			R = false;
		}
	.

+step( X )
	: 	X = 1
	&	maxLat( LAT )
	&	maxLon( LON )
	&	name( agentA1 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	: 	X = 1
	&	minLat( LAT )
	&	maxLon( LON )
	&	name( agentA2 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	: 	X = 1
	&	minLat( LAT )
	&	minLon( LON )
	&	name( agentA3 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	: 	X = 1
	&	maxLat( LAT )
	&	minLon( LON )
	&	name( agentA4 )
	<- 	getPoint( LAT, LON, P);
		+P;
	.

+step( X )
	:	X < 1
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
	<-	action( build( wellType0 ) );
		-point( _, _ );
		-indo_poco;
		+construindo_poco;
		.print( "build(well)" );
	.

+step( _ )
	:	role(drone,_,_,_,_,_,_,_,_,_,_)
	&	construindo_poco
	&	not indo_poco
	//poco_foi_construido
	<-	!validar( R );
		if( R == true ){
			-construindo_poco;
//			action( noAction );
//			.print( "noAction" );
			?centerLat( CLAT );
			?centerLon( CLON );
			action( goto( CLAT, CLON ) );
			.print( "indo para o centro");
		}else{
			action( build );
			.print( "build" );
		}
		/*validar */
	.

//+step( _ )
//	:	role(drone,_,_,_,_,_,_,_,_,_,_)
//	&	construindo_poco
//	<-
//		action( build );
//		.print( "build" );
//		!!mostrar;
//	.

+step( _ )
	: 	role(drone,_,_,_,_,_,_,_,_,_,_)
	<-	action( continue );
		.print( "continue" );
		//!!mostrar;
	.

poco_foi_construido
	:-	well( _,_,_,WELL,_,MV)
	//	well(well9732,48.89009,2.40846,wellType0,A,72)
	&	wellType( WELL,_,_,_, V)
	//	wellType(wellType0,600,4,36,73)
	&	V == MV
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
