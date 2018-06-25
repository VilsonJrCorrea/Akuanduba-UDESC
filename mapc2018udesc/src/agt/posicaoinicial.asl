rightdirection(true).

dislon(SIZE):- 	minLon(MLON) 	& centerLon(CLON) & 
 				role(_,_,_,_,_,_,_,VR,_,_,_) & SIZE=(CLON-MLON-(VR/111320)).

nextlat(CLAT,RLAT):- role(_,_,_,_,_,_,_,VR,_,_,_) & RLAT=(CLAT-(VR/110570)).

nextlon(FLON,RLON):- rightdirection(DLON) &
					 dislon(SIZE) & 
					 	((DLON==true  & RLON=FLON+SIZE) |
				  		 (DLON==false & RLON=FLON-SIZE)).

invert(I,O):- (I=true & O=false)|(I=false & O=true).

-doing(exploration): steps(exploration, ACTS) & lat(LAT) 
	& lon(LON) & acaoValida( ACAO ) & ACTS \== []
	<-
		.print("Parei em ", LAT, " e ", LON);
		-steps(exploration, _ );
		+steps(exploration, [goto(LAT,LON)| [ ACAO | ACTS ] ]);
		?steps(exploration, LISTA);
		.print(">>>>>>>>>>Esse aqui porra>>>>>>>>>>>>>>>>", LISTA);
		.print("Removi a exploracao");
	.

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
		+steps( exploration, R);
		+todo(exploration,6);		
	.

//+explorationsteps([]):true
//	<-
//		-todo(exploration,_);
////		-doing(_);
//		-steps( exploration,[]);
//	.

+steps(exploration,[]):true
	<-
		-todo(exploration,_);
//		-doing(_);
		-steps( exploration,[]);
	.

+dronepos(_,_,_): .count(dronepos(_,_,_),QTD) & QTD == 4
	<-
		?role(_,_,_,_,_,_,_,VR,_,_,_);
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
