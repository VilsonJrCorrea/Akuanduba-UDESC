// CArtAgO artifact code for project mapc2018udesc

package mapc2018udesc;

import java.util.ArrayList;
import java.util.List;

import cartago.*;

public class CalculoPoligono extends Artifact {
	
	private List<Ponto> listaPontos = new ArrayList<>();

	@OPERATION
	void addPonto( double lat, double lon ) {
		listaPontos.add( new Ponto("", lat, lon) );
	}
	
	class Reta {
		
		private double a;
		private double b;
		private double c;
		
		public Reta(double a, double b, double c) {
			super();
			this.a = a;
			this.b = b;
			this.c = c;
		}

		public double getA() {
			return a;
		}

		public void setA(double a) {
			this.a = a;
		}

		public double getB() {
			return b;
		}

		public void setB(double b) {
			this.b = b;
		}

		public double getC() {
			return c;
		}

		public void setC(double c) {
			this.c = c;
		}
	}
	
	class Ponto {

		private String nome;
		private double x;
		private double y;
		
		public Ponto(String nome, double x, double y) {
			super();
			this.nome = nome;
			this.x = x;
			this.y = y;
		}
		
		public String getNome() {
			return nome;
		}

		public void setNome(String nome) {
			this.nome = nome;
		}

		public double getX() {
			return x;
		}

		public void setX(double x) {
			this.x = x;
		}

		public double getY() {
			return y;
		}

		public void setY(double y) {
			this.y = y;
		}

		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			Ponto other = (Ponto) obj;
			if (nome == null) {
				if (other.nome != null)
					return false;
			} else if (!nome.equals(other.nome))
				return false;
			if (Double.doubleToLongBits(x) != Double.doubleToLongBits(other.x))
				return false;
			if (Double.doubleToLongBits(y) != Double.doubleToLongBits(other.y))
				return false;
			return true;
		}

		@Override
		public String toString() {
			return "Ponto [nome=" + nome + ", x=" + x + ", y=" + y + "]";
		}

	}
}

