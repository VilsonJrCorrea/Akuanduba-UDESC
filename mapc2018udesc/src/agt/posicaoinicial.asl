visionrange(1000).
rightdirection(true).
last(lat).

dislon(SIZE):- 	minLon(MLON) 	& centerLon(CLON) & 
 				visionrange(VR) & SIZE=(CLON-MLON-(VR/111320)).

nextlat(CLAT,RLAT):- visionrange(VR) & RLAT=(CLAT-(VR/110570)).

nextlon(FLON,RLON):- rightdirection(DLON) &
					 dislon(SIZE) & 
					 	((DLON==true  & RLON=FLON+SIZE) |
				  		 (DLON==false & RLON=FLON-SIZE)).

invert(I,O):- (I=true & O=false)|(I=false & O=true).

+simStart: not started & role(drone,_,_,_,_,_,_,_,_,_,_)
	<-
		.wait (lat(LAT));
		.wait (lon(LON));
		.wait (name(N));
		.send(agentA1,tell,dronepos(N,LAT,LON));
		+started;
	.

+myc(CLAT,CLON,F):true
	<-
		+todo(exploration,6);
		+explorationsteps([goto(CLAT,CLON)]);
		!buildexplorationsteps(CLAT,CLON,F);		
	.

+explorationsteps([]):true
	<-
		-doing(_);
		-explorationsteps([]);
	.

-doing(exploration): explorationsteps(ACTS) & lat(LAT) & lon(LON)
	<-
		-+explorationsteps([goto(LAT,LON)|ACTS]);
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

+!buildexplorationsteps(CLAT, CLON,F): F>CLAT   
	<- true	.

+!buildexplorationsteps(CLAT, CLON,F): last(lat) 
	<-
		?nextlon(CLON,RLON);
		-+last(lon);
		?rightdirection(I);
		?invert(I,O);
		-+rightdirection(O);
		?explorationsteps(EM);
		.concat (EM,[goto( CLAT, RLON)],NEM );
		-+explorationsteps(NEM);
		!!buildexplorationsteps(CLAT, RLON,F)
	.

+!buildexplorationsteps(CLAT, CLON,F): last(lon)
	<-	
		?nextlat(CLAT,RLAT);
		-+last(lat);		
		?explorationsteps(EM);
		.concat (EM,[goto( RLAT, CLON)],NEM );
		-+explorationsteps(NEM);
		!!buildexplorationsteps(RLAT, CLON,F)
	.