package calculos;

import java.util.ArrayList;
import java.util.List;

public class Executar {
	public static void main(String[] args) {
		List<Ponto> lista = new ArrayList<>();
//		Ponto a = new Ponto( "A", 0.5, 0.5 ); lista.add( a );
//		Ponto b = new Ponto( "B", 1, 0 ); lista.add( b );
//		Ponto c = new Ponto( "C", 0, 1 ); lista.add( c );
//		Ponto d = new Ponto( "D", 1, 0.5 ); lista.add( d );
//		Ponto e = new Ponto( "E", 2, 1 ); lista.add( e );
//		Ponto f = new Ponto( "F", 1, 2 ); lista.add( f );
		
//		Ponto a = new Ponto( "A", 1, 2 ); lista.add( a );
//		Ponto b = new Ponto( "B", 0, 1 ); lista.add( b );
//		Ponto c = new Ponto( "C", 2, 1 ); lista.add( c );
//		Ponto d = new Ponto( "D", 0, 0 ); lista.add( d );
//		Ponto e = new Ponto( "E", 2, 0 ); lista.add( e );
//		Ponto f = new Ponto( "F", 1, 3 ); lista.add( f );
		
		Ponto a = new Ponto( "A", 1, 2 ); lista.add( a );
		Ponto b = new Ponto( "B", 0, 0); lista.add( b );
		Ponto c = new Ponto( "C", 3, 2 ); lista.add( c );
		Ponto d = new Ponto( "D", 4, 5 ); lista.add( d );
		Ponto e = new Ponto( "E", 6, 5 ); lista.add( e );
		Ponto f = new Ponto( "F", 3, 3 ); lista.add( f );
		Ponto g = new Ponto( "G", 2, 2 ); lista.add( g );
		Ponto h = new Ponto( "H", 1, 1 ); lista.add( h );
		Ponto i = new Ponto( "I", 1, 3 ); lista.add( i );
		Ponto j = new Ponto( "J", 2, 5 ); lista.add( j );
		Ponto k = new Ponto( "K", 3, 0 ); lista.add( k );
		Ponto l = new Ponto( "L", 0, 4 ); lista.add( l );
		
		Calculos cal = new Calculos( lista );
		cal.construirPoligono();
		cal.mostrarInformacoes();
	}

}
