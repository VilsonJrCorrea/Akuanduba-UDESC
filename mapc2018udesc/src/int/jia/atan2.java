package jia;
import jason.JasonException;
import jason.asSemantics.DefaultArithFunction;
import jason.asSemantics.TransitionSystem;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.Term;

/**
  <p>Function: <b><code>math.tan(N)</code></b>: encapsulates java Math.tan(N),
  returns the trigonometric tangent of an angle.
  @author Jomi
*/
public class atan2 extends DefaultArithFunction  {

    public String getName() {
        return "math.atan2";
    }

    @Override
    public double evaluate(TransitionSystem ts, Term[] args) throws Exception {
        if (args[0].isNumeric() && args[1].isNumeric()) {
            return Math.atan2(((NumberTerm)args[0]).solve(),((NumberTerm)args[1]).solve());
        } else {
            throw new JasonException("The argument '"+args[0]+" or "+args[1]+"' is not numeric!");
        }
    }

    @Override
    public boolean checkArity(int a) {
        return a == 2;
    }

}