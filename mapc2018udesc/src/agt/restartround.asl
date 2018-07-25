roundnumber(0).

@end[atomic]
+simEnd: not simEnded
	<-
		+simEnded;
		.drop_all_events;		
   		.drop_all_intentions;
   		.drop_all_desires;

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
		
		//irao apitar pois no proximo round tem que construir tudo de novo. 
		.abolish(todo(_,_));
		.abolish(steps(_,_));

		?roundnumber(RN);
		-+roundnumber(RN+1);
		resetBlackboard(RN+1);		
	
		//os drones irao apitar erro 
		.abolish(started);	
	.
