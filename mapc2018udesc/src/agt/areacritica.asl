@addtask[atomic]
+!addtask(N,P,PL,EXP):true
	<-
		//.print("adicionou ",task(N,P,PL,EXP));
		+task(N,P,PL,EXP);
	.
	
@removetask[atomic]	
+!removetask(N,P,PL,EXP): true
	<-
		//.print("removeu ",task(N,P,PL,EXP));
		-task(N,P,PL,EXP);
	.	
	
@updatetask[atomic]
+!updatetask(N,P,PL,EXP):true
	<-
		//.print("atualizou ",task(N,P,PL,EXP));
		-task(N,_,_,_);
		+task(N,P,PL,EXP);
	.
	

