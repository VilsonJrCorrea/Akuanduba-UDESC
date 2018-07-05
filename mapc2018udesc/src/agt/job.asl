
+job(NOMEJOB,_,_,_,_,_)
	:
		role(motorcycle,_,_,_,_,_,_,_,_,_,_)
	<-
		!realizarJob( NOMEJOB );
	.

+!realizarJob( NOMEJOB )
	:
		job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
	&	role(motorcycle,_,_,_,_,_,_,_,_,_,_)
	&	storageCentral(STORAGE)
	<-
		PASSOS_1 = [ goto( STORAGE ) ];
		!passosGathering( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);
		.print( ">>>>>>>>>>>>>>>>>>>>", NOMEJOB, " ", PASSOS_3 );
	.

+!passosGathering( [], LISTA, RETORNO )
	:
		true
	<-
		RETORNO = LISTA;
	.

+!passosGathering( [required(ITEM, QTD)|T], LISTA, RETORNO )
	:
		true
	<-
		.concat(LISTA, [retrieve( ITEM, QTD)], N_LISTA);
		!passosGathering( T, N_LISTA, RETORNO );
	.