package calculos;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.parser.ParseException;

public class ARTGreyZone extends Artifact {
	private List<Ponto> points = new ArrayList<Ponto>();
	Calculos cal;
	
	void init() {
	}

	@OPERATION
	void addPoint( double x, double y) {
		points.add( new Ponto("", x, y) );
	}
	
	@OPERATION
	void buildPolygon() {
		cal = new Calculos( points );
		cal.construirPoligono();
	}
	
	@OPERATION
	void dismantlePolygon() {
		points.clear();
		cal = null;
	}
	
	@OPERATION
	void getPolygon( OpFeedbackParam<Literal> retorno ) {
		try {
			retorno.set(ASSyntax.parseLiteral( cal.toBelief() ) );
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	@OPERATION 
	void getPoint( int x, int y, OpFeedbackParam<Literal> retorno) {
		Ponto p = cal.calcularPonto(x, y);
		try {
			retorno.set( ASSyntax.parseLiteral( "point(" + p.getX() + "," + p.getY() + ")" ) );
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
}

