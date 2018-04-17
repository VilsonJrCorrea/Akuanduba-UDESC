package mapc2018udesc;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class CreateEismassimconf {
	public static void main(String[] args) throws IOException {
		
		String output = args[0];
		
		String header = "{\n"+
		"\"scenario\":\""+ args[1]+"\",\n"+
		"\"host\":\""+ args[2]+"\",\n"+
		"\"port\":"+ args[3]+",\n"+
		"\"scheduling\":"+ args[4]+",\n"+
		"\"timeout\":"+ args[5]+",\n"+
		"\"times\":"+ args[6]+",\n"+
		"\"notifications\":"+ args[7]+",\n"+
		"\"queued\":"+ args[8]+",\n"+
		"\"entities\": [\n";
		
		String footer ="  ]\n}";
		
		for (int i=0;i<Integer.parseInt(args[9]);i++) {
			String detail=  "{\"name\":\"" +args[10]+(i+1)+
							"\", \"username\": \""+args[11]+(i+1)+
							"\", \"password\": \""+args[12]+
							"\", \"iilang\":"+args[13]+
							", \"xml\":"+args[14]+"}\n";
			Files.write(Paths.get(output+i+".json"), (header+detail+footer).getBytes());
		}
		  
	}
}
