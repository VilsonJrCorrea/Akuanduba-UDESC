+simEnd: not simEnded
	<-
		+simEnded;
		resetBlackboard;
   		.drop_all_intentions;
   		.drop_all_desires;
    	.drop_all_events;	

		.abolish(resourcenode(_,_,_,_));
		.abolish(centerStorage(_));
		.abolish(centerWorkshop(_));
		.abolish(doing(_));
		.abolish(lastDoing(_));
		.abolish(laststep(_));	
		.abolish(numberTotalCraft(_));
		.abolish(numberAgRequired(_,_));	
		.abolish(waiting(_,_));
		.abolish(ponto(_,_));
		.abolish(demanded_assist(_));
		.abolish(lockhelp);
		
		//irão apitar pois no proximo round tem que construir tudo de novo. 
		.abolish(todo(_,_));
		.abolish(steps(_,_));
		
		//os drones irão apitar erro 
		.abolish(started);
		
	.
