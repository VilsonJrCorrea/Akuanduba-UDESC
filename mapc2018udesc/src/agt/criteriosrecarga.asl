+step(0):  role(drone,_,_,_,_,_,_,_,_,_,_)
	<-
		+constante_folga(10);//1º - 1
		//a media que ele cumpre uma (distancia*velocidade)/tamanho da rota
		+minha_media_rota(0.0164832027127604)
	.
	
+step(0): role(motorcycle,_,_,_,_,_,_,_,_,_,_)
	<-
		+constante_folga(6);//1º - 4
		+minha_media_rota(0.0087916699505107)
	.
+step(0):  role(truck,_,_,_,_,_,_,_,_,_,_)
//         role(truck,2,3,100,300,10,15,300,700,50,100)[
	<-
		+constante_folga(8);
		+minha_media_rota(0.0039127580535210)
	.
+step(0):  role(car,_,_,_,_,_,_,_,_,_,_)
	<-
		+constante_folga(6);
		+minha_media_rota(0.0062490215077062)
	.
