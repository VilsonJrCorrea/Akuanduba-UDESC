package calculos;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Calculos {

	private Ponto maisAcima;
	private Ponto maisAbaixo;
	private Ponto maisEsquerda;
	private Ponto maisDireita;
	private Ponto pontoMedio;
	private List<Reta> retasPoligono = new ArrayList<>();
	private List<Ponto> pontosNaoCalculados = new ArrayList<>();

	public Calculos(List<Ponto> listaPontos) {
		super();
		this.pontosNaoCalculados = listaPontos;
	}
	
	public List<Reta> construirPoligono() {
		acharExtremos();
		calcularPontoMedio();
		ordenarPontos();
		
		int contadorInteracoes;
		double deterPontoMedio, deter;
		Ponto maisDistante;
		
		while( !pontosNaoCalculados.isEmpty() ) {
			maisDistante = pontosNaoCalculados.get( 0 );
			contadorInteracoes = 0;
			for( Reta r : retasPoligono) {
				deterPontoMedio = testarAlinhamento( pontoMedio, r);
				deter = testarAlinhamento( maisDistante, r);
				if( Math.signum( deter ) != Math.signum( deterPontoMedio ) ) {
					criarNovasRetas( maisDistante, r );
					pontosNaoCalculados.remove( maisDistante );
					break;
				}
				contadorInteracoes++;
				if( contadorInteracoes == retasPoligono.size() ) {
					pontosNaoCalculados.remove( maisDistante );
				}
			}
		}
		
		return retasPoligono;
	}
	
	public String toString() {
		String s = "polygon([";
		for( Reta r : retasPoligono ) 
			s += "rule(" + r.getOrigem().getX()  + ","
						 + r.getOrigem().getY()  + "," 
						 + r.getDestino().getX() + ","
						 + r.getDestino().getY() + "),";
		s = s.substring(0, s.length()-1);
		return s + "])";
	}
	
	public void mostrarInformacoes() {
		System.out.println( "Cima: " + maisAcima );
		System.out.println( "Baixo: " + maisAbaixo );
		System.out.println( "Esquerda: " + maisEsquerda );
		System.out.println( "Direita: " + maisDireita );
		System.out.println( "Ponto Medio: " + pontoMedio );
		System.out.println( "Poligono: " + retasPoligono );
	}
	
	private void acharExtremos() {
		{
			Ponto p = pontosNaoCalculados.get( 0 );
			maisAbaixo = p;
			maisAcima = p;
			maisEsquerda = p;
			maisDireita = p;
		}
		for( Ponto p : pontosNaoCalculados ) {
			if( maisAcima.getY() > p.getY() ) {
				maisAcima = p;
			}
		}
		pontosNaoCalculados.remove( maisAcima );
		
		for( Ponto p : pontosNaoCalculados ) {
			if( maisAbaixo.getY() < p.getY() ) {
				maisAbaixo = p;
			}
		}
		pontosNaoCalculados.remove( maisAbaixo );
		
		for( Ponto p : pontosNaoCalculados ) {
			if( maisEsquerda.getX() < p.getX() ) {
				maisEsquerda = p;
			}
		}
		pontosNaoCalculados.remove( maisEsquerda );
		
		for( Ponto p : pontosNaoCalculados ) {
			if( maisDireita.getX() > p.getX() ) {
				maisDireita = p;
			}
		}
		pontosNaoCalculados.remove( maisDireita );
		
		retasPoligono.add( new Reta( maisAbaixo, maisDireita ) );
		retasPoligono.add( new Reta( maisDireita, maisAcima ) );
		retasPoligono.add( new Reta( maisAcima, maisEsquerda ) );
		retasPoligono.add( new Reta( maisEsquerda, maisAbaixo ) );
	}

	private void calcularPontoMedio() {
		double xMedio 
			= ( maisAbaixo.getX() + maisAcima.getX() + maisDireita.getX() + maisEsquerda.getX() ) / 4;
		double yMedio 
			= ( maisAbaixo.getY() + maisAcima.getY() + maisDireita.getY() + maisEsquerda.getY() ) / 4;
		pontoMedio = new Ponto("Medio", xMedio, yMedio);
	}
	
	private double calcularDistancia( Ponto p1, Ponto p2 ) {
		return Math.sqrt( Math.pow( p1.getX() - p2.getX(), 2) + Math.pow( p1.getY() - p2.getY(), 2) );
	}
	
	private double testarAlinhamento( Ponto p, Reta r ) {
		double xA = p.getX();
		double yA = p.getY();
		double xB = r.getOrigem().getX();
		double yB = r.getOrigem().getY();
		double xC = r.getDestino().getX();
		double yC = r.getDestino().getY();
		return ( xA*(yB - yC) + xB*(yC - yA) + xC*(yA - yB) );
	}
	
	private void criarNovasRetas( Ponto p, Reta r) {
		Ponto aux = r.getDestino();
		r.setDestino( p );
		
		Reta novaReta = new Reta(p, aux);
		retasPoligono.add( novaReta );
	}
	
	private void ordenarPontos() {
		List<PontoComDistancia> lista = new ArrayList<>();
		PontoComDistancia pd;
		for( Ponto p : pontosNaoCalculados ) {
			pd = new PontoComDistancia( p, calcularDistancia( p, pontoMedio ) );
			if( lista.isEmpty() || lista.get( lista.size() - 1 ).getDistancia() > pd.getDistancia()) {
				lista.add( pd );
			}else {
				for( int i = 0; i < lista.size(); i++ ) {
					if( lista.get( i ).getDistancia() < pd.getDistancia() ) {
						lista.add( i, pd );
						break;
					}
				}
			}
			System.out.println("Pontos:");
			for( PontoComDistancia p1 : lista ) {
				System.out.println( p1.toString() );
			}
			System.out.println("");
		}
		
		pontosNaoCalculados = new ArrayList<>();
		for( PontoComDistancia p : lista ) {
			pontosNaoCalculados.add( p.getPonto() );
		}
		System.out.println( "\n\n\n" + pontosNaoCalculados );
	}
	
	private class PontoComDistancia {
		private Ponto ponto;
		private double distancia;
		
		private PontoComDistancia( Ponto ponto, double distancia ) {
			this.ponto = ponto;
			this.distancia = distancia;
		}
		
		public Ponto getPonto() {
			return ponto;
		}
		
		public double getDistancia() {
			return distancia;
		}
		
		public String toString() {
			return "Ponto: " + ponto + ", Distancia: " + distancia;
		}
	}
	
}
