+well(WELLID,LAT,LON,WELLTYPE,TEAMADV,_)[source(percept)]:team(TEAM)		&
									      TEAMADV \==TEAM					&
									      not pocosInimigos(WELLID,_,_,_)
	<-
		.send(akuanduba_udesc11,tell,wellToDestroy( WELLID, LAT, LON, WELLTYPE ));
		
	.

@hungryfordestruction[atomic]
+wellToDestroy( WELLID, LAT, LON, WELLTYPE ) 
	: not task(desmantelarPocoInimigo(WELLID),_,_,_) 
	<-
		!buildTaskToDestroy(WELLID,LAT,LON,WELLTYPE);
		.print("Novo poco do time adversario visto!");
	.
	
+!buildTaskToDestroy(WELLID,LAT,LON,WELLTYPE): 
					role(_,_,CURRENTSKILL,_,_,_,_,_,_,_,_) &
					wellType(WELLTYPE,_,_,_,INTEGRIDADE)   
	<-
		QTD = math.ceil( INTEGRIDADE/CURRENTSKILL );
		?repeat( dismantle, QTD, [], R );
		.concat([goto(LAT,LON)],R,LIST);
		+task(desmantelarPocoInimigo(WELLID),6,LIST,[]);
		+pocosInimigos(WELLID,LAT,LON,WELLTYPE);
	.
	
@frustated[atomic]
+!testDismantleWellOfEnemy :   task(desmantelarPocoInimigo(WELLID),_,[dismantle|_],_) & 
							   agentid("11") &
							   not (well(WELLID,_,_,_,_,_)[source(percept)])						   
	<- 
		-task(desmantelarPocoInimigo(WELLID),_,_,_);
	.	
	
+!testDismantleWellOfEnemy <- true.	

+task(desmantelarPocoInimigo(WELLID),_,[_|[]],_)
	: 	true
	<-
		-wellToDestroy( WELLID, _, _, _);				
	.

-wellToDestroy( _, _, _, _)
	: wellToDestroy(  WELLID, LAT, LON, WELLTYPE )
	<-
		!buildTaskToDestroy(WELLID,LAT,LON,WELLTYPE);
	.

