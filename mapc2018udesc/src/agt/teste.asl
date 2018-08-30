{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
	
{ include("regras.asl") }

item(item0,5,roles([]),parts([])).
item(item1,9,roles([]),parts([])).
item(item2,6,roles([]),parts([])).
item(item3,5,roles([]),parts([])).
item(item4,10,roles([motorcycle,car]),parts([item2,item0,item3])).
item(item5,9,roles([car,drone]),parts([item1,item2,item0,item3])).
item(item6,7,roles([motorcycle,drone]),parts([item1,item4,item2,item5,item0,item3])).
item(item7,10,roles([motorcycle,drone]),parts([item4,item1,item2,item5,item6,item0,item3])).
item(item8,5,roles([car,truck]),parts([item2,item6,item0,item3])).

!start.

+!start
	:
		true
	<-
//		.random( N );
//		NN = N * .length( item(_,_,_,_) );

		.print( "abc" );
		.count( item( _,_,_,parts( [] ) ), N );
		.print( N );
	.

