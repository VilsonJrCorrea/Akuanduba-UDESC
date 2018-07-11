
+job(NOMEJOB,_,_,_,_,_)
 :  not jobCommitment(NOMEJOB)   & 
    name(A)           			 & 
    not doing(_)       		 	  
  <- 
  	?step(S);
    +commitjob(NOMEJOB);
    addIntentionToDoJob(NOMEJOB);  
    .print("---- ",S," ---------------> vou fazer a entrega: ",NOMEJOB);
    //!realizarJob( NOMEJOB ); 
  . 
 
+dojob(NOMEJOB) : true 
    <-
    	.print("---------------------> vou fazer a entrega: ",NOMEJOB);
	.

+!realizarJob( NOMEJOB )
	:
		job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS)
	&	role(motorcycle,_,_,_,_,_,_,_,_,_,_)
	&	storageCentral(STORAGE)
	//	Apenas poder testa com jobs mais simples.
	//	required(item10,1)
	&	.difference(ITENS, [required(item1,_),required(item2,_), required(item3,_), required(item4,_)],RESULT)
	&	RESULT == []
	<-
		PASSOS_1 = [ goto( STORAGE ) ];
		!passosGathering( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		.concat( PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);
		.print( ">>>>>>>>>>>>>>>>>>>>", NOMEJOB, " ", PASSOS_3 );
		
		-steps( job, _ );
		+steps( job, PASSOS_3 );
		+todo(job,8);
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