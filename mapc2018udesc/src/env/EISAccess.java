
// CArtAgO artifact code for project mapc2018udesc

import java.util.Collection;
import java.util.LinkedList;
import java.util.ArrayList;


import cartago.*;
import eis.AgentListener;
import eis.exceptions.AgentException;
import eis.exceptions.ManagementException;
import eis.exceptions.RelationException;
import eis.iilang.Action;
import eis.iilang.Identifier;
import eis.iilang.Parameter;
import eis.iilang.Percept;
import jason.asSyntax.Literal;
import massim.eismassim.EnvironmentInterface;

public class EISAccess extends Artifact implements AgentListener {
	
    private EnvironmentInterface ei;
    private String Agname="";
    private Boolean receiving=false;
    private int awaitTime = 100;
    private String lastStep = "-1";
    private ArrayList<ObsProperty> lastRoundPropeties = new ArrayList<ObsProperty>();

	void init(String conf) {
		 ei = new EnvironmentInterface(conf);
		 this.Agname=ei.getEntities().getFirst();
	        try {
	            ei.start();
	        } catch (ManagementException e) {
	            e.printStackTrace();
	        }

            try {
                ei.registerAgent(this.Agname);
            } catch (AgentException e1) {
            	e1.printStackTrace();
            }

            ei.attachAgentListener(this.Agname, this);

            try {
                ei.associateEntity(this.Agname, this.Agname);
            } catch (RelationException e1) {
                e1.printStackTrace();
            }
	        if (ei != null) {
		        this.receiving = true;
				execInternalOp("updatepercept");
	        }
	}
	
	
	@INTERNAL_OPERATION void updatepercept() {		
		while (!ei.isEntityConnected(this.Agname)) {
			await_time(this.awaitTime);
		}
		
		while (this.receiving) {
			if (ei != null) {
				
				try {
					Collection<Percept> lp = 
							ei.getAllPercepts(this.Agname).get(this.Agname);	
					boolean newstep=true;
					for (Percept pe:lp) {
						if (pe.getName().equals("step")) {
							if (pe.getParameters().getFirst().toString().equals(this.lastStep)) {
								newstep=false;
								break;
							}
							else 
								this.lastStep=pe.getParameters().getFirst().toString();
						}
					}
					if (newstep) {
						clearpercepts();
						for (Percept pe:lp) {
							if (pe.getName().equals("facility"))
								if (pe.getParameters().size()>1) {
									System.out.println("***********************");
									for (Parameter p:pe.getClonedParameters())
										System.out.println("facility | "+p.toString());
									System.out.println("***********************");
								}else {System.out.print("");}
							else if (pe.getName().equals("id")) {
								this.lastRoundPropeties.add( defineObsProperty(	pe.getName(),
										pe.getClonedParameters().get(0).toString()));
							}
							else if (pe.getName().equals("entity")) {
									LinkedList<Parameter> tmp = pe.getClonedParameters();
									tmp.set(1, new Identifier(tmp.get(1).toString().toLowerCase()));
									this.lastRoundPropeties.add(
										defineObsProperty(pe.getName(),Translator.parametersToTerms(tmp)));
								}
							else if (pe.getName().equals("well")) {
								LinkedList<Parameter> tmp = pe.getClonedParameters();
								tmp.set(4, new Identifier(tmp.get(4).toString().toLowerCase()));
								this.lastRoundPropeties.add(
									defineObsProperty(pe.getName(),Translator.parametersToTerms(tmp)));
							}
							else if (pe.getName().equals("team")) {
								LinkedList<Parameter> tmp = pe.getClonedParameters();
								tmp.set(0, new Identifier(tmp.get(0).toString().toLowerCase()));
								this.lastRoundPropeties.add(
									defineObsProperty(pe.getName(),Translator.parametersToTerms(tmp)));
							}
							else {
								this.lastRoundPropeties.add( defineObsProperty(	pe.getName(),
												Translator.parametersToTerms(pe.getClonedParameters())));
							}
						}
					}
				} catch (Exception e) {		
					e.printStackTrace();
				}
			}
			await_time(this.awaitTime);
		}
		
	}
	private void clearpercepts () {
		for (ObsProperty obs:this.lastRoundPropeties) 
			removeObsProperty(obs.getName());
		this.lastRoundPropeties.clear();
	}
	
	@OPERATION
	void action(String action) {
		Literal literal = Literal.parseLiteral(action);
		Action a = null;
		try {
			if (ei != null) {
				a = Translator.literalToAction(literal);
				ei.performAction(this.Agname, a);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void handlePercept(String arg0, Percept arg1) {}
	
	
}