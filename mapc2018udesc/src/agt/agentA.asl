{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("exploration.asl") }
{ include("gathering.asl") }
{ include("crafting.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
//{ include("job.asl") }
{ include("construcao_pocos.asl")}

+resourceNode(A,B,C,D)[source(percept)]:
			not (resourceNode(A,B,C,D)[source(SCR)] &
			SCR\==percept)
	<-
		+resourceNode(A,B,C,D);
		.broadcast(tell,resourceNode(A,B,C,D));
	.

+simStart: not started
					<-
					+started;
					.wait(role(VEHICLE,_,_,_,_,_,_,_,_,_,_) &
						name(AGENT));					
					.broadcast(tell,partners(VEHICLE,AGENT));
					!!craftSemParts;
					!!callCraftComPartsWithDelay										
					!!buildPoligon;
					!!sendcentrals;
					!!exploration;
					.

+!sendcentrals
	:	name(agentA20)
	<-	
		.wait(step(1));
		?centerStorageRule(STORAGE); 
		+centerStorage(STORAGE);
		?centerWorkshopRule(WORKSHOP);
		+centerWorkshop(WORKSHOP);
		.broadcast(tell, centerWorkshop(WORKSHOP) );
		.broadcast(tell, centerStorage(STORAGE) );
.

+!sendcentrals : name(A) & A\== agentA20	
	<- true.

@consume_steps[atomic]
+!consumestep: 
				lastActionResult( successful )			& 
				lastDoing(LD)							& 
				steps(LD,[ACT|T])						&
				lastAction(RLA)							&
				route(ROUTE)							&
				RLA\==noAction							  						
	<-	
		if (RLA=continue | RLA=goto){
			if ( ROUTE==[]) {
				!refreshlastdoing(LD,T);
			}		
		}
		else {
			!refreshlastdoing(LD,T);
		} 
	.
+!consumestep: true
	<-true.
	
@at[atomic]
+!refreshlastdoing(LD,T) : true
	<-
			if (T=[]) {
				!removetodo(LD);
			}
			else {
				-steps(LD,_);
				+steps(LD,T);
			}
	.

@remove_todo_doing_steps[atomic]
+!removetodo(LD):true
<-
	-todo(LD,_);
	-doing(LD);
	-steps(LD,_);
.

+!whattodo
	:	.count((todo(TD,_) & not waiting(TD,_)) , 0)
	<-	
		-doing(_);
	.
	
+!whattodo
	:	.count((todo(TD,_) & not waiting(TD,_)), QUANTIDADE) &
			QUANTIDADE > 0
	<-	
		
		?priotodo(ACTION2);
		-+doing(ACTION2);
	.


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
				steps(X,[ACT|T])	& 
				steps(Y,L)		
	<-
		if (Y=exploration) {
			?lat(LAT);
			?lon(LON);
			-steps(Y, _ );
			+steps(Y, [goto(LAT,LON)| L]);
		}
		-+lastDoing(X);
    	action( ACT);
. 

@docrafthelp[atomic]
+!do: doing(craftComParts) & steps( craftComParts, [help(OTHERROLES)|T]) 			
	<-
		if (name(A) & craftCommitment(A,item4)){
			.print(chamando);	
		}		
		.length(OTHERROLES,BARRIER);
		+waiting(craftComParts,BARRIER);
		!!supportCraft(OTHERROLES);
		-steps( craftComParts, _);
		+steps( craftComParts, T);
		action(noAction);
	.

@docrafthelp1[atomic]
+!do: doing(help) & steps( help, [ready_to_assist(WHONEED)|T]) 			
	<-
		.send(WHONEED, achieve, ready_to_assist);
		-steps( help, _);
		+steps( help, T);
		action( noAction );
	.


@s18[atomic]
+!do: 	step(S) &
		doing(DOING) & steps( DOING, [ACT|T])			
	<-		
		-+lastDoing(DOING);
		-+acaoValida( ACT );
		if (ACT=assemble(_) | ACT=assist_assemble(_)){
			.print(S,": ",ACT);
		}
		action( ACT );
	.
	
+!do: true
	<-
		action( noAction );
	.
	
@s19[atomic]
+step( S ): (laststep(LS) & not LS=S) |
			 (not laststep(LS))
	<-
		-+laststep(S);
		!consumestep;
		!whattodo;
		!do;				
	.