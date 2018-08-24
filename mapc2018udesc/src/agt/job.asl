<<<<<<< HEAD
passosRetrieve( [], LISTA, RETORNO ) :- RETORNO = LISTA.
passosRetrieve( [required(ITEM, QTD)|T], LISTA, RETORNO ):-
		repeat( retrieve(ITEM,1) , QTD , [] ,RR ) &
		.concat(LISTA, RR, N_LISTA) &
		passosRetrieve( T, N_LISTA, RETORNO).

@job[atomic]
+job( NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS )
	:
		name( NAME )
	&	not jobCommitment(NAME,_)
	&	not gatherCommitment( NAME, _ )
	&	not craftCommitment( NAME, _ )
	&	not missionCommitment( NAME, _ )
	&	not doing(_)    
    &	role(ROLE,_,_,CAPACIDADE,_,_,_,_,_,_,_)
	&	step( STEPATUAL )
	&	centerStorage(STORAGE)
	&	sumvolruleJOB( ITENS, VOLUMETOTAL )
	&	CAPACIDADE >= VOLUMETOTAL
	&	possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO )
	&	TEMPONECESSARIO <= ( STEPFINAL - STEPATUAL )
    <- 
    	addIntentionToDoJob(NAME, NOMEJOB);
=======
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
>>>>>>> master
  .
 
+dojob(NOMEJOB)
	:
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
    <-
<<<<<<< HEAD
//    	.print( "Eu, um(a) ", ROLE, " vou fazer o job ", NOMEJOB );
=======
    	.print( "Disseram para eu, um(a) ", ROLE, " fazer o job ", NOMEJOB );
>>>>>>> master
    	!!realizarJob( NOMEJOB );
	.

@realizarJob[atomic]
+!realizarJob( NOMEJOB )
	:
<<<<<<< HEAD
		true

	<-	
		.wait(centerStorage(STORAGE)
	&	job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS));
=======
		job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
	&	role(car,_,_,CAPACIDADE,_,_,_,_,_,_,_)
	&	centerStorage(STORAGE)
	<-	
		.print( "Entrou no realizarJob( ", NOMEJOB, " )");
		!calcularVolume( ITENS, 0, VOLUMETOTAL );
		
		.print( "Posso carregar tudo?" );
		?possoCarregarTudo( CAPACIDADE, VOLUMETOTAL );
		.print( "sim" );
		
>>>>>>> master
		PASSOS_1 = [ goto( STORAGE ) ];
		?passosRetrieve( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);
<<<<<<< HEAD

		-steps( job, _ );
		+steps( job, PASSOS_3 );
		-expectedplan( job, _);
		+expectedplan( job, PASSOS_3 );
		+todo( job, 9 );
=======
		.length( PASSOS_3, TAMANHOLISTAPASSOS );
		
		.print( "Tenho tempo suficiente?" );
		?possuoTempoParaRealizarJob( NOMEJOB, TAMANHOLISTAPASSOS );
		.print( "sim" );

		-steps( job, _ );
		+steps( job, PASSOS_3 );
		+todo( job, 8 );
		
	.

-!realizarJob( NOMEJOB )
	:
		name( NAME )
	&	role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		.print( "não" );
		.print( "O ", ROLE, " de nome ", NAME, " não pode realizar o trabalho." );
		// Aqui tem que vir uma instrução para desmarcar o trabalho como sendo feito.
>>>>>>> master
	.


//+storage(STORAGE,_,_,_,_,ITENSTORAGE)
//	:
//		centerStorage( STORAGE )
//	&	name( NAME )
//	&	jobCommitment( NAME, JOB )
//	&	job( JOB,_,_,_,_,ITENSJOB)
//	&	temTodosItens( ITENSJOB, ITENSTORAGE )
//	<-
//		.print( "Chegou a hora de fazer o job ", STORAGE, ": ", LISTITENS );
//		-todo( job, _ );
//		+todo( job, 9 );
//	.


+!testarTrabalho
	:
		name( NAME )
	&	jobCommitment( NAME,JOB )
	&	not job( JOB,_,_,_,_,_ )
	&	step( STEP )
	<-
//		.print( STEP, "-Acabou o tempo para eu fazer o job ", JOB );
		!rollBackJob;
		removeIntentionToDoJob( NAME, JOB );
		!removetodo(job);
	.


+!testarTrabalho<-true.

+!rollBackJob
	:
		hasItem( _, _)
	&	centerStorage( STORAGE )
	<-
		?buildStore( [], LISTAFINAL );
//		.print( LISTAFINAL );
		
		.concat( [goto(STORAGE)], LISTAFINAL, PASSOS );
		
		-steps( rollBackJob, _ );
		+steps( rollBackJob, PASSOS );
		-expectedplan( rollBackJob, _);
		+expectedplan( rollBackJob, PASSOS_3 );
		+todo( rollBackJob, 8.8 );
		
//		.print( "Adicionei plano para devolver os itens no job" );
	.

+!rollBackJob
	:
		true
	<-
<<<<<<< HEAD
//		.print( "Nada para devolver" );
		true;
	.

-todo(job,_)
	: 	jobCommitment(NAME,NOMEJOB) &
		name( NAME )				&
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		removeIntentionToDoJob(NAME, NOMEJOB);
	.
=======
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


>>>>>>> master
