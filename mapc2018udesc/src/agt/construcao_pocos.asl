/**
 * Plano que deve ser chamado quando ser quer
 * construir o poço no canto superior esquerdo.
 */
+!buildWell( WELLTYPE, AGENT, 1, PRIORITY )
	:	maxLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poço no canto superior direita.
 */
+!buildWell( WELLTYPE, AGENT, 2, PRIORITY )
	:	maxLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poço no canto inferior direito.
 */
+!buildWell( WELLTYPE, AGENT, 3, PRIORITY )
	:	minLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poço no canto inferior esquerdo.
 */
+!buildWell( WELLTYPE, AGENT, 4, PRIORITY )
	:	minLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que constroi a lista de passos para a construção dos poços
 */
+!buildWell( WELLTYPE, AGENT, LAT, LON, PRIORITY )
	:	true
	<-	.print( WELLTYPE, " ", AGENT, " ",LAT, " ", LON, " ", PRIORITY );
		//getPoint( double lat, double lon, OpFeedbackParam<Literal> retorno ) 
		getPoint( LAT, LON, P );
		.print( P );
		!getCoordenadasPonto( P, PLAT, PLON );
		!qtdStep( WELLTYPE, AGENT, QTD );
		!buildWellSteps( [goto(PLAT, PLON), build(WELLTYPE)], QTD, R );
		+steps( buildWell, R );
		+todo(buildWell, PRIORITY);
		.print( "buildWell pronto!!" );
	.
/**
 * Plano que pega a crença point(lat,lon) fornecida pelo
 * artefato ARTGreyZone e retorna os valores de suas coordenadas.
 */
+!getCoordenadasPonto( point( PLAT, PLON ), LAT, LON )
	:	true
	<-	LAT = PLAT;
		LON = PLON;
	.

/**
 * Calcula quantos steps é necessário para construir um poço
 * levando em conta o skill do agente e o tipo de poço.
 */
+!qtdStep( WELLTYPE, AGENT, QTD )
	:	wellType(WELLTYPE,_,_,MIN,MAX)
	&	role(_,_,_,_,_,MINSKILL,MAXSKILL,_,_,_,_)
	<-	QTD = math.round( ( MAX-MIN )/MINSKILL )+1;
		.print("WellType: ", WELLTYPE, ", MIN: ", MIN, ", MAX: ", MAX, ", QTD:", QTD, ", MINSKILL: ", MINSKILL);
	.

/**
 * Constroi uma lista com a instrução build.
 * o tamanho dessa lista é o número de vezes que o agente
 * tem que dar o build com construir o poço.
 * Esse plano utiliza a recursividade. Ver plano abaixo.
 */
+!buildWellSteps( LS, QTD, R )
	:	QTD > 0
	<-	.concat( LS, [build], NLS );
		!buildWellSteps( NLS, QTD-1, R );
	.

/**
 * Caso em que a contagem de build's já zerou.
 * Ver plano acima.
 */
+!buildWellSteps( LS, 0, R )
	:	true
	<-	R = LS;
	.

