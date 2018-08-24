// Internal action code for project Prova2018.1
package jia;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class upper extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        return un.unifies(args[1],
        		ASSyntax.createString(
        					args[0].clone()
        					.toString().toUpperCase()));        
    }
}
