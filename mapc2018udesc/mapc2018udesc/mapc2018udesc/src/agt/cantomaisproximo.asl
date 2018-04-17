+step(0): role(drone,_,_,_,_,_,_,_,_,_,_)
	<-
	?lat(LAT);
	?lon(LON);
	?name(N);
	.send(agentA1,tell,dronepos(N,LAT,LON));
	action( noAction );
	.
+dronepos(_,_,_): .count(dronepos(_,_,_),QTD) & QTD == 4
	<-
	?maxLat( MAXLAT );
	?maxLon( MAXLON );
	?minLat( MINLAT );
	?minLon( MINLON );
	+corner (MINLAT + 0.00001,MINLON + 0.00001);
	+corner (MINLAT + 0.00001,MAXLON - 0.00001);
	+corner (MAXLAT - 0.00001,MINLON + 0.00001);
	+corner (MAXLAT - 0.00001,MAXLON - 0.00001);
	for (dronepos(AG,LAT,LON)[source(_)]) {
		?mycorner(LAT, LON, CLAT,CLON);
		.send(AG,tell,myc(CLAT,CLON));
		-corner(CLAT,CLON);
	}
.
+step( _ ): not route([])
	<-
	action( continue );
	.
+step( _ ): role(drone,_,_,_,_,_,_,_,_,_,_) & 
			myc(CLAT,CLON) &
			route([]) 
	<-
	action( goto( CLAT, CLON) );
	.
+step( _ ): true
	<-
	action( noAction );
	.