+step( _ ): ( role(truck,_,_,_,_,_,_,_,_,_,_) | role(car,_,_,_,_,_,_,_,_,_,_) | role(motorcycle,_,_,_,_,_,_,_,_,_,_)) & 
		lastAction(X)& 
		X==noAction&
		resourceNode(A,B,C,D)[source(_)] &
		route([])& not doing(visit)   
<-
	-+item_carregar(D);
	-+doing(visit);
	action( goto( B, C) )
.
//criar o build visit steps

+step( _ ): doing(visit) &
			route([]) &
			load( CAPACIDADEATUAL ) &
			role(_,_,_, CAPACIDADEBASE,_,_,_,_,_,_,_) &
			CAPACIDADEATUAL<(CAPACIDADEBASE-10)
<-
	-+doing(gather);
	action(gather);
.

+step( _ ): pegou_itens & 
				not esta_resource_node &
				route([])&
				load( CAPACIDADEATUAL ) &
  				role(_,_,_,CAPACIDADEBASE,_,_,_,_,_,_,_) &
 				CAPACIDADEATUAL>=(CAPACIDADEBASE-10)
<-
	-pegou_itens;
	+esta_no_workshop;
	?nearworkshop(Facility);
	action(goto(Facility));
.

+step( _ ): esta_no_workshop & 
					route([])&
				not pegou_itens
<-	
	-esta_no_workshop;
	?item_carregar(ITEM);
	action(assemble(ITEM));

.
+step( _ ): esta_resource_node &
 				route([]) &
  				load( CAPACIDADEATUAL ) &
  				role(_,_,_, CAPACIDADEBASE,_,_,_,_,_,_,_) &
 				CAPACIDADEATUAL==(CAPACIDADEBASE-10)
<-
	+toPraticamenteCheio;
	action(noAction);
	-+doing(nothing);
	?hasItem(ITEM,QUANT);
	.print("Item ",ITEM," QUANT ",QUANT)
	.broadcast(tell,hasItem(ITEM,QUANT));
.


+step( _ ): not route([])
<-
	action( continue );
	?name(NOME);
	?step(PASSO);
	?charge(CARGA);
	?routeLength(TAMANHOROTA);
	?role(PAPEL,_,_,_,_,_,_,_,_,_,_);
	.print("EU SOU O AGENTE ",NOME," SOU UM ",PAPEL," NO PASSO ",PASSO," A MINHA CARGA É ",
		CARGA," E O TAMANHO DA MINHA ROTA É ",TAMANHOROTA
	);
.
