
+!fastgathering
	:
		true	
	<-
		.wait( centerStorage( STORAGECENTRAL ));
		.wait( storage( STORAGECENTRAL, _, _, _, _, LISTA));
		.wait( name( NAME ));
		.wait( role( _,_,_,CAPACIDADE,_,_,_,_,_,_,_) );
		.wait( resourceNode( _,_,_,_) );
	
		?lessqtt( LISTA, ITEM );
		?item( ITEM, VOL_ITEM, _, _ );
		?lat(Y0);
		?lon(X0);
		?nearResourceNodeWithItem( X,Y, X0, Y0, ITEM );	
	
		VEZES=math.ceil( ( CAPACIDADE * 0.4 ) / VOL_ITEM );
		
		?repeat( gather, VEZES, [], VARIOS_GATHER );
		
		PASSOS = [ goto( X, Y ) | VARIOS_GATHER ];
		.concat( PASSOS, [ goto( STORAGECENTRAL ), store( ITEM, VEZES ) ], MAIS_PASSOS );
		
		+task(fastgathering,4,MAIS_PASSOS,[]);
	.

//-!fastgathering : true
//	<- 
//		.wait(100);
//		!!fastgathering;
//	.

-task( _,_,_,_ ) : not task( _,_,_,_ )
 		<-
  			!fastgathering
  			;
 		.
 
 @teste[atomic]
 -doing(fastgathering): 
 	true
	<-
		!rollBackJob;		
	.