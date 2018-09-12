@addtask[atomic]
+!addtask(N,P,PL,EXP):true
	<-
		+task(N,P,PL,EXP);
	.
	
@removetask[atomic]	
+!removetask(N,P,PL,EXP): true
	<-
		-task(N,P,PL,EXP);
	.	
	
@updatetask[atomic]
+!updatetask(N,P,PL,EXP):true
	<-
		-task(N,_,_,_);
		+task(N,P,PL,EXP);
	.
	

