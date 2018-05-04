quadranteA(A,B,C,D):-
			maxLat(MAXLAT) & minLon(MINLON) & minLat(MINLAT) & maxLon(MAXLON) & 
			A = [MAXLAT -0.0001 , MINLON + 0.0001]&
			B = [MAXLAT -0.0001 , (MINLON+MAXLON)/2] &
			C = [((MAXLAT + MINLAT)/2) , ((MINLON+MAXLON)/2)]&
			D = [((MAXLAT+MINLAT)/2) , MINLON + 0.0001]
			.
centroQuadA( X , Y ):-
				quadranteA(A,B,C,D) &
				A[H1|T1] &
				B[H2|T2] &
				D[H3|T3] &
				T1 = Y1  &
				T2 = Y2  &
				T3 = Y3  &
				X = ((H1 + H3)/2) &
				Y = ((Y1 + Y2)/2)
			.
				
					
quadranteB(A,B,C,D):-
			maxLat(MAXLAT) & minLon(MINLON) & minLat(MINLAT) & maxLon(MAXLON) & 
			A = [MAXLAT -0.0001 , ((MINLON+MAXLON)/2)] &
			B = [MAXLAT -0.0001 , MAXLON -0.0001]&
			C = [((MAXLAT + MINLAT)/2) , MAXLON - 0.0001]&
			D = [((MAXLAT + MINLAT)/2), ((MINLON+MAXLON)/2)]
			.
centroQuadB( X , Y ):-
				quadranteB(A,B,C,D) &
				A[H1|T1] &
				B[H2|T2] &
				D[H3|T3] &
				T1 = Y1  &
				T2 = Y2  &
				T3 = Y3  &
				X = ((H1 + H3)/2) &
				Y = ((Y1 + Y2)/2)
				.
quadranteC(A,B,C,D):-
			maxLat(MAXLAT) & minLon(MINLON) & minLat(MINLAT) & maxLon(MAXLON) & 
			A = [((MAXLAT + MINLAT)/2) , ((MINLON+MAXLON)/2)]&
			B =  [((MAXLAT + MINLAT)/2) , MAXLON - 0.0001 ]&
			C = [MINLAT + 0.0001 , MAXLON - 0.0001]&
			D = [MINLAT + 0.0001, ((MINLON+MAXLON)/2)]
			.
centroQuadC( X , Y ):-
				quadranteC(A,B,C,D) &
				A[H1|T1] &
				B[H2|T2] &
				D[H3|T3] &
				T1 = Y1  &
				T2 = Y2  &
				T3 = Y3  &
				X = ((H1 + H3)/2) &
				Y = ((Y1 + Y2)/2)
				.
						
quadranteD(A,B,C,D):-
			maxLat(MAXLAT) & minLon(MINLON) & minLat(MINLAT) & maxLon(MAXLON) & 
			A = [((MAXLAT+MINLAT)/2) , (MINLON + 0.0001)]&
			B = [((MAXLAT + MINLAT)/2) , ((MINLON+MAXLON)/2)]&
			C = [MINLAT + 0.0001, ((MINLON+MAXLON)/2)]&
			D = [MINLAT+ 0.0001 , MINLON+ 0.0001]
			.
			
centroQuadD( X , Y ):-
				quadranteD(A,B,C,D) &
				A[H1|T1] &
				B[H2|T2] &
				D[H3|T3] &
				T1 = Y1  &
				T2 = Y2  &
				T3 = Y3  &
				X = ((H1 + H3)/2) &
				Y = ((Y1 + Y2)/2)
				.
				
+step(_): centroQuadA(X,Y) & name(agentA3)
		<-
		.print("ESTOU INDO")&
		action(goto(Y,X))
		.
		
+step(_): true
		<-
		action(continue)
		.