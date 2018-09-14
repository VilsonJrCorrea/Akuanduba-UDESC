+lastActionResult(failed_item_amount)
	: 	lastAction(store) & doing(dropAll)
	<-
		.print("deu ruim no store");
		!removetask(dropAll,_,_,_);
	. 
	
-task(craftComParts,X,Y,Z):true 
	<-
//	 .print(task(craftComParts,X,Y,Z))
		true
	.	
