+!callCraftComPartsWithDelay:true
	<-
		.wait(step(1));
		for (item(ITEM,_,_,parts(P)) & P\==[]) {
			.count(item(_,_,_,parts(PARTS)) & .member(ITEM,PARTS),QTD);
			+numberAgRequired(ITEM,QTD+1);
			TMP=TMP+QTD+1;
		}
		.findall(X,numberAgRequired(_,X),LTMP);
		+numberTotalCraft(math.sum(LTMP));
			
		.wait(step(3));
		!!callCraftComParts;
	.

+!callCraftComParts :	role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  	&
						ROLE\==drone 						& 
						name(NAMEAGENT)						&
						not (lastMotorcycle(NAMEAGENT)|lastCar(NAMEAGENT)) &
						numberTotalCraft(NTC)				&
						.count(craftCommitment(_,_))<=NTC	&
						not craftCommitment(NAMEAGENT,_) 	&
						not gatherCommitment(NAMEAGENT,_)
		<-
			.wait(step(X) & X>79);
			?gocraft(ITEM,ROLE,QTD);
			
			addCraftCommitment(NAMEAGENT, ITEM,QTD);
			.print("commited with ",ITEM);
			!!upgradecapacity;
			!!craftComParts;
		.

+!callCraftComParts	:role(drone,_,_,_,_,_,_,_,_,_,_)
	<- true.

+!callCraftComParts	
	:numberTotalCraft(NTC)					&			
	 .count(craftCommitment(_,_))==NTC	  
		<- 
			true;
			//.print(NTC," - ",.count(craftCommitment(_,_)));
		 .

-!callCraftComParts: true
		<- //.wait (25); .print("TENTE OUTRA VEZ");
			!!callCraftComParts;	.		


+!upgradecapacity:	
		role(ROLE,_,_,LOAD,_,_,_,_,_,_,_) 		&
		name(NAMEAGENT) 			     		&
		craftCommitment(NAMEAGENT,ITEM)			&
		item(ITEM,_,_,parts(LPARTS))			&
		sumvolrule(LPARTS,VOL)					&
		LOAD<VOL	 										
	<-					
		?nearshop(SHOP);
		?upgrade(load,_,SIZE);
		QTDUPGRADE = math.ceil((VOL-LOAD)/SIZE);
		?repeat(upgrade(load) , QTDUPGRADE , [] , RUPGRADE );
		SETUPLOAD = [goto(SHOP)|RUPGRADE ];
		!addtask(upgradecapacity,8.5,SETUPLOAD,[]);	
		
	.

+!upgradecapacity:true
	<- true.

+!craftComParts:	
		role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  										&
		name(NAMEAGENT) 														&
		centerStorage(STORAGE) 													&	
		centerWorkshop(WORKSHOP) 												&
		craftCommitment(NAMEAGENT,ITEM) 										
	<-			
		!removetask(fastgathering,_,_,_);		
		!!dropAll;
		?item(ITEM,_,roles(LROLES),parts(LPARTS));			
		.difference(LROLES,[ROLE],OTHERROLES);
		?retrieveitensrule(LPARTS, [], RETRIEVELIST);				
		.concat( [goto(STORAGE)], RETRIEVELIST, 
				 [goto(WORKSHOP), help(OTHERROLES), 
				  assemble(ITEM), goto(STORAGE),
	   			  store(ITEM,1) ],
				PLAN);

//		.print("Esperando ",ITEM);
//		.wait(	storage(STORAGE,_,_,_,_,LSTORAGE) &
//				minimumqtd(LPARTS,LSTORAGE) );
		!addtask(craftComParts,8,PLAN,[]);
	.

+!supportCraft(OTHERROLES):
				name(WHONEED) & centerWorkshop(WORKSHOP)
			<-	
				 PID = math.floor(math.random(100000));
				 !!selectiveBroadcast(OTHERROLES,PID,WORKSHOP);					
			.
	
+!selectiveBroadcast(OTHERROLES,PID,WORKSHOP)
	: not demanded_assist(PID)
		<-
			for (.member (OTHERROLE,OTHERROLES) &
				 partners(OTHERROLE,A) 			)//& 
//				 not craftCommitment(A,_) 		&
//				 not gatherCommitment(A,_)		) 
				 {
				.send (A, achieve, help(WORKSHOP, PID));
			}
			.wait(50);
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
//		+steps(help, [goto(WORKSHOP), ready_to_assist(QUEMPRECISA), assist_assemble(QUEMPRECISA) ]);
//		-expectedplan( help, _);
//		+expectedplan( help, [goto(WORKSHOP), ready_to_assist(QUEMPRECISA), assist_assemble(QUEMPRECISA) ]);
//		+todo(help, 8.2);//6
		!addtask(help,8.2,[goto(WORKSHOP), 
						ready_to_assist(QUEMPRECISA), 
						assist_assemble(QUEMPRECISA)],[]);
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


//-todo(craftComParts,8):
-task(craftComParts,8,[_|[]],_):
	name(NAMEAGENT) 				& 
	craftCommitment(NAMEAGENT,ITEM)
<-
	.print("produziu ",ITEM)
	!!craftComParts;
.	