+step( 0 ): name(agentA1)
	<-
	?maxLat( MAXLAT );
	?maxLon( MAXLON );
	?minLat( MINLAT );
	?minLon( MINLON );
	+corner (MINLAT + 0.00001,MINLON + 0.00001);
	+corner (MINLAT + 0.00001,MAXLON - 0.00001);
	+corner (MAXLAT - 0.00001,MINLON + 0.00001);
	+corner (MAXLAT - 0.00001,MAXLON - 0.00001);
	for (entity(AG,a,LAT,LON,drone)) {
		?mycorner(LAT, LON, CLAT,CLON);
		.send(AG,tell,myc(CLAT,CLON));
		-corner(CLAT,CLON);
	}
	//action( goto( MAXLAT - 0.00001, MAXLON - 0.00001) );
.
+step( _ ): role(drone,_,_,_,_,_,_,_,_,_,_) & myc(CLAT,CLON)
	<-
	action( goto( CLAT, CLON) );
	.

+lastAction( X ) : true <- .print( X ) . 
+lastActionParams( X ) : true <- .print( X ) .
+lastActionResult( X ) : true <- .print( X ) . 

{ include("regras.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }