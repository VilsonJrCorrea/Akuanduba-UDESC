package mapc2018udesc;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class CreateJCMArt {
	//nome do jcm
	//qtd agentes
	public static void main(String[] args) {
		String output = args[0];
		String header = "mas mapc2018udesc {\n";		
		String footer =	" asl-path: src/agt\n" + 
						"src/agt/inc\n }";
		String detail="";
		for (int i=0;i<Integer.parseInt(args[1]);i++) {
			detail+=  "agent connectionA"+(i+1)+": connectionA.asl"+
				"{ \n join: env\n"+
				"focus: env.art"+(i+1)+ "\n}\n";
		}
		detail+= "workspace env {\n";
		for (int i=0;i<Integer.parseInt(args[1]);i++) {
			detail+=  
				"artifact art"+(i+1)+": EISAccess(\""+args[2]+i+".json\")\n";
		}
		detail+="}\n";
			
		
		try {
			Files.write(Paths.get(output+".jcm"), (header+detail+footer).getBytes());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
