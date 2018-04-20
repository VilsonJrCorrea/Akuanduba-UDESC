

import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Set;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.logging.Logger;

import cartago.*;
import eis.AgentListener;
import eis.EnvironmentInterfaceStandard;
import eis.EnvironmentListener;
import eis.exceptions.ActException;
import eis.exceptions.AgentException;
import eis.exceptions.ManagementException;
import eis.exceptions.RelationException;
import eis.iilang.Action;
import eis.iilang.EnvironmentState;
import eis.iilang.Identifier;
import eis.iilang.Parameter;
import eis.iilang.Percept;
import jason.NoValueException;
import jason.asSyntax.Literal;
import massim.eismassim.EnvironmentInterface;

public class EISAccess3 extends Artifact implements AgentListener {
	
    private Logger logger = Logger.getLogger("EISAccess." + EISAccess3.class.getName());
    private EnvironmentInterface ei;
    private String Agname="";
    private Boolean receiving=false;
    private int awaitTime = 100;
    private ArrayList<PercObs> lastRoundPropeties = new ArrayList<PercObs>();
    private String[] arrayOfunary = {"requestAction","simStart","actionID","cellSize",
    								 "centerLat","centerLon","charge","deadline","id",
    								 "lastAction","lastActionParams","lastActionResult",
    								 "lat","load","lon","map","massium","maxLat","maxLon",
    								 "minLat","minLon","name","proximity","route","routeLength",
    								 "score","seedCapital","step","steps","team","timestamp","role"};
    private String[] arrayOfbinary = {	"dump","shop","upgrade","workshop","chargingStation",
    									"item","entity","wellType","job","storage","auction"};    
    private Set<String> binarySet = new HashSet<String>(Arrays.asList(arrayOfbinary)); 
    private Set<String> unarySet = new HashSet<String>(Arrays.asList(arrayOfunary));
    
	void init(String conf) {
		 ei = new EnvironmentInterface(conf);
		 this.Agname=ei.getEntities().getFirst();
	        try {
	            ei.start();
	        } catch (ManagementException e) {
	            e.printStackTrace();
	        }

	        ei.attachEnvironmentListener(new EnvironmentListener() {
	                public void handleNewEntity(String entity) {}
	                public void handleStateChange(EnvironmentState s) {
	                    logger.info("new state "+s);
	                }
	                public void handleDeletedEntity(String arg0, Collection<String> arg1) {}
	                public void handleFreeEntity(String arg0, Collection<String> arg1) {}
	        });

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
				this.falselastRoundPropeties();
				if (ei != null) {
					try {
						Collection<Percept> lp = 
								ei.getAllPercepts(this.Agname).values().iterator().next();
						for (Percept pe:lp) {				
							if (!pe.getName().equals("facility")) {
								PercObs obs = checklastRoundPropeties(pe);
								if(obs==null) {
									if (pe.getName().equals("entity")) {
										LinkedList<Parameter> tmp = pe.getClonedParameters();
										tmp.set(1, new Identifier(
													tmp.get(1).toString().toLowerCase()));
										this.lastRoundPropeties.add( new PercObs(
												defineObsProperty(	pe.getName(),Translator.parametersToTerms(tmp)))
												);
									}									
									else {
									this.lastRoundPropeties.add( new PercObs(
											defineObsProperty(	pe.getName(),
																Translator.parametersToTerms(
																		pe.getClonedParameters()))));
									}
		
								}
								else if (!obs.getPercept().toString().equals(pe.toProlog()))  {
									if (pe.getName().equals("entity")) {
										LinkedList<Parameter> tmp = pe.getClonedParameters();
										tmp.set(1, new Identifier(
													tmp.get(1).toString().toLowerCase()));
										obs.getPercept().updateValues(Translator.parametersToTerms(tmp));
										obs.setChanged();
									}
									else { 
										obs.getPercept().updateValues(Translator.parametersToTerms(
																		pe.getClonedParameters()));
										obs.setChanged();
									}
								}
							}
						}
						this.clearfakelastRoundPropeties();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			await_time(this.awaitTime);
		}
		
	}
	
	private void falselastRoundPropeties () {
		for (PercObs obs:this.lastRoundPropeties) 
			obs.setNotChanged();
	}
	
	private void clearfakelastRoundPropeties () {
		for (PercObs obs:this.lastRoundPropeties) 
			if (!obs.getChanged()) {
				removeObsPropertyByTemplate( obs.getPercept().getName(),
											 obs.getPercept().getValues());
			}
	}
	
	private PercObs checklastRoundPropeties (Percept pe) {
		
		for (PercObs obs:this.lastRoundPropeties) {
			if (obs.toString().equals(pe.toProlog()))
				return obs;
			else if (unarySet.contains(pe.getName()) && obs.getPercept().getName().equals(pe.getName())) 
					return obs;
			else if (binarySet.contains(pe.getName()) && obs.getPercept().getName().equals(pe.getName()) &&
					 obs.getPercept().getValue(0).toString().equals(pe.getParameters().getFirst().toString()))  
				return obs;
		}
		return null;
	}
	
	@OPERATION
	void action(String action) throws NoValueException {
		Literal literal = Literal.parseLiteral(action);
		try {
			Action a = Translator.literalToAction(literal);
			ei.performAction(this.Agname, a);
		} catch (ActException e) {
			e.printStackTrace();
		}
	}
	
	public void handlePercept(String arg0, Percept arg1) {}
}

