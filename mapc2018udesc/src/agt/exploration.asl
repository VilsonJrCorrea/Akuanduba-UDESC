dislon(SIZE):- 	minLon(MLON) 	& maxLon(CLON) & 
 				role(_,_,_,_,_,_,_,VR,_,_,_) & SIZE=((CLON-MLON)/2-(VR/111320)).

nextlat(CLAT,RLAT):- role(_,_,_,_,_,_,_,VR,_,_,_) & RLAT=(CLAT-(VR/110570)).

nextlon(FLON,RLON):- rightdirection(DLON) &
					 dislon(SIZE) & 
					 	((DLON==true  & RLON=FLON+SIZE) |
				  		 (DLON==false & RLON=FLON-SIZE)).

invert(I,O):- (I=true & O=false)|(I=false & O=true).

+!exploration: role(R,_,_,_,_,_,_,_,_,_,_) & R\==drone
	<- true. 
+!exploration: role(drone,_,_,_,_,_,_,VR,_,_,_)
	<-
		.wait (lat(LAT));
		.wait (lon(LON));
		.wait (maxLat(MAXLAT));
		.wait (minLat(MINLAT));
		.wait (maxLon(MAXLON));
		.wait (minLon(MINLON));
		.wait (minLon(MINLON));
		.wait (name(N));
		informDronePositionAndConers(LAT, LON, MINLAT, MINLON, MAXLAT, MAXLON , VR );
	.

//@exp[atomic]
+corner(CLAT,CLON,F):true
	<-
		-+rightdirection(true);
		!buildexplorationsteps(CLAT, CLON,lat, F, [goto(CLAT, CLON)], R);
//		+steps( exploration, R);
//		+todo(exploration,9);		
		+task(exploration,9,R,[]);
	.

+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
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
	

