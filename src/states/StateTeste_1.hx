package states;

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
import com.haxepunk.state.transition.FadeInTransition;
import com.haxepunk.state.transition.FadeOutTransition;
import com.haxepunk.state.transition.FromRightStateTransition;
import com.haxepunk.state.transition.ExitLeftStateTransition;
import com.haxepunk.state.transition.SkewXStateTransition;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
/**
 * ...
 * @author djoekr
 */
class StateTeste_1 extends BasicGameState
{

		var image:Texture;

	public static var ID:Int = 1;

	public  override function getID():Int 
	{
		return ID;
	}
	
	public override function begin()
	{
		//setCenter();
		 add(new Entity(0, 0, new Backdrop(getTexture("gfx/tile.png"))));
 	
	// add(new Entity(0, 0, new Backdrop(getTexture("gfx/blocks.png"))));
 		 
	 var caption:String = "Blends Mode";
	 add(new Entity(HXP.width/2-(caption.length*8), 10,new ImageFont( caption, getTexture("gfx/xfilesfnt.png"), 0)));		
	 image = getTexture("gfx/grossini.png");	
	 
	
	    var a_a:SelfButton = new SelfButton( 2, HXP.height - 50,  new Image(getTexture("gfx/b1.png")), new Image(getTexture("gfx/b2.png")));
		a_a.onClick = function click(b:SelfButton)
		{
			HXP.engine.enterStateTransition(StateTeste_6.ID,   new ExitLeftStateTransition(1, Ease.bounceIn), new FromRightStateTransition(1, StateTeste_6.ID, Ease.bounceOut));
	
		}
		add(a_a);
		
	    var a_b:SelfButton = new SelfButton(HXP.width - 80, HXP.height - 50,  new Image(getTexture("gfx/f1.png")), new Image(getTexture("gfx/f2.png")));
		a_b.onClick = function click(b:SelfButton)
		{
			
			HXP.engine.enterStateTransition(StateTeste_2.ID,   new SkewXStateTransition(0, 2, 1, getID(),false,Ease.expoIn),  new SkewXStateTransition(2, 0, 1, StateTeste_2.ID,false,Ease.expoIn));
		}
		
		add(a_b);
		
	
	 add(new Entity(100, 100, new Image(image), "grossini", BlendMode.NORMAL));
	 add(new Entity(130, 120, new Image(image), "grossini", BlendMode.TRANSPARENT));
	 add(new Entity(160, 130, new Image(image), "grossini", BlendMode.ADDMINS));
	 add(new Entity(200, 120, new Image(image), "grossini", BlendMode.SCREEN));
	 add(new Entity(220, 130, new Image(image), "grossini", BlendMode.ADD));
	 add(new Entity(230, 140, new Image(image), "grossini", BlendMode.MULTIPLY));
	 add(new Entity(320, 100, new Image(image), "grossini", BlendMode.OPAQUE));
	 add(new Entity(330, 100, new Image(image), "grossini", BlendMode.SCREEN));
	
    }

	override public function update() 
	{
		super.update();
		
		
	}
}