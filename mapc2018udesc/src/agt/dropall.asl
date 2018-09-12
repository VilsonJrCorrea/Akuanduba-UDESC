+!dropAll
	:
		hasItem( _, _)
	&	centerStorage( STORAGE )
	&	step(STEP)
	<-
		?buildStore( [], LISTAFINAL );
		.concat( [goto(STORAGE)], LISTAFINAL, PASSOS );
		+task(dropAll,8.9,PASSOS,[]);		
		.print(STEP, "-Adicionei plano para devolver os itens no job" );
	.

+!dropAll <-true.
