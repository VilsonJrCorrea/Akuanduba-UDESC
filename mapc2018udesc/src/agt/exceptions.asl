+lastActionResult(failed_item_amount)
	: 	lastAction(store) & doing(dropAll)
	<-
		!removetask(dropAll,_,_,_);
//		action(noAction);
	. 