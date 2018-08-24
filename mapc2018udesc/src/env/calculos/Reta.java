package calculos;

public class Reta {
	
	private Ponto origem;
	private Ponto destino;
	
	public Reta(Ponto origem, Ponto destino) {
		super();
		this.origem = origem;
		this.destino = destino;
	}

	public void setOrigem(Ponto origem) {
		this.origem = origem;
	}

	public void setDestino(Ponto destino) {
		this.destino = destino;
	}

	public Ponto getOrigem() {
		return origem;
	}

	public Ponto getDestino() {
		return destino;
	}

	@Override
	public String toString() {
		return "Reta [origem=" + origem + ", destino=" + destino + "]";
	}
	
}
