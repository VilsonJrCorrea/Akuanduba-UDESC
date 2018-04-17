+step( _ ): not route([])
	<-
	action( continue );
	.
+step( _ ): role(truck,_,_,_,_,_,_,_,_,_,_) & 
			resourceNode(A,B,C,D)[source(_)] &
			route([])   
	<-
	action( goto( B, C) );
	.