package mapc2018udesc;

import jacamo.infra.JaCaMoLauncher;
import jason.JasonException;

public class RunRemoto {

	public static void main(String[] args) {
		try {
			JaCaMoLauncher.main(new String[] {args[0]});
		} catch (JasonException e) {
			System.out.println("Exception: "+e.getMessage());
			e.printStackTrace();
		}
	}	
	
}
