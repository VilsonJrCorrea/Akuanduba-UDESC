passosRetrieve( [], LISTA, RETORNO ) :- RETORNO = LISTA.
passosRetrieve( [required(ITEM, QTD)|T], LISTA, RETORNO ):-
		repeat( retrieve(ITEM,1) , QTD , [] ,RR ) &
		.concat(LISTA, RR, N_LISTA) &
		passosRetrieve( T, N_LISTA, RETORNO).

@mission[atomic]
+mission(NOMEMISSION,LOCALENTREGA,RECOMPENSA,STEPINICIAL,STEPFINAL,DESCONHECIDO1,DESCONHECIDO2,_,ITENS)
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
    	addIntentionToDoMission(NAME, NOMEMISSION);
  .
 
+domission( NOMEMISSION )
	:
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
    <-
    	.print( "Eu, um(a) ", ROLE, " vou fazer a mission ", NOMEMISSION );
    	!!realizarMission( NOMEMISSION );
	.

@realizarMission[atomic]
+!realizarMission( NOMEMISSION )
	:
		true

	<-	
		.wait(centerStorage(STORAGE)
	&	mission(NOMEMISSION,LOCALENTREGA,RECOMPENSA,STEPINICIAL,STEPFINAL,DESCONHECIDO1,DESCONHECIDO2,_,ITENS));
		PASSOS_1 = [ goto( STORAGE ) ];
		?passosRetrieve( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEMISSION )], PASSOS_3);

		-steps( mission, _ );
		+steps( mission, PASSOS_3 );
		-expectedplan( mission, _);
		+expectedplan( mission, PASSOS_3 );
		+todo( mission, 5 );
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


+!testarMission
	:
		name( NAME )
	&	missionCommitment( NAME,MISSION )
	&	not mission(MISSION,_,_,_,_,_,_,_,_)
	&	step( STEP )
	<-
		.print( STEP, "-Acabou o tempo para eu fazer a mission ", MISSION);
		!rollBackMission;
		removeIntentionToDoMission( NAME, MISSION );
		!removetodo(mission);
	.


+!testarMission<-true.

+!rollBackMission
	:
		hasItem( _, _)
	&	centerStorage( STORAGE )
	<-
		?buildStore( [], LISTAFINAL );
		.print( LISTAFINAL );
		
		.concat( [goto(STORAGE)], LISTAFINAL, PASSOS );
		
		-steps( rollBackMission, _ );
		+steps( rollBackMission, PASSOS );
		-expectedplan( rollBackMission, _);
		+expectedplan( rollBackMission, PASSOS_3 );
		+todo( rollBackMission, 8.8 );
		
		.print( "Adicionei plano para devolver os itens na mission" );
	.

+!rollBackMission
	:
		true
	<-
		.print( "Nada para devolver" );
	.

-todo(mission,_)
	: 	jobCommitment(NAME,NOMEMISSION) &
		name( NAME )				&
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		removeIntentionToDoMission(NAME, NOMEMISSION);
	.
