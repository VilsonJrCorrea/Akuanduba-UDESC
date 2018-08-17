{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
	
{ include("regras.asl") }

//
//hasItem( item0, 1 ).
//hasItem( item1, 3 ).
//hasItem( item2, 2 ).
//hasItem( item4, 2 ).

!start.

+!start : true <-
	?buildStore( [], R );
	.print( R );
.