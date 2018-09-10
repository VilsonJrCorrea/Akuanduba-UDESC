+!dropAll
	:
		hasItem( _, _)
	&	centerStorage( STORAGE )
	<-
		?buildStore( [], LISTAFINAL );
		.concat( [goto(STORAGE)], LISTAFINAL, PASSOS );
		+task(dropAll,8.9,PASSOS,[]);
		.print( "Adicionei plano para devolver os itens no job" );
	.

+!dropAll <-true.
