import java.util.HashMap;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.parser.ParseException;

public class CooGather extends Artifact {
	
	
	private HashMap<String, ObsProperty> tarefas = new HashMap<>();
	
	@OPERATION
	void addGatherCommitment(String agent, String item) {
		if( !tarefas.containsKey(item) ) {
			try {
				tarefas.put(item, defineObsProperty("gatherCommitment", ASSyntax.parseLiteral(item)) );
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else {
			failed("item conflicted","item_conflicted","item_conflicted");
		}
		
	}
	
	@OPERATION
	void addCraftCommitment(String agent, String item) {
		if( !tarefas.containsKey(item) ) {
			try {
				tarefas.put(item, defineObsProperty("craftCommitment", ASSyntax.parseLiteral(item)) );
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else {
			failed("item conflicted","item_conflicted","item_conflicted");
		}
		
	}
	
	@OPERATION
	void dismiss(String agent) {
		
	}
	
	private class Agente{
		private String nome;
		private String role;
		private String item;
		private String doing;
		
		
	}
}

