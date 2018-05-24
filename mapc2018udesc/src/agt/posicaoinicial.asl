visionrange(950).
rightdirection(true).

dislon(SIZE):- 	minLon(MLON) 	& centerLon(CLON) & 
 				visionrange(VR) & SIZE=(CLON-MLON-(VR/111320)).

nextlat(CLAT,RLAT):- visionrange(VR) & RLAT=(CLAT-(VR/110570)).

nextlon(FLON,RLON):- rightdirection(DLON) &
					 dislon(SIZE) & 
					 	((DLON==true  & RLON=FLON+SIZE) |
				  		 (DLON==false & RLON=FLON-SIZE)).

invert(I,O):- (I=true & O=false)|(I=false & O=true).

+simStart: not sended(dronepos) & role(drone,_,_,_,_,_,_,_,_,_,_) 
	<-
		+sended(dronepos);
		.wait (lat(LAT));
		.wait (lon(LON));
		.wait (name(N));
		.send(agentA1,tell,dronepos(N,LAT,LON));
	.

+myc(CLAT,CLON,F):true
	<-
		!buildexplorationsteps(CLAT, CLON,lat, F, [goto(CLAT, CLON)], R);
		.print(R);
		+explorationsteps(R);
		+todo(exploration,6);		
	.

+explorationsteps([]):true
	<-
		-todo(exploration,_);
//		-doing(_);
		-explorationsteps([]);
	.

-doing(exploration): explorationsteps(ACTS) & lat(LAT) & lon(LON)
	<-
		-+explorationsteps([goto(LAT,LON)|ACTS]);
		.print("Removi a exploracao");
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
			.abolish (dronepos(AG,_,_));
		} 
	.

+!buildexplorationsteps(CLAT, CLON, LAST, F, LS, R): F>CLAT   
	<-
	 R=LS.

+!buildexplorationsteps(CLAT, CLON,lat, F, LS, R): true 
	<-
		?nextlon(CLON,RLON);
		?rightdirection(I);
		?invert(I,O);
		-+rightdirection(O);
		.concat (LS,[goto( CLAT, RLON)],NLS );
		!buildexplorationsteps(CLAT, RLON,lon, F, NLS, R)
	.

+!buildexplorationsteps(CLAT, CLON,lon, F, LS, R): true
	<-	
		?nextlat(CLAT,RLAT);		
		.concat (LS,[goto( RLAT, CLON)],NLS );
		!buildexplorationsteps(RLAT, CLON,lat, F, NLS, R);
	.
