package mapc2018udesc;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class CreateJCM {
	//nome do jcm
	//qtd agentes
	public static void main(String[] args) throws IOException {
		String output = args[0];
		String header = "mas mapc2018udesc {\n";		
		String footer =	" asl-path: src/agt\n" + 
						"src/agt/inc\n }";
		String detail="";
		for (int i=0;i<Integer.parseInt(args[1]);i++) {
			detail+=  "agent connectionA"+(i+1)+": connectionA.asl"+
				"{ \ngoals: connect(\""+args[2]+i+".json\")\n}\n";
		
		}
		Files.write(Paths.get(output+".jcm"), (header+detail+footer).getBytes());
	}
}
