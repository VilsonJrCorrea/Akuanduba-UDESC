// Agent verificador_pontos in project mapc2018udesc

/* Initial beliefs and rules */

/* Initial goals */

lista_pontos( [] ).
!start.

/* Plans */

+!start
	: true
	<- 	for ( shop( _, LAT, LON) ){
			+ponto( LAT, LON );
			addPonto( LAT, LON );
		};
		for ( dump( _, LAT,LON ) ){
			+ponto( LAT, LON );
			addPonto( LAT, LON );
		}
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
