+!fastgathering
	:
	name( NAME )
	&	not jobCommitment(NAME,_)
	&	not gatherCommitment( NAME, _ )
	&	not craftCommitment( NAME, _ )
	&	not missionCommitment( NAME, _ )	
	&	not (agentid("10") | agentid("12")) 
	<-
//		.print("Entrou no fastgathering.");
//		?centerStorage( STORAGECENTRAL );
		.wait(centerStorage( STORAGECENTRAL ));
		?storage( STORAGECENTRAL, _, _, _, _, LISTA);
		?role( _,_,_,CAPACIDADE,_,_,_,_,_,_,_) ;
		?resourceNode( _,_,_,_) ;
		
		//!!dropAll;
		
		?lessqtt( LISTA, ITEM );
		?item( ITEM, VOL_ITEM, _, _ );
		?lat(Y0);
		?lon(X0);
		?nearResourceNodeWithItem( X,Y, X0, Y0, ITEM );	
	
		VEZES=math.ceil( ( CAPACIDADE * 0.4 ) / VOL_ITEM );
		
		?repeat( gather, VEZES, [], VARIOS_GATHER );
		
		PASSOS = [ goto( X, Y ) | VARIOS_GATHER ];
		.concat( PASSOS, [ goto( STORAGECENTRAL ), store( ITEM, VEZES ) ], MAIS_PASSOS );
		
		!addtask(fastgathering,4,MAIS_PASSOS,[]);
	.

+!fastgathering <- true.

//-!fastgathering <- true.

-task( _,_,[_|[]],_ ) : not task( _,_,_,_ )
 		<-
  			!fastgathering;
 		.
 
