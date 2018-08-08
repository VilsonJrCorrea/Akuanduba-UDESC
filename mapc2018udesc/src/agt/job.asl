{ include("regras.asl") }

@job[atomic]
+job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
	:
		name( NAME )
	&	not jobCommitment(NAME,_)
	&	not doing(_)  
    &	role(ROLE,_,_,CAPACIDADE,_,_,_,_,_,_,_)
    &	(ROLE=car | ROLE=motocycle)
	&	step( STEPATUAL )
	&	centerStorage(STORAGE)
	&	sumvolruleJOB( ITENS, VOLUMETOTAL )
	&	CAPACIDADE >= VOLUMETOTAL
	&	possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO )
	&	TEMPONECESSARIO <= ( STEPFINAL - STEPATUAL )
//	&	.print( "TN: ", TEMPONECESSARIO, ", T: ", (STEPFINAL-STEPATUAL) )
    <- 
//    	+jobCommitment(NOMEJOB);
    	addIntentionToDoJob(NAME, NOMEJOB);
  .
 
+dojob(NOMEJOB)
	:
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
    <-
    	.print( "Eu, um(a) ", ROLE, " vou fazer o job ", NOMEJOB );
    	!!realizarJob( NOMEJOB );
	.

@realizarJob[atomic]
+!realizarJob( NOMEJOB )
	:
		centerStorage(STORAGE)
	&	job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)

	<-	
		PASSOS_1 = [ goto( STORAGE ) ];
		!passosRetrieve( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);
		
		-steps( job, _ );
		+steps( job, PASSOS_3 );
		-expectedplan( job, _);
		+expectedplan( job, PASSOS_3 );
		+todo( job, 5 );
	.

+storage(STORAGE,_,_,_,_,ITENSTORAGE)
	:
		centerStorage( STORAGE )
	&	name( NAME )
	&	jobCommitment( NAME, JOB )
	&	job( JOB,_,_,_,_,ITENSJOB)
	&	temTodosItens( ITENSJOB, ITENSTORAGE )
	<-
		.print( "Chegou a hora de fazer o job ", STORAGE, ": ", LISTITENS );
		//!!realizarJob( JOB );
	.

+storage(STORAGE,_,_,_,_,LISTITENS)
	:
		centerStorage( STORAGE )
	&	name( NAME )
	&	jobCommitment( NAME, JOB )
	<-
		//.print( "nao ", STORAGE, ": ", LISTITENS );
		true;
	.

+!testarTrabalho
	:
		name( NAME )
	&	jobCommitment( NAME,JOB )
	&	not job( JOB,_,_,_,_,_ )
	&	step( STEP )
	<-
		.print( STEP, "-Acabou o tempo para eu fazer o job ", JOB );
		removeIntentionToDoJob( NAME, JOB );
	.

+!testarTrabalho<-true.

-todo(job,_)
	: 	jobCommitment(NAME,NOMEJOB) &
		name( NAME )				&
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		removeIntentionToDoJob(NAME, NOMEJOB);
	.

+!passosRetrieve( [], LISTA, RETORNO )
	:
		true
	<-
		RETORNO = LISTA;
	.

+!passosRetrieve( [required(ITEM, QTD)|T], LISTA, RETORNO )
	:
		repeat( retrieve(ITEM,1) , QTD , [] ,RR )
	<-
		.concat(LISTA, RR, N_LISTA);
		!passosRetrieve( T, N_LISTA, RETORNO);
	.
