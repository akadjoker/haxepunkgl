package states;

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
import com.haxepunk.state.transition.FadeInTransition;
import com.haxepunk.state.transition.FadeOutTransition;
import com.haxepunk.state.transition.SkewYStateTransition;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
/**
 * ...
 * @author djoekr
 */
class StateTeste_2 extends BasicGameState
{

		var p_1:Entity;

	public static var ID:Int = 2;

	public  override function getID():Int 
	{
		return ID;
	}
	
	public override function begin()
	{
		//setCenter();
		
	 add(new Entity(0, 0, new Backdrop(getTexture("gfx/tile.png"))));
 		 
	 var caption:String = "Actions";
	 add(new Entity(HXP.width/2-(caption.length*8), 10,new ImageFont( caption, getTexture("gfx/xfilesfnt.png"), 0)));		
	
	 
	
	    var a_a:SelfButton = new SelfButton( 2, HXP.height - 50,  new Image(getTexture("gfx/b1.png")), new Image(getTexture("gfx/b2.png")));
		a_a.onClick = function click(b:SelfButton)
		{
			HXP.engine.enterStateTransition(StateTeste_1.ID,   new SkewYStateTransition(0, 2, 1, getID(),false,Ease.expoIn),  new SkewYStateTransition(2, 0, 1, StateTeste_1.ID,false,Ease.expoIn));
		}
		add(a_a);
		
	    var a_b:SelfButton = new SelfButton(HXP.width - 80, HXP.height - 50,  new Image(getTexture("gfx/f1.png")), new Image(getTexture("gfx/f2.png")));
		a_b.onClick = function click(b:SelfButton)
		{
		HXP.engine.enterStateTransition(StateTeste_3.ID,   new SkewYStateTransition(0, 2, 1, getID(),false,Ease.expoIn),new SkewYStateTransition(2, 0, 1, StateTeste_3.ID,false,Ease.expoIn));
		}
		
		add(a_b);
		

	     p_1 = new Entity(100, 50, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.addAction(new AlphaAction(0, 1,true, 1, true,Ease.quartIn));
		 add(p_1);
	
	     p_1 = new Entity(130, 50, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.addAction(new AlphaAction(0, 1,true, 1, true,Ease.bounceOut));
		 add(p_1);
		 
		 p_1 = new Entity(220, 50, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new ScaleAction(0, 1,true, 1, true,Ease.bounceOut));
		 add(p_1);
		 
		 p_1 = new Entity(260, 50, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new ScaleAction(0, 1,true, 1, true,Ease.backIn));
		 add(p_1);
		 
		  p_1 = new Entity(360, 100, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new SkewAction(-1, 1,true, 1, true,Ease.backIn));
		 add(p_1);
		 
		  p_1 = new Entity(380, 70, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new SkewXAction(-1, 1,true, 1, true));
		 add(p_1);
		 
		 p_1 = new Entity(400, 80, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new SkewYAction(-1, 1,true, 1, true));
		 add(p_1);
		 
		 p_1 = new Entity(10, 200, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new StartMoveToAction(HXP.width-50,200,2,true,true,Ease.bounceIn));
		 add(p_1);
		 
		 p_1 = new Entity(10, 250, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new StartMoveToAction(HXP.width-50,250,2,true,true,Ease.bounceOut));
		 add(p_1);
		 
		  p_1 = new Entity(10, 300, new Image(getTexture("gfx/grossini.png")), "grossini");
		 p_1.centerPivot();
		 p_1.addAction(new StartMoveToAction(HXP.width-50,320,2,true,true,Ease.bounceInOut));
		 add(p_1);
    }

	override public function update() 
	{
		super.update();
		
		
	}
}