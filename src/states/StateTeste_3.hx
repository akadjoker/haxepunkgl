package states;

import actors.Bouncy;
import com.haxepunk.actions.AlphaAction;
import com.haxepunk.actions.MoveToAction;
import com.haxepunk.actions.ScaleAction;
import com.haxepunk.actions.SkewAction;
import com.haxepunk.actions.SkewXAction;
import com.haxepunk.actions.SkewYAction;
import com.haxepunk.actions.StartMoveToAction;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.gui.SelfButton;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.gl.Texture;
import com.haxepunk.gl.BlendMode;
import com.haxepunk.graphics.EmitterGraphic;
import com.haxepunk.graphics.ImageFont;
import com.haxepunk.graphics.PexParticles;
import com.haxepunk.state.BasicGameState;
import com.haxepunk.state.transition.EmptyTransition;
import com.haxepunk.state.transition.FromRightStateTransition;
import com.haxepunk.state.transition.FadeInTransition;
import com.haxepunk.state.transition.FadeOutTransition;
import com.haxepunk.state.transition.ExitLeftStateTransition;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
/**
 * ...
 * @author djoekr
 */
class StateTeste_3 extends BasicGameState
{

	var gfnt :ImageFont;

	public static var ID:Int = 3;

	public  override function getID():Int 
	{
		return ID;
	}
	
	public override function begin()
	{
		//setCenter();
		
	 add(new Entity(0, 0, new Backdrop(getTexture("gfx/tile.png"))));
 	
		 
	 var caption:String = " - click circle to add";
	 gfnt = new ImageFont( caption, getTexture("gfx/xfilesfnt.png"));
	 
	 var fnt = new Entity(HXP.width / 2 - (caption.length * 8), 10, gfnt, 0);
	 fnt.layer = -100;
	 add(fnt);		
	
	 
	
	    var a_a:SelfButton = new SelfButton( 2, HXP.height - 50,  new Image(getTexture("gfx/b1.png")), new Image(getTexture("gfx/b2.png")));
		a_a.onClick = function click(b:SelfButton)
		{
			//HXP.engine.enterStateTransition(StateTeste_1.ID,   new FadeOutTransition(0,500), new FadeInTransition(0, 500));
			HXP.engine.enterStateTransition(StateTeste_2.ID,   new ExitLeftStateTransition(1,Ease.bounceIn), new FromRightStateTransition(1,StateTeste_2.ID,Ease.bounceOut));
		}
		add(a_a);
		
	    var a_b:SelfButton = new SelfButton(HXP.width - 80, HXP.height - 50,  new Image(getTexture("gfx/f1.png")), new Image(getTexture("gfx/f2.png")));
		a_b.onClick = function click(b:SelfButton)
		{
	    	HXP.engine.enterStateTransition(StateTeste_4.ID,   new ExitLeftStateTransition(1,Ease.bounceIn), new FromRightStateTransition(1,StateTeste_4.ID,Ease.bounceOut));
			//HXP.engine.enterStateTransition(StateTeste_4.ID,   new FadeOutTransition(0,500), new FadeInTransition(0, 500));
		}
		add(a_b);
		
		
		 var a_c:SelfButton = new SelfButton((HXP.width/2) - (50/2), HXP.height-50,  new Image(getTexture("gfx/r1.png")), new Image(getTexture("gfx/r2.png")));
		a_c.onClick = function click(b:SelfButton)
		{
		for (i in 0...50)
		{
			add(new Bouncy( new Image(getTexture("gfx/grossini.png")), "grossini"));
		}
		}
		add(a_c);
		
		for (i in 0...50)
		{
			add(new Bouncy( new Image(getTexture("gfx/grossini.png")), "grossini"));
		}

    }

	override public function update() 
	{
		super.update();
		gfnt.caption = "Total - " +		HXP.scene.count;
		
		
	}
}