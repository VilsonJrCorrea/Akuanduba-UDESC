minimumqtd([HLPARTS|TLPARTS],LSTORAGE) :- 
					(	.member(item(HLPARTS,QTD,_),LSTORAGE)	& 
						QTD>2									&
						minimumqtd (TLPARTS,LSTORAGE)).
minimumqtd([],LSTORAGE).

+!callCraftComPartsWithDelay: true
	<-
		.wait(step(3));
		!!callCraftComParts;
	.

+!callCraftComParts :	role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  										&
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
			.print("Commitment ",ITEM);
			!!craftComParts;
		.

+!callCraftComParts	:role(drone,_,_,_,_,_,_,_,_,_,_)|
				 	 (.count(craftCommitment(_,_))>=.count(item(_,_,_,parts(P))& P\==[])) 
		<- true; .

-!callCraftComParts: true
		<- !!callCraftComParts;	.		

+!craftComParts:	
		role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  										&
		name(NAMEAGENT) 														&
		centerStorage(STORAGE) 													&	
		centerWorkshop(WORKSHOP) 												&
		craftCommitment(NAMEAGENT,ITEM) 										
	<-					
		?item(ITEM,_,roles(LROLES),parts(LPARTS));			
		.difference(LROLES,[ROLE],OTHERROLES);
		?sumvolrule(LPARTS,VOL);
		if (LOAD<VOL) {
			?nearshop(SHOP);
			?upgrade(load,_,SIZE);
			QTDUPGRADE = math.ceil((VOL-LOAD)/SIZE);
			?repeat(upgrade(load) , QTDUPGRADE , [] , RUPGRADE );
			SETUPLOAD = [goto(SHOP)|RUPGRADE ];
		}	
		else {
			SETUPLOAD = [];
		}
		?retrieveitensrule(LPARTS, [], RETRIEVELIST);				
		.concat( SETUPLOAD, [goto(STORAGE)], RETRIEVELIST, 
				 [goto(WORKSHOP), help(OTHERROLES), 
				  assemble(ITEM), goto(STORAGE),
	   			  store(ITEM,1) ],
				PLAN);
		.wait(	storage(storage5,_,_,_,_,LSTORAGE) &
				minimumqtd(LPARTS,LSTORAGE) );
		+steps( craftComParts, PLAN);
		-expectedplan( craftComParts, _);
		+expectedplan( craftComParts, PLAN);
		+todo(craftComParts,8);	
	.

+!supportCraft(OTHERROLES):
				name(WHONEED) & centerWorkshop(WORKSHOP)
			<-	
				 PID = math.floor(math.random(100000));
				 !selectiveBroadcast(OTHERROLES,PID,WORKSHOP);					
			.
	
+!selectiveBroadcast(OTHERROLES,PID,WORKSHOP)
	: not demanded_assist(PID)
		<-
			for (.member (OTHERROLE,OTHERROLES) &
				 partners(OTHERROLE,A) 			& 
				 not craftCommitment(A,_) 		&
				 not gatherCommitment(A,_)		) {
				.send (A, achieve, help(WORKSHOP, PID));
			}
			.wait(100);
			!!selectiveBroadcast(OTHERROLES,PID,WORKSHOP)
		.		

-!selectiveBroadcast(OTHERROLES,PID,WORKSHOP): true
	<-
		//.print("PAREI DE PEDIR ->",help(WORKSHOP, PID));
		true;
	.
		
@helper1[atomic]
+helper(PID, COST): .count(helper(PID, _),N) & N>1 & not demanded_assist(PID)
	<-
		?name(WHONEED);
		?centerWorkshop(WORKSHOP);
		?lesscost (PID, AGENT);
		+demanded_assist(PID);
		.send (AGENT, achieve, confirmhelp( WORKSHOP, WHONEED));
		for (helper(PID, _)[source(AGENTDISMISSED)] & not AGENT=AGENTDISMISSED ) {
			.send (AGENTDISMISSED, achieve, dismisshelp);
		}
		
		.abolish(helper(PID, _)[source(_)] ); 
	.

@helper2[atomic]
+helper(PID, COST)[source(AGENTDISMISSED)]: demanded_assist(PID)
	<-
		.send (AGENTDISMISSED, achieve, dismisshelp);
		-helper(PID, COST)[source(AGENTDISMISSED)];
	.

	
@helper3[atomic]
+helper(PID, COST): .count(helper(PID, _),1)
	<-
		true;
	.

@help1[atomic]
+!help(WORKSHOP, PID)[source(AGENT)] : not todo(help, _)  & not lockhelp
	<-	
		//.print("INTERESSADO NO TRAMPO DO AGENTE ",AGENT);	
		+lockhelp;
		?lat(XA);
		?lon(YA);
		?workshop(WORKSHOP,XB,YB);
		?calculatedistance( XA, YA, XB, YB, COST );
		.send(AGENT, tell, helper(PID, COST));
	.

@help2[atomic]	
+!help( WORKSHOP, PID): todo(help, _) | lockhelp
	<-	
	//.print("JA ESTOU COMPROMETIDO");
	true;	
	.

@help3[atomic]
+!confirmhelp(WORKSHOP, QUEMPRECISA):
	true
	<-
		-lockhelp;
		?role(ROLE,_,_,_,_,_,_,_,_,_,_);
		//.print("Vou ajudar ",QUEMPRECISA, " e sou um ", ROLE );		
		+steps(help, [goto(WORKSHOP), ready_to_assist(QUEMPRECISA), assist_assemble(QUEMPRECISA) ]);
		-expectedplan( help, _);
		+expectedplan( help, [goto(WORKSHOP), ready_to_assist(QUEMPRECISA), assist_assemble(QUEMPRECISA) ]);
		+todo(help, 6);
	.

@help4[atomic]
+!dismisshelp:
	true
	<-
		-lockhelp;
	.
	
@readytoassist
+!ready_to_assist:waiting(craftComParts,BARRIER)
	<- 
		-+waiting(craftComParts,BARRIER-1);
	.
	
+waiting(craftComParts,0): true
	<-
		//.print("removeu o waiting");
		-waiting(craftComParts,0);
	.

-todo(craftComParts,8):
	name(NAMEAGENT) 				& 
	craftCommitment(NAMEAGENT,ITEM)
<-
	//.print("produziu ",ITEM)
	!!craftComParts;
.	