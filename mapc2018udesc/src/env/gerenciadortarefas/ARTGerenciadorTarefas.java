// CArtAgO artifact code for project mapc2018udesc

package gerenciadortarefas;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import eis.eis2java.annotation.AsPercept;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.parser.ParseException;

public class ARTGerenciadorTarefas extends Artifact {
	
	private List<Agente> listaAgentes = new ArrayList<>();

	void init() {
	}

	@OPERATION
	void cadastrarAgente( String nome, String role, int capacidade) {
		listaAgentes.add( new Agente(nome, role, capacidade) );
	}
	
	@OPERATION
	void buscarAgenteParaResourceNode(String role, OpFeedbackParam<Literal> retorno ) {
		for( Agente a : listaAgentes) {
			if( a.getRole().equals("truck") && !a.isOcupado() ) {
				try {
					retorno.set(ASSyntax.parseLiteral( a.getNome() ));
				} catch (ParseException e) {
					e.printStackTrace();
				}
				a.setOcupado(true);
				break;
			}
		}
	}
	
	@OPERATION
	void estaLivre(String nome) {
		for( Agente a : listaAgentes) {
			if( a.getNome().equals(nome) ) {
				a.setOcupado(false);
			}
		}
	}
	
	@OPERATION
	void getCapacidade(String role, OpFeedbackParam<Literal> retorno ){
		for( Agente a: listaAgentes ) {
			if( a.getRole().equals(role) ) {
				try {
					retorno.set(ASSyntax.parseLiteral( String.valueOf( a.getCapacidade() ) ));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	private class Agente{
		
		private String nome;
		private String role;
		private int capacidade;
		private boolean ocupado = false;
		
		public Agente(String nome, String role, int capacidade) {
			super();
			this.nome = nome;
			this.role = role;
			this.capacidade = capacidade;
		}
		
		public String getNome() {
			return nome;
		}
		public void setNome(String nome) {
			this.nome = nome;
		}
		public String getRole() {
			return role;
		}
		public void setRole(String role) {
			this.role = role;
		}
		public int getCapacidade() {
			return capacidade;
		}
		public void setCapacidade(int capacidade) {
			this.capacidade = capacidade;
		}
		public boolean isOcupado() {
			return ocupado;
		}
		public void setOcupado(boolean ocupado) {
			this.ocupado = ocupado;
		}

		@Override
		public String toString() {
			return "Agente [nome=" + nome + ", role=" + role + ", capacidade=" + capacidade + ", ocupado=" + ocupado
					+ "]";
		}
		
		
	}
}

