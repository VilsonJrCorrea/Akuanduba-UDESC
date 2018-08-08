import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.jboss.netty.util.internal.SystemPropertyUtil;
import org.ojalgo.optimisation.Expression;
import org.ojalgo.optimisation.ExpressionsBasedModel;
import org.ojalgo.optimisation.Optimisation;
import org.ojalgo.optimisation.Variable;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.parser.ParseException;

public class CoordinationArtifact extends Artifact {

	private HashMap<String, ObsProperty> tarefas = new HashMap<>();
	private ArrayList<CraftTask> craftTask = new ArrayList<CraftTask>();
	private HashMap<AgentId, double[]> positions = new HashMap<>();
	private HashMap<String, ObsProperty> job = new HashMap<>();
	int round = -1;

	@OPERATION
	void resetBlackboard(int round) {
		if (this.round < round) {
			this.round = round;
			System.out.println("---> reseting blackboards "+this.round);
			for (Map.Entry<String, ObsProperty> entry : this.tarefas.entrySet()) {
				removeObsProperty(entry.getValue().getName());
			}
			this.tarefas = new HashMap<>();
			for (CraftTask ct : this.craftTask) {
				removeObsProperty(ct.getOP().getName());
			}
			this.craftTask = new ArrayList<CraftTask>();
			this.positions = new HashMap<>();
			for (Map.Entry<String, ObsProperty> entry : this.job.entrySet()) {
				removeObsProperty(entry.getValue().getName());
			}
			this.job = new HashMap<>();
			round++;
		}
	}

	// -----------------
	private int sumcraft(String item) {
		int sum = 0;
		for (CraftTask ct : this.craftTask)
			sum += ct.getItem().equals(item) ? 1 : 0;
		return sum;
	}

	// -----------------
	@OPERATION
	void addIntentionToDoJob(String agent, String job) {
		if (!this.job.containsKey(job)) {
			try {
				signal(this.getCurrentOpAgentId(), "dojob", ASSyntax.parseLiteral(job));
				this.job.put(job, defineObsProperty("jobCommitment",  
													ASSyntax.parseLiteral(agent),
													ASSyntax.parseLiteral(job)));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
	}

	@OPERATION
	void removeIntentionToDoJob(String agent, String job) {
		if (this.job.containsKey(job)) {
			System.out.println("Vai remover");
			try {
				removeObsPropertyByTemplate("jobCommitment",
						ASSyntax.parseLiteral(agent),
						ASSyntax.parseLiteral(job));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			this.job.remove(job);
			System.out.println("Removeu");
		}
	}
	
	@OPERATION
	void addGatherCommitment(String agent, String item) {
		if (!tarefas.containsKey(item)) {
			try {
				// tarefas.put (item, defineObsProperty("gatherCommitment",
				// ASSyntax.parseLiteral(item)) );
				tarefas.put(item, defineObsProperty("gatherCommitment", ASSyntax.parseLiteral(agent),
						ASSyntax.parseLiteral(item)));
				// System.out.println(" ------------> "+agent+" - "+item);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			failed("item conflicted", "item_conflicted", "item_conflicted");
		}

	}

	@OPERATION
	void addCraftCommitment(String agent, String item, int qtd) {
		if (sumcraft(item) < qtd) {
			try {
				// tarefas.put (item, defineObsProperty("craftCommitment",
				// ASSyntax.parseLiteral(item)) );
				this.craftTask.add(new CraftTask(item, defineObsProperty("craftCommitment",
						ASSyntax.parseLiteral(agent), ASSyntax.parseLiteral(item))));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			failed("item conflicted", "item_conflicted", "item_conflicted");
		}

	}

	@OPERATION
	void informDronePositionAndConers(double LAT, double LON, double MINLAT, double MINLON, double MAXLAT,
			double MAXLON, double VR) {
		if (!this.positions.containsKey(this.getCurrentOpAgentId())) {
			// guarda drones na lista
			this.positions.put(this.getCurrentOpAgentId(), new double[] { LAT, LON });
			if (this.positions.size() == 4) {
				// Quando todos informaram calcula o centro e os pontos iniciais das rotas
				double[] CENTER = { (MAXLAT + MINLAT) / 2, (MAXLON + MINLON) / 2 };

				double[][] corners = { { MAXLAT - (VR / 221140), MINLON + (VR / 222640), CENTER[0] + (VR / 221140) },
						{ MAXLAT - (VR / 221140), CENTER[1], CENTER[0] + (VR / 221140) },
						{ CENTER[0], MINLON + (VR / 222640), MINLAT + (VR / 221140) },
						{ CENTER[0], CENTER[1], MINLAT + (VR / 221140) } };

				DronePos[] VARINP = new DronePos[16];
				int idx = 0;
				// cria modelo do oj!algol
				final ExpressionsBasedModel tmpModel = new ExpressionsBasedModel();
				// produto cartesiano drone X ponto inicial = variaveis independentes
				for (Map.Entry<AgentId, double[]> entry : this.positions.entrySet()) {
					AgentId key = entry.getKey();
					double[] POSITION = entry.getValue();
					int cidx = 0;
					for (double[] CORNER : corners) {
						// cria variavel da funcao objetivo
						VARINP[idx] = new DronePos(key, cidx, CORNER, POSITION);
						tmpModel.addVariable(VARINP[idx].getVar());
						idx++;
						cidx = idx % 4;
					}
				}
				// cria restricoes um agente so pode ter um canto e um canto so pode ter 1
				// agente
				for (int a = 0; a < 4; a++) {
					Expression tmpConstraint1 = tmpModel.addExpression("ConstraintAgent" + a);
					Expression tmpConstraint2 = tmpModel.addExpression("ConstraintCorner" + a);
					tmpConstraint1.lower(1);
					tmpConstraint1.upper(1);
					tmpConstraint2.lower(1);
					tmpConstraint2.upper(1);

					for (int i = 0; i < 16; i++) {
						if (i / 4 == a) {
							tmpConstraint1.set(i, 1);
						} else {
							tmpConstraint1.set(i, 0);
						}
						if (i % 4 == a) {
							tmpConstraint2.set(i, 1);
						} else {
							tmpConstraint2.set(i, 0);
						}
					}
				}
				// resolve o problema (minimizacao da funcao objetivo)
				Optimisation.Result tmpResult = tmpModel.minimise();
				// informa para os agentes os respectivos pontos iniciais
				for (int i = 0; i < 16; i++) {
					if (tmpResult.get(i).intValue() == 1) {
						signal(VARINP[i].getAgent(), "corner", VARINP[i].getCorner()[0], VARINP[i].getCorner()[1],
								VARINP[i].getCorner()[2]);

					}
				}
			}
		} else {
			failed("agent already inform", "agent_already_inform", "agent_already_inform");
		}

	}

	protected class DronePos {
		private AgentId AGENT;
		private int cornerkey;
		private double[] CORNER;
		private double[] POSITION;
		private Variable VAR;

		public DronePos(AgentId agent, int cornerkey, double[] CORNER, double[] POSITION) {
			this.cornerkey = cornerkey;
			this.AGENT = agent;
			this.CORNER = CORNER;
			this.POSITION = POSITION;
			this.VAR = Variable.make(agent + " - " + cornerkey).weight(getDistance());
			this.VAR.binary();
		}

		public double getDistance() {
			return Math.sqrt(Math.pow((this.CORNER[0] - this.POSITION[0]), 2)
					+ Math.pow((this.CORNER[1] - this.POSITION[1]), 2));
		}

		public AgentId getAgent() {
			return this.AGENT;
		}

		public int getCornerKey() {
			return this.cornerkey;
		}

		public double[] getCorner() {
			return this.CORNER;
		}

		public double[] getPosition() {
			return this.POSITION;
		}

		public Variable getVar() {
			return this.VAR;
		}

		public String toString() {
			return (this.AGENT + "\t" + this.CORNER[0] + "\t" + this.CORNER[1] + "\t" + this.POSITION[0] + "\t"
					+ this.POSITION[1] + "\t" + getDistance());
		}
	}

	protected class CraftTask {
		private String item;
		private ObsProperty OP;

		public CraftTask(String item, ObsProperty oP) {
			this.item = item;
			OP = oP;
		}

		public String getItem() {
			return item;
		}

		public void setItem(String item) {
			this.item = item;
		}

		public ObsProperty getOP() {
			return OP;
		}

		public void setOP(ObsProperty oP) {
			OP = oP;
		}

	}
}
