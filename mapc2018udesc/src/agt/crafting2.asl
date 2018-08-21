dependencelevel(ITEM,LEVEL) :-  
    		item(ITEM,_,_,parts([HPARTS|TPARTS])) 	&
    		item(HPARTS,_,_,parts(PARTS))			&
    		biggerlevel (PARTS,XLEVEL) 				&
    		biggerlevel (TPARTS,YLEVEL)				&	
			LEVEL = math.max(XLEVEL,YLEVEL)+1.			    		
dependencelevel(ITEM,0) :-  
    		item(ITEM,_,_,parts([])).
    		
biggerlevel([],LEVEL):-LEVEL = 0.
biggerlevel(PARTS,LEVEL):-
			.member(X,PARTS) 		 	&
    		dependencelevel(X,LEVEL) 	&
     		not (.member(Y,PARTS) 		&
     			 dependencelevel(Y,YL)	&
     			 YL>LEVEL).
     			 
highlevel(ITEM,LEVEL):- item(ITEM,_,_,_)&
    		dependencelevel(ITEM,LEVEL)	&
     		not (item(IT,_,_,_) 		&
     			 dependencelevel(IT,YL)	&
     			 YL>LEVEL).

+!callCraftComPartsWithDelay: agentid("15") 
	<-
		.wait(step(1));
		for (item(ITEM,_,_,parts(P)) & not P=[]) {
			?dependencelevel(ITEM,LEVEL);
			+dependencelevel(ITEM,LEVEL);
		}
		?highlevel(_,HL);
		for (item(ITEM,_,_,parts(P)) & not P=[]) {
			?dependencelevel(ITEM,LEVEL);
			+numberAgRequired(ITEM,HL-LEVEL+1);
			.broadcast(tell,numberAgRequired(ITEM,HL-LEVEL+1));
		}
		.findall(X,numberAgRequired(_,X),LTMP);
		+numberTotalCraft(math.sum(LTMP));
		
		!!callCraftComParts;
	.

+!callCraftComPartsWithDelay: not agentid("15")
	<- true.
//@initccp[atomic]	
+numberAgRequired(_,_)[source(S)]: not S=self &
				.count(item(_,_,_,parts(P)) & not P=[]) = 
			  	.count(numberAgRequired(_,_))
	<-
		!initCraftComParts;
	.	
	
+!initCraftComParts: true	
	<-		
		.findall(X,numberAgRequired(_,X),LTMP);
		+numberTotalCraft(math.sum(LTMP));		
		!!callCraftComParts;
	.

+!callCraftComParts :	role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  										&
						ROLE\==drone 															& 
						name(NAMEAGENT) 														&
						numberTotalCraft(NTC)													&
						.count(craftCommitment(_,_))<NTC	 									&
						centerStorage(STORAGE) 													&	
						centerWorkshop(WORKSHOP) 												&
						not craftCommitment(NAMEAGENT,_) 										&
						not gatherCommitment(NAMEAGENT,_)
		<-
			?gocraft(ITEM,ROLE,QTD);
			addCraftCommitment(NAMEAGENT, ITEM,QTD);
			.print("commited with ",ITEM);
			!!upgradecapacity;
			!!craftComParts;
		.

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
//		+steps( upgradecapacity, SETUPLOAD);
//		-expectedplan( upgradecapacity, _);
//		+expectedplan( upgradecapacity, SETUPLOAD);
//		+todo(upgradecapacity,8.5);
		+task(upgradecapacity,8.5,SETUPLOAD,[]);	
	.

+!upgradecapacity:true
	<- true.

+!callCraftComParts	:role(drone,_,_,_,_,_,_,_,_,_,_)|
				 	 (numberTotalCraft(NTC)					&			
				 	 .count(craftCommitment(_,_))<NTC)	  
		<- true; .

-!callCraftComParts: true
		<- !!callCraftComParts;	.	
			
//@craftComPart[atomic]
+!craftComParts:	
		role(ROLE,_,_,LOAD,_,_,_,_,_,_,_)  										&
		name(NAMEAGENT) 														&
		centerStorage(STORAGE) 													&	
		centerWorkshop(WORKSHOP) 												&
		craftCommitment(NAMEAGENT,ITEM) 										
	<-					
		?item(ITEM,_,roles(LROLES),parts(LPARTS));			
		.difference(LROLES,[ROLE],OTHERROLES);
		?retrieveitensrule(LPARTS, [], RETRIEVELIST);				
		.concat( [goto(STORAGE)], RETRIEVELIST, 
				 [goto(WORKSHOP), help(OTHERROLES), 
				  assemble(ITEM), goto(STORAGE),
	   			  store(ITEM,1) ],
				PLAN);
//		.wait(	storage(storage5,_,_,_,_,LSTORAGE) &
//				minimumqtd(LPARTS,LSTORAGE) );
//		+steps( craftComParts, PLAN);
//		-expectedplan( craftComParts, _);
//		+expectedplan( craftComParts, PLAN);
//		+todo(craftComParts,8);
		+task(craftComParts,8,PLAN,[]);		
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
		+task(help,8.2,[goto(WORKSHOP), 
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

-task(craftComParts,8,_,_):
	name(NAMEAGENT) 				& 
	craftCommitment(NAMEAGENT,ITEM)
<-
	.print("produziu ",ITEM)
	!!craftComParts;
.	