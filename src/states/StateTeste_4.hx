package states;

import com.haxepunk.actions.AlphaAction;
import com.haxepunk.actions.MoveToAction;
import com.haxepunk.actions.ScaleAction;
import com.haxepunk.actions.SkewAction;
import com.haxepunk.actions.SkewXAction;
import com.haxepunk.actions.SkewYAction;
import com.haxepunk.actions.StartMoveToAction;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Emitter;
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
import com.haxepunk.state.transition.FromRightStateTransition;
import com.haxepunk.state.transition.ExitLeftStateTransition;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
/**
 * ...
 * @author djoekr
 */
class StateTeste_4 extends BasicGameState
{

		private var backdrop:Backdrop;
	private var smokeEntity:Entity;
	private var smoke:Emitter;
	
		var emittg:EmitterGraphic;
	    var emit:Entity;
	

	public static var ID:Int = 4;

	public  override function getID():Int 
	{
		return ID;
	}
	
	public override function begin()
	{
	    HXP.camera.x = 0;
		HXP.camera.y = 0;
		
		 add(new Entity(0, 0, new Backdrop(getTexture("gfx/tile.png"))));
 	
		
		
		smoke = new Emitter(getTexture("gfx/esmoke.png"));
		smoke.newType("exhaust", [0]);
		smoke.setMotion("exhaust", 90, 30, 0.5, 360, 10, 0.5);
		smoke.setAlpha("exhaust");

		smokeEntity = addGraphic(smoke);
		
		 var particles:PexParticles = new PexParticles("atlas/fire.pex", "gfx/");
		emittg = particles.createEmitter();
		
		emit = new Entity(200, 100,emittg );
		add(emit);
		
	 var caption:String = "Particles";
	 add(new Entity(HXP.width/2-(caption.length*8), 10,new ImageFont( caption, getTexture("gfx/xfilesfnt.png"), 0)));		
	
	 
	
	    var a_a:SelfButton = new SelfButton( 2, HXP.height - 50,  new Image(getTexture("gfx/b1.png")), new Image(getTexture("gfx/b2.png")));
		a_a.onClick = function click(b:SelfButton)
		{
		//	HXP.engine.enterStateTransition(StateTeste_3.ID,   new FadeOutTransition(0,500), new FadeInTransition(0, 500));
		   	HXP.engine.enterStateTransition(StateTeste_3.ID,   new ExitLeftStateTransition(1,Ease.bounceIn), new FromRightStateTransition(1,StateTeste_3.ID,Ease.bounceOut));
	
		}
		add(a_a);
		
	    var a_b:SelfButton = new SelfButton(HXP.width - 80, HXP.height - 50,  new Image(getTexture("gfx/f1.png")), new Image(getTexture("gfx/f2.png")));
		a_b.onClick = function click(b:SelfButton)
		{
				HXP.engine.enterStateTransition(StateTeste_5.ID,   new ExitLeftStateTransition(1,Ease.bounceIn), new FromRightStateTransition(1,StateTeste_5.ID,Ease.bounceOut));
		}
	
		add(a_b);
		

    }
	private function onTouch(touch:com.haxepunk.utils.Touch)
	{
		smoke.emit("exhaust", touch.sceneX, touch.sceneY);
	}

	override public function update() 
	{
		super.update();
		
		
		if (Input.multiTouchSupported)
		{
			Input.touchPoints(onTouch);
		}
		else
		{
			for (i in 0...10)
			{
				smoke.emit("exhaust", Input.localX, Input.localY);
			}

			if (Input.mousePressed)
			{
				//smoke.emit("exhaust", mouseX, mouseY);
				smoke.setColor("exhaust", HXP.rand(16777215), HXP.rand(16777215));
			}
		}
		
		
	}
}