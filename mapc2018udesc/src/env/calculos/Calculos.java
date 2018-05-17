package calculos;

import java.util.ArrayList;
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
		calcularPontoMedioPoligono();
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
	
	public String toBelief() {
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
		maisAcima = maisDireita = new Ponto( "", Double.MIN_VALUE, Double.MIN_VALUE);
		maisAbaixo = maisEsquerda = new Ponto( "", Double.MAX_VALUE, Double.MAX_VALUE);
		
		for( Ponto p : pontosNaoCalculados ) {
			if( maisAcima.getY() < p.getY() ) {
				maisAcima = p;
			}
			if( maisAbaixo.getY() > p.getY() ) {
				maisAbaixo = p;
			}
			if( maisEsquerda.getX() > p.getX() ) {
				maisEsquerda = p;
			}
			if( maisDireita.getX() < p.getX() ) {
				maisDireita = p;
			}
		}
		pontosNaoCalculados.remove( maisAcima );
		pontosNaoCalculados.remove( maisAbaixo );
		pontosNaoCalculados.remove( maisEsquerda );
		pontosNaoCalculados.remove( maisDireita );
		
		retasPoligono.add( new Reta( maisAbaixo, maisDireita ) );
		retasPoligono.add( new Reta( maisDireita, maisAcima ) );
		retasPoligono.add( new Reta( maisAcima, maisEsquerda ) );
		retasPoligono.add( new Reta( maisEsquerda, maisAbaixo ) );
		
		List<Reta> removerRetas = new ArrayList<>();
		for( Reta r : retasPoligono ) {
			if( r.getOrigem().equals( r.getDestino() ) ) {
				removerRetas.add( r );
			}
		}
		retasPoligono.removeAll( removerRetas );
	}

	private void calcularPontoMedioPoligono() {
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
		}
		
		pontosNaoCalculados = new ArrayList<>();
		for( PontoComDistancia p : lista ) {
			pontosNaoCalculados.add( p.getPonto() );
		}
	}
	
	private Ponto calcularPontoMedio( Reta r ) {
		return new Ponto( "", 
				( r.getOrigem().getX() + r.getDestino().getX() ) / 2,
				( r.getOrigem().getY() + r.getDestino().getY() ) / 2 );
	}
	
	private Ponto calcularPontoMedio( Ponto p1, Ponto p2 ) {
		return new Ponto( "", 
				( p1.getX() + p2.getX() ) / 2,
				( p1.getY() + p2.getY() ) / 2 );
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

	public synchronized Ponto calcularPonto(double x, double y) {
		Ponto vertice = new Ponto( "", x, y );
		Reta retaMaisProxima = null;
		double distanciaMaisProximo = Double.MAX_VALUE;
		Ponto pontoMedioReta = null;
		double d;
		for( Reta r : retasPoligono ) {
			pontoMedioReta = calcularPontoMedio( r );
			d = calcularDistancia( vertice, pontoMedioReta );
			if( distanciaMaisProximo > d ) {
				retaMaisProxima = r;
				distanciaMaisProximo = d;
			}
		}
		pontoMedioReta = calcularPontoMedio( retaMaisProxima );
		return calcularPontoMedio( vertice, pontoMedioReta );
	}
	
	
}
