{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
	
{ include("regras.asl") }

job(job7,storage2,425,23,120,[required(item4,1),required(item6,1),required(item7,1),required(item8,1)]).
storage(storage5,48.87113,2.33853,11454,398,[item(item0,20,0),item(item1,22,0),item(item3,20,0)]).

!start.

+!start
	:
		job(_,_,_,_,ITENSJOB) &
		storage(_,_,_,_,_,ITENSSTORAGE)
	<-
		?procurarItemSTORAGE( item0, 2, ITENSSTORAGE );
		.print("Funcionou")
	.

