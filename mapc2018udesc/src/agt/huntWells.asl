buildhuntscan(LAT, LON, _, _, LAUX, R):- minLat(MINLAT) & MINLAT>LAT & R=LAUX.

buildhuntscan(LAT, LON,lat,right(X) , LAUX, R):- 	minLon(MLON) & maxLon(CLON) 				& 
													role(_,_,_,_,_,_,_,VR,_,_,_) 				& 
													SIZE=((CLON-MLON)-2*(VR/111320))			&
													((X==true 	& NLON=LON+SIZE & RIGHT=false) 	|
													 (X==false 	& NLON=LON-SIZE & RIGHT=true)) 	& 											
													.concat (LAUX,[goto( LAT, NLON)],NLAUX ) 	&
													buildhuntscan(LAT, NLON,lon, right(RIGHT), NLAUX, R).

buildhuntscan(LAT, LON, lon, RIGHT, LAUX, R):-		role(_,_,_,_,_,_,_,VR,_,_,_)				& 
													RLAT=LAT-(VR/110570)						&
													.concat (LAUX,[goto( RLAT, LON)],NLAUX )	&
													buildhuntscan(RLAT, LON, lat, RIGHT, NLAUX, R).

+!huntwell: not agentid("11")
	<- true. 
	
+!huntwell: agentid("11")
	<-
		.wait (lat(LAT));
		.wait (lon(LON));
		.wait (maxLat(MAXLAT));
		.wait (minLat(MINLAT));
		.wait (maxLon(MAXLON));
		.wait (minLon(MINLON));
		.wait (role(_,_,_,_,_,_,_,VR,_,_,_));
		.print (minLat(MINLAT),minLon(MINLON),maxLat(MAXLAT),maxLon(MAXLON));
		?buildhuntscan(MAXLAT-(VR/111320), MINLON+(VR/111320), lat, right(true), [], R);
		+task(huntwell,9,R,[]);		
	.

//well(well2180,48.89503,2.40441,wellType0,a,57