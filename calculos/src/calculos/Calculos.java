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
		calcularPontoMedio();
		
		int contadorInteracoes;
		double deterPontoMedio, deter;
		Ponto maisDistante;
		
		while( !pontosNaoCalculados.isEmpty() ) {
			maisDistante = acharPontoMaisDistante();
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
		
		List< Reta > retasParaRetirar = new ArrayList<>();
		for( Reta r : retasPoligono ) {
			if( r.getOrigem().equals( r.getDestino() ) ) {
				retasParaRetirar.add( r );
			}
		}
		for( Reta r : retasParaRetirar ) {
			retasPoligono.remove( r );
		}
		return retasPoligono;
	}
	
	public void mostrarInformacoes() {
		System.out.println( "Cima: " + maisAcima );
		System.out.println( "Baixo: " + maisAbaixo );
		System.out.println( "Esquerda: " + maisEsquerda );
		System.out.println( "Direita: " + maisDireita );
		System.out.println( "Ponto Médio: " + pontoMedio );
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
			if( maisAbaixo.getY() < p.getY() ) {
				maisAbaixo = p;
			}
			if( maisEsquerda.getX() < p.getX() ) {
				maisEsquerda = p;
			}
			if( maisDireita.getX() > p.getX() ) {
				maisDireita = p;
			}
		}
		
		pontosNaoCalculados.remove( maisAbaixo );
		pontosNaoCalculados.remove( maisAcima );
		pontosNaoCalculados.remove( maisDireita );
		pontosNaoCalculados.remove( maisEsquerda );
		
		retasPoligono.add( new Reta( maisAbaixo, maisDireita ) );
		retasPoligono.add( new Reta( maisAbaixo, maisEsquerda ) );
		retasPoligono.add( new Reta( maisAcima, maisDireita ) );
		retasPoligono.add( new Reta( maisAcima, maisEsquerda ) );
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
	
	private Ponto acharPontoMaisDistante() {
		double aux;
		Ponto pontoMaisDistante = pontosNaoCalculados.get( 0 );
		double distanciaAtual = calcularDistancia( pontoMaisDistante, pontoMedio );
		for( Ponto p : pontosNaoCalculados ) {
			aux = calcularDistancia( p, pontoMedio );
			if(  aux > distanciaAtual ) {
				distanciaAtual = aux;
				pontoMaisDistante = p;
			}
		}
		return pontoMaisDistante;
	}
	
}
