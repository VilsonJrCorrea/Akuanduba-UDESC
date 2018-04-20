
import cartago.ObsProperty;

public class PercObs {
	private ObsProperty	percept;
	private Boolean changed;
	
	public PercObs (ObsProperty obsp) {
		this.percept=obsp;
		this.setChanged();
	}
	
	public ObsProperty getPercept() {
		return percept;
	}
	
	public void setPercept(ObsProperty percept) {
		this.percept = percept;
		this.setChanged();
	}

	public Boolean getChanged() {
		return changed;
	}

	public void setChanged() {
		this.changed = true;
	}
	
	public void setNotChanged() {
		this.changed = false;
	}
	
}
