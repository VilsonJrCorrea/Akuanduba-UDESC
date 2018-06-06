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
		System.out.println("INTERNO: construindo o poligono !" );
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
	void getPoint( double lat, double lon, OpFeedbackParam<Literal> retorno ) {
		Ponto p = cal.calcularPonto(lat, lon);
		System.out.println( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + p.toString() );
		try {
			retorno.set( ASSyntax.parseLiteral( "point(" + p.getX() + "," + p.getY() + ")" ));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		System.out.println("INTERNO: getpoint" );
	}


}

