+lastActionResult(failed_item_amount)
	: 	lastAction(store) & doing(dropAll)
	<-
		!removetask(dropAll,_,_,_);
//		action(noAction);
	. 


//	 dismantle() = failed_location
+lastActionResult(failed_location) : lastAction(dismantle) & doing(desmantelar)
	<-
		!removetask(desmantelar,_,_,_);
	.

+lastActionResult(failed_resources) : lastAction(upgradecapacity) & doing(upgradecapacity)
	<-
		!removetask(upgradecapacity,_,_,_);
	.
