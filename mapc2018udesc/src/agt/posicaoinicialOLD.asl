visionrange(1000).
upperdirection(false).
rightdirection(true).
last(lat).
firstexplotation.
dislon(SIZE):- 	minLon(MLON) 	  & centerLon(CLON) & 
 				visionrange(VR) & SIZE=(CLON-MLON-(VR/111320)).

nextlat(RLAT):- visionrange(VR) & lat(LAT) & upperdirection(DLAT) &	  
				((DLAT==false   & RLAT=(LAT-(VR/110570))) |
				(DLAT==true     & RLAT=(LAT+(VR/110570)))).

nextlon(RLON):- lon(LON) 	 & rightdirection(DLON) &
				dislon(SIZE) & ((DLON==true  & RLON=LON+SIZE) |
				  			 	(DLON==false & RLON=LON-SIZE)).

+simStart: not started & role(drone,_,_,_,_,_,_,_,_,_,_)
	<-
		.wait (lat(LAT));
		.wait (lon(LON));
		.wait (name(N));
		.send(agentA1,tell,dronepos(N,LAT,LON));
		+started;
	.

+dronepos(_,_,_): .count(dronepos(_,_,_),QTD) & QTD == 4
	<-
		?visionrange(VR);
		?maxLat( MAXLAT );
		?minLat( MINLAT );
		?minLon( MINLON );
		?centerLat( CNTLAT );
		?centerLon( CNTLON );
		
		+corner (MAXLAT -(VR/221140),MINLON + (VR/222640),CNTLAT);
		+corner (MAXLAT -(VR/221140),CNTLON,CNTLAT);
		+corner (CNTLAT,MINLON + (VR/222640),MINLAT);
		+corner (CNTLAT,CNTLON,MINLAT);
		for (corner(LAT,LON,F)[source(_)]) {
			?finddrone(LAT, LON, AG);
			.send(AG,tell,myc(LAT,LON,F));
			-dronepos(AG,_,_)[source(_)];
		} 
	.
+step( _ ): not route([])
	<-
		action( continue );
	.
+step( _ ): role(drone,_,_,_,_,_,_,_,_,_,_) & 
			myc(CLAT,CLON,F) &
			route([]) & firstexplotation  
	<-
		-firstexplotation;
		action( goto( CLAT, CLON) );
	.


+step( _ ): role(drone,_,_,_,_,_,_,_,_,_,_) & lat(LAT) & 
			myc(CLAT,CLON,F) & (F>LAT | (lastActionResult(X) &	
				X\==successful))   & not explotationended   
	<-
		action( noAction );
		+explotationended;
	.


+step( _ ): role(drone,_,_,_,_,_,_,_,_,_,_) & lat(LAT) &
			route([])  & not firstexplotation & last(lat) &
			rightdirection(false) & not explotationended
	<-
		?nextlon(RLON);
		-+last(lon);
		-+rightdirection(true);
		action( goto( LAT, RLON) );
	.

+step( _ ): role(drone,_,_,_,_,_,_,_,_,_,_) & lat(LAT) &
			route([])  & not firstexplotation & last(lat) &
			rightdirection(true) & not explotationended
	<-
		?nextlon(RLON);
		-+last(lon);
		-+rightdirection(false);
		action( goto( LAT, RLON) );
	.

+step( _ ): role(drone,_,_,_,_,_,_,_,_,_,_) & lon(LON) &
			route([])  & not firstexplotation & last(lon) & not explotationended
	<-
		?nextlat(RLAT);
		-+last(lat);		
		action( goto( RLAT, LON) );
	.
	
+step( _ ): true
	<-
	action( noAction );
	.