{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("exploration.asl") }
{ include("gathering.asl") }
//{ include("crafting2.asl") }
{ include("crafting.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
{ include("job.asl") }
{ include("mission.asl") }
{ include("construcao_pocos.asl")}
{ include("restartround.asl")}

@consume_steps[atomic]
+!consumestep: 
				lastActionResult( successful )			& 
				doing(LD)								& 
				task(LD,P,[ACT|T],EXECUTEDPLAN)			&
				//steps(LD,[ACT|T])						&
				lastAction(RLA)							&
				route(ROUTE)							&
				RLA\==noAction							&
				(((RLA=continue | RLA=goto) & ROUTE==[]) |
				  (RLA\==continue & RLA\==goto))
				  						
	<-	
			if (T=[]) {
				-task(LD,P,[ACT|T],EXECUTEDPLAN);	
			}
			else {
				-task(LD,P,[ACT|T],EXECUTEDPLAN)	
				+task(LD,P,T,[ACT|EXECUTEDPLAN])	
			}
	.
+!consumestep: true
	<-true.
	


+!whattodo
	:	.count((task(TD,_,_,_) & not waiting(TD,_)) , 0)
	<-	
		-doing(_);
	.
	
+!whattodo
	:	.count((task(TD,_,_,_) & not waiting(TD,_)), QTD) &
			QTD > 0
	<-			
		
		?priotodo(TASK);
		-+doing(TASK);
		!checkRollback;
	.

+!checkRollback:not route([]) 				&
				lastDoing(LD) 				& 
				doing(D) 					& 
				LD\==D 						& 
				//steps(LD,L)		&
				task(LD,P,PLAN,EXECUTEDPLAN)&
				LD=exploration	
	<-
			?lat(LAT);
			?lon(LON);
			-task(LD,P,PLAN,EXECUTEDPLAN);
			+task(LD,P,[goto(LAT,LON)|PLAN],EXECUTEDPLAN);		
			//+steps(LD, [goto(LAT,LON)|L]);
	.
	
+!checkRollback:lastDoing(LD) 	& 
				doing(D) 		& 
				LD\==D 			& 
				steps(LD,L)		&
				not job( JOB,_,_,_,_,_ ) 
	<-
		true.	

+!checkRollback:lastDoing(LD) 				& 
				doing(D) 					& 
				LD\==D 						& 
				//steps(LD,L)			&
				task(LD,P,PLAN,EXECUTEDPLAN)&
				LD\==exploration			&
				PLAN=[HL|_]					&
				not (HL=goto(_) |HL=goto(_,_)) 	
	<-
			//?expectedplan( LD, EXPP);
			//.length(EXPP,QTDEXPP);
			//.length(L,QTDL);
			//?rollbackcutexpectedrule(EXPP, QTDEXPP-QTDL, LDONED);
			//.reverse(LDONED,RLDONED);
			?rollbackrule([goto(_),goto(_,_)], EXECUTEDPLAN, RACTION);			
			//.print("rollback ",LD,": ",[RACTION| L]);									
			-task(LD,P,PLAN,EXECUTEDPLAN);
			+task(LD,P,[RACTION|PLAN],EXECUTEDPLAN);
	.

+!checkRollback :true
	<- true .

@s1[atomic]
+!do: route(R) &lastDoing(X) & doing(X) & not R=[]
	<-	
		action(continue );
.

@s2[atomic]
+!do: 			not route([]) 		&
				lastDoing(Y) 		& 
				doing(X) 			& 
				Y\==X 				&
				task(X,_,[ACT|T],_) &
				task(Y,_,_,_) 		& 
				//steps(X,[ACT|T])	& 
				//steps(Y,L)		&
				Y=exploration	
	<-
			-+lastDoing(X);
    		action(ACT);
	. 

@docrafthelp[atomic]
+!do: 
	doing(craftComParts) & 
	//steps( craftComParts, [help(OTHERROLES)|T])
	 task(craftComParts,P,[help(OTHERROLES)|T],EXECUTEDPLAN) 			
	<-
		.length(OTHERROLES,BARRIER);
		+waiting(craftComParts,BARRIER);
		!!supportCraft(OTHERROLES);
		-task(craftComParts,P,[help(OTHERROLES)|T],EXECUTEDPLAN);
		+task(craftComParts,P,T,EXECUTEDPLAN);
//		-steps( craftComParts, _);
//		+steps( craftComParts, T);
		action(noAction);
	.

@docrafthelp1[atomic]
+!do: 
	doing(help)		& 
	//steps( help, [ready_to_assist(WHONEED)|T])
	task(help,P,[ready_to_assist(WHONEED)|T],EXECUTEDPLAN) 			
	<-
		.send(WHONEED, achieve, ready_to_assist);
		-task(help,P,[ready_to_assist(WHONEED)|T],EXECUTEDPLAN);
		+task(help,P,T,EXECUTEDPLAN);
//		-steps( help, _);
//		+steps( help, T);
		action( noAction );
	.

@dogenerico[atomic]
+!do: 	
		doing(DOING) 	& 
		task(DOING,_,[ACT|T],_)
	<-		
		-+lastDoing(DOING);
		action( ACT );
	.
	
@donothing[atomic]
+!do: true
	<-
		action( noAction );
	.

@step[atomic]	
+step( S ): true
	<-
		!testarTrabalho;
		!testarMission;
		!consumestep;
		!whattodo;
		!do;
	.