package states;

import com.haxepunk.state.BasicGameState;

/**
 * ...
 * @author djoekr
 */
class StateOver extends BasicGameState
{

	public static var ID:Int = 3;
	
	public function new() 
	{
		super();
		
	}
	public  override function getID():Int 
	{
		return ID;
	}
	

}