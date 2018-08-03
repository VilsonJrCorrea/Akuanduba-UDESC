{ include("regras.asl") }

+job(NOMEJOB,_,_,_,_,_)
	:
		name( NAME )
	&	not jobCommitment(NAME,NOMEJOB)
	&	not doing(_)
    &	role(ROLE,_,_,CAPACIDADE,_,_,_,_,_,_,_)
    &	(ROLE=car | ROLE=motocycle)
    &	job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
	&	step( STEPATUAL )
	&	centerStorage(STORAGE)
	&	sumvolruleJOB( ITENS, VOLUMETOTAL )
	&	CAPACIDADE >= VOLUMETOTAL
	&	possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO )
	&	TEMPONECESSARIO <= ( STEPFINAL - STEPATUAL )
    <- 
//    	+jobCommitment(NOMEJOB);
    	addIntentionToDoJob(NAME, NOMEJOB);
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
		centerStorage(STORAGE)
	&	job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)

	<-	
		.print( "Entrou para realizar o job " );
		
//		?sumvolruleJOB( ITENS, VOLUMETOTAL );
//		.print( "Capacidade: ", CAPACIDADE, ", VolumeTotal: ", VOLUMETOTAL );

//		?possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO );
//		.print( "Tempo: ", ( STEPFINAL - STEPATUAL ), ", TempoNecessario: ", TEMPONECESSARIO );

		PASSOS_1 = [ goto( STORAGE ) ];
		!passosGathering( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);

		-steps( job, _ );
		+steps( job, PASSOS_3 );
		-expectedplan( job, _);
		+expectedplan( job, PASSOS_3 );
		+todo( job, 5 );
		
	.

-todo(job,_)
	: 	jobCommitment(NAME,NOMEJOB) &
		name( NAME )				&
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		removeIntentionToDoJob(NAME, NOMEJOB)
//		removeIntentionToDoJob( NOMEJOB );
		.print( "O ", ROLE, " de nome ", NAME, " nao pode realizar o trabalho ", NOMEJOB );
		// Aqui tem que vir uma instru��o para desmarcar o trabalho como sendo feito.
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
