+lastActionResult(failed_item_amount)
	: 	lastAction(store) & doing(dropAll)
	<-
		!removetask(dropAll,_,_,_);
	. 

//	 dismantle() = failed_location
+lastActionResult(failed_location) : lastAction(dismantle) & doing(desmantelar)
	<-
		!removetask(desmantelar,_,_,_);
	.