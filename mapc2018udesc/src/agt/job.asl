{ include("regras.asl") }

+job(NOMEJOB,_,_,_,_,_)
	:
		not jobCommitment(NOMEJOB)
	&	name(A)
	&	not doing(_)
//    &	role(motorcycle,_,_,_,_,_,_,_,_,_,_)
    &	role(car,_,_,_,_,_,_,_,_,_,_)
    <- 
  		?step(S);
    	+commitjob(NOMEJOB);
    	addIntentionToDoJob(NOMEJOB);
  .
 
+dojob(NOMEJOB)
	:
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
    <-
    	.print( "Disseram para eu, um(a) ", ROLE, " fazer o job ", NOMEJOB );
    	!!realizarJob( NOMEJOB );
	.

+!realizarJob( NOMEJOB )
	:
		job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
	&	role(car,_,_,CAPACIDADE,_,_,_,_,_,_,_)
	&	centerStorage(STORAGE)
	<-	
		.print( "Entrou no realizarJob( ", NOMEJOB, " )");
		!calcularVolume( ITENS, 0, VOLUMETOTAL );
		
		?possoCarregarTudo( CAPACIDADE, VOLUMETOTAL );
		
		PASSOS_1 = [ goto( STORAGE ) ];
		!passosGathering( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);
		.length( PASSOS_3, TAMANHOLISTAPASSOS );
		
		?possuoTempoParaRealizarJob( NOMEJOB, TAMANHOLISTAPASSOS );

		-steps( job, _ );
		+steps( job, PASSOS_3 );
		+todo(job,8);
		
	.

//-!realizarJob( NOMEJOB )
//	:
//		true
//	<-
//		.print( "Falha no plano de realizar job" );
//	.

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

+!calcularVolume( [], VOLUMEATUAL, VOLUMETOTAL )
	:
		true
	<-
		VOLUMETOTAL = VOLUMEATUAL;
	.

+!calcularVolume( [required(ITEM, QTD)|T], VOLUMEATUAL, VOLUMETOTAL )
	:
		item(ITEM, VOLUMEITEM, _, _)
	<-
		AUXVOLUME = VOLUMEATUAL + VOLUMEITEM * QTD;
		!calcularVolume( T, AUXVOLUME, VOLUMETOTAL );
	.


