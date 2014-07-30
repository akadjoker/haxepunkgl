package states;

import com.haxepunk.actions.ScaleAction;
import com.haxepunk.graphics.Font;
import com.haxepunk.graphics.Text;
import com.haxepunk.gui.Button;
import com.haxepunk.gui.CheckBox;
import com.haxepunk.gui.Label;
import com.haxepunk.gui.Panel;
import com.haxepunk.gui.RadioButton;
import com.haxepunk.gui.SelfButton;
import com.haxepunk.gui.ToggleButton;
import com.haxepunk.masks.Circle;
import com.haxepunk.masks.Polygon;
import com.haxepunk.shapes.Rect;
import com.haxepunk.state.BasicGameState;
import com.haxepunk.actions.AlphaAction;
import com.haxepunk.actions.MoveToAction;
import com.haxepunk.actions.Actions;
import com.haxepunk.Entity;
import com.haxepunk.gl.Clip;
import com.haxepunk.gl.Game;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.graphics.EmitterGraphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.BitmapFont;
import com.haxepunk.graphics.ImageFont;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.PexParticles;
import com.haxepunk.gui.NineSlice;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.state.transition.CrossStateTransition;
import com.haxepunk.state.transition.EmptyTransition;
import com.haxepunk.state.transition.FadeInTransition;
import com.haxepunk.state.transition.FadeOutTransition;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Util;
import com.haxepunk.utils.VirtualAnalogStick;
import com.haxepunk.utils.VirtualDPad;
import flash.geom.Point;
/**
 * ...
 * @author djoekr
 */
class StateMenu extends BasicGameState
{
	public static var ID:Int = 1;
    var bfont:ImageFont;
	 var player:Entity;
	 var emittg:EmitterGraphic;
	 var emit:Entity;
	 var stick:VirtualAnalogStick;
	 var dpad:VirtualDPad;
	
	 var alpha:AlphaAction;


	 
	 public override  function end()
	 {
		//bfont.dispose();
		
	 }
	 
	public override function begin()
	{
		
		var nin:NineSlice = new NineSlice(128, 128,null,getTexture("gfx/defaultSkin.png"));
	
	
	
		
		var animation:Spritemap = new Spritemap(getTexture("gfx/swordguy.png"));
		     animation.spliteTexture(48, 32);
		     animation.add("stand", [0, 1, 2, 3, 4, 5], 20, true);
			 animation.add("run", [6, 7, 8, 9, 10, 11], 20, true);
			 animation.play("stand");
		
			 add(new Entity(300, 200, animation));
		
		//add(new Entity(0,0,new Backdrop(getTexture("gfx/blocks.png"),true,false)));
	
		

		
		player = new  Entity(90, 90, new Image(getTexture("gfx/grossini.png")));
		
		add(player);
		
		alpha = new AlphaAction(2);
		player.setAlpha(0);
		alpha.setAlpha(1);
	    player.addAction(alpha);
		player.centerPivot();
		player.centerOrigin();
		
		cameraFolow(player, 10, false);
		setCameraBounds( -1000, -1000, 1000, 100, 128, 100);
		
		 var particles:PexParticles = new PexParticles("atlas/explode.pex", "gfx/");
		emittg = particles.createEmitter();
		
		emit = new Entity(200, 100,emittg );
		add(emit);

		fadeOut(1, 0x000000, function()
		{
		 
		});
		/*
		bfont = new ImageFont( "Menu Scene", getTexture("gfx/xfilesfnt.png"), 0);
	
		bfont.scaleX = 0.8;
		bfont.scaleY = 0.8;
		
		add(new Entity(100, 100, bfont));
		*/
		add(new Rect(0, 0, 120, 120, false, 0xff0000));
		stick = new VirtualAnalogStick(300, 200, 85, 10, 100);
		add( stick);
		dpad = new VirtualDPad(100, 200, 85, 10, 100);
		add(dpad);
		
		
	
		
		//add(new Label("label", 300, 10));
		add(new Button(300, 50));
		add(new RadioButton(300, 100));
		add(new CheckBox(300, 150));
		
		var t:Text = new Text("gfx/tinyfont.fnt","luis santos");
		add(new Entity(100, 300, t));
		
		
		var a_b:SelfButton = new SelfButton(150, 100,  new Image(getTexture("gfx/btn-play.png")), new Image(getTexture("gfx/btn-play-down.png")));
		a_b.addAction(new ScaleAction(1.5,0,0.6,Ease.elasticOut));
		add(a_b);
		
		var a_c:SelfButton = new SelfButton(150, 180,  new Image(getTexture("gfx/btn-about.png")), new Image(getTexture("gfx/btn-about-down.png")));
		a_c.addAction(new ScaleAction(0.8,0,0.6,Ease.elasticOut));
		add(a_c);
		
		
		//Util.convertImageCK("gfx/arial.png", "arial.png", 0);
			
//	setCenter();
		
	}
	

     override public function render() 
	{
		super.render();
	
		}
	override public function update() 
	{
		super.update();
		
		
		
		if (Input.mouseReleased)
		{
			emit.x = Input.mouseFlashX;
			emit.y = Input.mouseFlashY;
			
			   //  var target:BasicGameState = HXP.engine.getState(StateGame.ID);
		         // HXP.engine.enterStateTransition(StateGame.ID, new  CrossStateTransition(2000, target), new FadeInTransition(0, 500));


				HXP.engine.enterStateTransition(StateGame.ID,   new FadeOutTransition(0xffffff,500), new FadeInTransition(0xffffff, 500));
				
				//HXP.engine.enterStateTransition(StateGame.ID, new  CrossStateTransition(500,target), new FadeInTransition(0, 500));
				
				
			emittg.restart();
			//Actions.moveBy(player, Input.mouseFlashX, Input.mouseFlashY, 1);
			//Actions.moveBy(player, 10,0, 1);
		}
		
		if (dpad.isleft)
		{
		//	player.x -= 250* HXP.elapsed;
		player.rotate(-0.01);
		} else

		if (dpad.isright)
		{
			player.rotate(0.01);
		//	player.advance(-250 * HXP.elapsed);
			//player.x += 250* HXP.elapsed;
		}
		
		
		if (dpad.isup)
		{
			player.advanceEx(250 * HXP.elapsed,player.getRotation()-90);
			//player.y -= 250* HXP.elapsed;
		} else

		if (dpad.isdown)
		{
			player.advanceEx(-250 * HXP.elapsed,player.getRotation()-90);
			//player.y += 250* HXP.elapsed;
		}
		
		if (Input.mousePressed)
		{
			
		}
			
	//	player.setRotate(		stick.angle);
		
		
	//HXP.camera.x =  player.x - 120;
	//Game.camera.x =  HXP.lerp(Game.camera.x, -player.x , HXP.elapsed*1);
	
	//	HXP.camera.y =  player.y - 100;
	
		
	//	trace(player.x);
		
	//	this.x = - player.x + 100;

	//HXP.camera.x= player.x ;
	//this.x=- player.x ;
		
	//	alpha.act(HXP.elapsed);
		//trace(alpha.getValue());
		
	
		//player.setAlpha(alpha.getValue());
		
	//	skewX += 0.01;

	/*	
		if (Input.mousePressed)
		{
		fadeIn(1, 0xFFFFFF, function()
		{
		
			HXP.scene = new GameScene();
		});
		}
		*/
		
		
	}
	public override function renderLines()
	{
		
		super.renderLines();
	}
		
	public  override function getID():Int 
	{
		return ID;
	}
	
	
	
}