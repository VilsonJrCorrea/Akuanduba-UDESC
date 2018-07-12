+!craftSemParts	:	role(truck,_,_,LOAD,_,_,_,_,_,_,_) 							  & 
					name(NAMEAGENT)					   							  & 
					(.count(gatherCommitment(_,_))<.count(item(_,_,_,parts([])))) &
				    not craftCommitment(NAMEAGENT,_)							  &
					not gatherCommitment(NAMEAGENT,_)
				
	<-	
	
		?gogather(ITEM);
		addGatherCommitment(NAMEAGENT, ITEM);
		.wait(resourceNode(_,LATRESOUR,LONRESOUR,ITEM));
		?item(ITEM,TAM,_,_);
		QTD = math.floor( (LOAD / TAM) ) ;		
		?repeat( gather, QTD, [], GATHERS );
		.wait(centerStorage(FS));
		.concat([goto(LATRESOUR, LONRESOUR)],GATHERS,[goto(FS),store(ITEM,QTD)],PLAN);
		+steps( craftSemParts, PLAN);
		+todo(craftSemParts,8);
	.
	
+!craftSemParts	:(role(ROLE,_,_,_,_,_,_,_,_,_,_) & ROLE \== truck )|
		(.count(gatherCommitment(_,_))>=.count(item(_,_,_,parts([]))))
		<-	
		true;
		.

-!craftSemParts: true
	<-
		!!craftSemParts;
	.	