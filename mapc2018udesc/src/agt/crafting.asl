+!callCraftComPartsWithDelay: true
	<-
		.wait(step(3));
		!!craftComParts;
	.

+!craftComParts:	
		role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  										&
		ROLE\==drone 															& 
		name(NAMEAGENT) 														&
		(.count(craftCommitment(_,_))<.count(item(_,_,_,parts(P)) & P\==[]))	&
		centerStorage(STORAGE) 													&	
		centerWorkshop(WORKSHOP) 												&
		not craftCommitment(NAMEAGENT,_) 										&
		not gatherCommitment(NAMEAGENT,_)
	<-				
		?gocraft(ITEM,ROLE);
		addCraftCommitment(NAMEAGENT, ITEM);				
		?item(ITEM,_,roles(LROLES),parts(LPARTS));
		.print("Commitment ",ITEM," ",roles(LROLES)," ",parts(LPARTS));
		.difference(LROLES,[ROLE],[OTHERROLE|_]);								
		?retrieveitensrule(LPARTS, [], RETRIEVELIST);				
		.concat( [goto(STORAGE)], RETRIEVELIST, 
				 [goto(WORKSHOP), help(OTHERROLE), 
				  assemble(ITEM), goto(STORAGE),
	   			  store(ITEM,1) ],
				PLAN);
		+steps( craftComParts, PLAN);
		+todo(craftComParts,8);	
	.

+!craftComParts	: role(drone,_,_,_,_,_,_,_,_,_,_)|
				  (.count(craftCommitment(_,_))>=.count(item(_,_,_,parts(P))& P\==[])) 
		<- true; .

-!craftComParts: true
	<-
		!!craftComParts;
	.

+!supportCraft(OTHERROLE):
				name(WHONEED) & centerWorkshop(WORKSHOP)
			<-	
				 PID = math.floor(math.random(100000));
				for (partners(OTHERROLE,A) & 
					 not craftCommitment(A,_) &
					 not gatherCommitment(A,_)
				) {
					.send (A, achieve, help(WORKSHOP, PID));
				}							
			.

+helper(PID, COST): .count(helper(PID, _),N) & N>1
	<-
		?name(WHONEED);
		?centerWorkshop(WORKSHOP);
		?lesscost (PID, AGENT);
		.send (AGENT, achieve, confirmhelp( WORKSHOP, WHONEED));
		.abolish(helper(PID, _) ); 
	.

+helper(PID, COST): .count(helper(PID, _),1)
	<-
		true;
	.

@help1[atomic]
+!help(WORKSHOP, PID)[source(AGENT)] : not todo(help, _)  & not lockhelp
	<-	
		.print("INTERESSADO NO TRAMPO DO AGENTE ",AGENT);	
		+lockhelp;
		?lat(XA);
		?lon(YA);
		?workshop(WORKSHOP,XB,YB);
		?calculatedistance( XA, YA, XB, YB, COST );
		.send(AGENT, tell, helper(PID, COST));
	.

@help2[atomic]	
+!help( WORKSHOP, PID): todo(help, _) | lockhelp
	<-	true.

@help3[atomic]
+!confirmhelp(WORKSHOP, QUEMPRECISA):
	true
	<-
		-lockhelp;
		?role(ROLE,_,_,_,_,_,_,_,_,_,_);
		.print("Vou ajudar ",QUEMPRECISA, " e sou um ", ROLE );		
		+steps(help, [goto(WORKSHOP), ready_to_assist(QUEMPRECISA), assist_assemble(QUEMPRECISA) ]);
		+todo(help, 6);
	.
	
@readytoassist
+!ready_to_assist:true
	<- 
		-waiting(craftComParts);
	.