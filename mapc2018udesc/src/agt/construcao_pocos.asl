+steps( buildWell, [] ) : true
	<-	
		-todo( buildWell, _ );
	.

+!buildPoligon :  not agentid("10") & name(AG)	
	<- true.

+!buildPoligon:  agentid("10") & name(AG) 
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
//		.print("Poligono pronto !!");
		?betterWell(WELL);
		.send(akuanduba_udesc12,achieve,buildWell( WELL, AG, 1, 9 ));
		!buildWell( WELL, AG, 2, 9 );
	.

	
+!test:true<-
 	.print("Recebi uma mensagem");
 .
		
/**
 * Plano que deve ser chamado quando ser quer
 * construir o poco no canto superior esquerdo.
 */
 
+!buildWell( WELLTYPE, AGENT, 1, PRIORITY )
	:	maxLat( MLAT )
	&	maxLon( MLON )
	<-	
		!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poco no canto superior direita.
 */
+!buildWell( WELLTYPE, AGENT, 2, PRIORITY )
	:	maxLat( MLAT )
	&	minLon( MLON )
	<-	
		!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poï¿½o no canto inferior direito.
 */
+!buildWell( WELLTYPE, AGENT, 3, PRIORITY )
	:	minLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poco no canto inferior esquerdo.
 */
+!buildWell( WELLTYPE, AGENT, 4, PRIORITY )
	:	minLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que constroi a lista de passos para a construcao de pocos
 */
+!buildWell( WELLTYPE, AGENT, LAT, LON, PRIORITY )
	:	true
	<-	 
		getPoint( LAT, LON, P );
		!getCoordenadasPonto( P, PLAT, PLON );
		!qtdStep( WELLTYPE, AGENT, QTD );
		!buildWellSteps( [goto(PLAT, PLON), build(WELLTYPE)], QTD, R );
		
		+task(buildWell,PRIORITY,R,[]);
		!buildCareWell(WELLTYPE);
//		.print( "buildWell pronto!!" );
	.
/**
 * Plano que pega a crenca point(lat,lon) fornecida pelo
 * artefato ARTGreyZone e retorna os valores de suas coordenadas.
 */
+!getCoordenadasPonto( point( PLAT, PLON ), LAT, LON )
	:	true
	<-	LAT = PLAT;
		LON = PLON;
	.

/**
 * Calcula quantos steps sao necessarios para construir um poco
 * levando em conta o skill do agente e o tipo de pocos
 */
+!qtdStep( WELLTYPE, AGENT, QTD )
	:	wellType(WELLTYPE,_,_,MIN,MAX)
	&	role(_,_,_,_,_,MINSKILL,MAXSKILL,_,_,_,_)
	<-	QTD = math.round( ( MAX-MIN )/MINSKILL )+1;
		//.print("WellType: ", WELLTYPE, ", MIN: ", MIN, ", MAX: ", MAX, ", QTD:", QTD, ", MINSKILL: ", MINSKILL);
	.

/**
 * Constroi uma lista com a instruï¿½ï¿½o build.
 * o tamanho dessa lista ï¿½ o nï¿½mero de vezes que o agente
 * tem que dar o build com construir o poï¿½o.
 * Esse plano utiliza a recursividade. Ver plano abaixo.
 */
+!buildWellSteps( LS, QTD, R )
	:	QTD > 0
	<-	.concat( LS, [build], NLS );
		!buildWellSteps( NLS, QTD-1, R );
	.

/**
 * Caso em que a contagem de build's jï¿½ zerou.
 * Ver plano acima.
 */
+!buildWellSteps( LS, 0, R )
	:	true
	<-	R = LS;
	.


+!buildCareWell (WELL): true
	<-
		+task(cuidaPoco,8.9,[noAction],[]);
	.
	
+entity(_,TEAMADV,_,_,_)[source(percept)]:
			team(TEAM) &
			TEAMADV \==TEAM &
			task(cuidaPoco,_,_,_)&
			doing(cuidaPoco)
	<-
		.print("Chegou alguem que não é do meu time");
		
		?repeat( dismantle, 1, [], R );
		+task(desmantelar,9.1,R,[]);
	.
