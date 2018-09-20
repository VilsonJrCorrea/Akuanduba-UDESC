passosRetrieve( [], LISTA, RETORNO ) :- RETORNO = LISTA.

passosRetrieve( [required(ITEM, QTD)|T], LISTA, RETORNO ):-
repeat( retrieve(ITEM,1) , QTD , [] ,RR ) &
		.concat(LISTA, RR, N_LISTA) &
		passosRetrieve( T, N_LISTA, RETORNO).

//@mission[atomic]
+mission(NOMEMISSION,LOCALENTREGA,RECOMPENSA,STEPINICIAL,STEPFINAL,DESCONHECIDO1,DESCONHECIDO2,_,ITENS)
	:
		name( NAME )
	//&	not jobCommitment(NAME,_)
	&	not gatherCommitment( NAME, _ )
	&	not craftCommitment( NAME, _ )
//	& 	amilastfreetruck(_) //teste
	&	not missionCommitment( NAME, _ )
	&	step(STEPATUAL) & STEPATUAL>5 
    &	role(ROLE,_,_,CAPACIDADE,_,_,_,_,_,_,_)
	&	centerStorage(STORAGE)
	&	sumvolruleJOB( ITENS, VOLUMETOTAL )
	&	CAPACIDADE >= VOLUMETOTAL
	&	possuoTempoParaRealizarMISSION( NOMEMISSION, TEMPONECESSARIO )
	&	TEMPONECESSARIO <= ( STEPFINAL - STEPATUAL )
    <- 
    	addIntentionToDoMission(NAME, NOMEMISSION);
  .
 
+domission( NOMEMISSION )
	:
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
    <-
    	.print( "Eu, um(a) ", ROLE, " vou fazer a mission ", NOMEMISSION );
    	!dropAll;
    	!removetask(fastgathering,_,_,_);
    	!!realizarMission( NOMEMISSION );
	.

//@realizarMissionSimples[atomic]
+!realizarMission( NOMEMISSION )
	:
		centerStorage(STORAGE)
	&	mission(NOMEMISSION,LOCALENTREGA,RECOMPENSA,STEPINICIAL,STEPFINAL,DESCONHECIDO1,DESCONHECIDO2,_,ITENSMISSION)
	<-	
		PASSOS_1 = [ goto( STORAGE ) ];
		?passosRetrieve( ITENSMISSION, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEMISSION )], PASSOS_3);
		
		!addtask(mission,9,PASSOS_3,[]);
	.

+!realizarMission( NOMEMISSION )
	:
	true
	<-	
		.print( "Alguma coisa deu errado com o realizarMission e caiu aqui." );
	.


+!testarMission
	:
		name( NAME )
	&	missionCommitment( NAME,MISSION )
	&	not mission(MISSION,_,_,_,_,_,_,_,_)
	&	step( STEP )
	<-
		.print( STEP, "-Acabou o tempo para eu fazer a mission ", MISSION);
		!dropAll;
		removeIntentionToDoMission( NAME, MISSION );
		!removetask(mission,_,_,_);
	.


+!testarMission<-true.

-task(mission,_,[_|[]],_)
	: 	jobCommitment(NAME,NOMEMISSION) &
		name( NAME )				&
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		.print("entregou mission");
		removeIntentionToDoMission(NAME, NOMEMISSION);
	.
