import jaca.ToProlog;

public class Converter implements ToProlog{
	String s;
	public Converter(String s) {
		this.s=s.toString();
	}
	
	
	public String getAsPrologStr() {
		// TODO Auto-generated method stub
		return s;
	}
	
	public String toString() {
		// TODO Auto-generated method stub
		return s;
	}

}