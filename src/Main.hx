import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.state.transition.CrossStateTransition;
import com.haxepunk.state.transition.FadeInTransition;
import com.haxepunk.state.transition.FadeOutTransition;

import states.StateTeste_1;
import states.StateTeste_2;
import states.StateTeste_3;
import states.StateTeste_4;
import states.StateTeste_5;
import states.StateTeste_6;

import flash.display.Sprite;
import flash.events.Event;

import com.haxepunk.gl.Game;

import com.haxepunk.utils.FPS;
class Main extends Engine
{
	private var doneFrame:Bool;
	
	public function  new()
	{
		
		super(480, 320, 1000, false);
	
		addEventListener(Event.ENTER_FRAME, start);
	}

	
private function start(e:Event)
{
if (!doneFrame)
{
doneFrame = true;
return;
}
removeEventListener(Event.ENTER_FRAME, start);
addChild(new FPS(10, 10, 0xffFFFFFF));
}


	public override function initStatesList( ) 
		{
			  //addState(new StateMenu());
		     // addState(new StateGame());
				//	 addState(new StateOver());
					 addState(new StateTeste_1());
					 addState(new StateTeste_2());
					 addState(new StateTeste_3());
					 addState(new StateTeste_4());
					 addState(new StateTeste_5());
					 addState(new StateTeste_6());
			


		 trace("setstates");
        // addState(new TestState2());
        // addState(new TestState3());
       }
	   

	override public function init()
	{
	  
	   super.init();
	   //enterState(StateTeste_6.ID);
	}

	public static function main() { new Main(); }

}