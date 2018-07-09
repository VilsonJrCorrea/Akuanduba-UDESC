+!buildPoligon : name(A) & A\== agentA10 & A\== agentB10   	
	<- true.

+!buildPoligon: name(agentA10) | name(agentB10) 
	<-
		.wait(step(1));
		for(chargingStation(_,X,Y,_)) {
			addPoint(X,Y);
		}
		for(dump(_,X,Y)) {
			addPoint(X,Y);
		}
		for(shop(_,X,Y)) {
			addPoint(X,Y);
		}
		for(workshop(_,X,Y)) {
			addPoint(X,Y);
		}
		for(storage(_,X,Y,_,_,_)) {
			addPoint(X,Y);
		}
		buildPolygon;
		.print("Poligono pronto !!");
		!buildWell( wellType0, agentA10, 3, 9 );
	.


/**
 * Plano que deve ser chamado quando ser quer
 * construir o po�o no canto superior esquerdo.
 */
+!buildWell( WELLTYPE, AGENT, 1, PRIORITY )
	:	maxLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o po�o no canto superior direita.
 */
+!buildWell( WELLTYPE, AGENT, 2, PRIORITY )
	:	maxLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o po�o no canto inferior direito.
 */
+!buildWell( WELLTYPE, AGENT, 3, PRIORITY )
	:	minLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o po�o no canto inferior esquerdo.
 */
+!buildWell( WELLTYPE, AGENT, 4, PRIORITY )
	:	minLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que constroi a lista de passos para a constru��o dos po�os
 */
+!buildWell( WELLTYPE, AGENT, LAT, LON, PRIORITY )
	:	true
	<-	 
		getPoint( LAT, LON, P );
		!getCoordenadasPonto( P, PLAT, PLON );
		!qtdStep( WELLTYPE, AGENT, QTD );
		!buildWellSteps( [goto(PLAT, PLON), build(WELLTYPE)], QTD, R );
		+steps( buildWell, R );
		.print(R);
		+todo(buildWell, PRIORITY);
		//.print( "buildWell pronto!!" );
	.
/**
 * Plano que pega a cren�a point(lat,lon) fornecida pelo
 * artefato ARTGreyZone e retorna os valores de suas coordenadas.
 */
+!getCoordenadasPonto( point( PLAT, PLON ), LAT, LON )
	:	true
	<-	LAT = PLAT;
		LON = PLON;
	.

/**
 * Calcula quantos steps � necess�rio para construir um po�o
 * levando em conta o skill do agente e o tipo de po�o.
 */
+!qtdStep( WELLTYPE, AGENT, QTD )
	:	wellType(WELLTYPE,_,_,MIN,MAX)
	&	role(_,_,_,_,_,MINSKILL,MAXSKILL,_,_,_,_)
	<-	QTD = math.round( ( MAX-MIN )/MINSKILL )+1;
		//.print("WellType: ", WELLTYPE, ", MIN: ", MIN, ", MAX: ", MAX, ", QTD:", QTD, ", MINSKILL: ", MINSKILL);
	.

/**
 * Constroi uma lista com a instru��o build.
 * o tamanho dessa lista � o n�mero de vezes que o agente
 * tem que dar o build com construir o po�o.
 * Esse plano utiliza a recursividade. Ver plano abaixo.
 */
+!buildWellSteps( LS, QTD, R )
	:	QTD > 0
	<-	.concat( LS, [build], NLS );
		!buildWellSteps( NLS, QTD-1, R );
	.

/**
 * Caso em que a contagem de build's j� zerou.
 * Ver plano acima.
 */
+!buildWellSteps( LS, 0, R )
	:	true
	<-	R = LS;
	.

