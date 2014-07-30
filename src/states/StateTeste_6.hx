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
import com.haxepunk.shapes.Ellipse;
import com.haxepunk.state.BasicGameState;
import com.haxepunk.state.transition.FadeInTransition;
import com.haxepunk.state.transition.FadeOutTransition;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.masks.Circle;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.masks.SlopedGrid;

/**
 * ...
 * @author djoekr
 */
class StateTeste_6 extends BasicGameState
{

	private var entity:Ellipse;
	private var image:Image;

	public static var ID:Int = 6;

	public  override function getID():Int 
	{
		return ID;
	}
	/*
	override public function enter():Void 
	{
		super.enter();
		HXP.debugDrawMask = true;
		HXP.debugEntityBound = true;
	}
	override public function leave():Void 
	{
		super.leave();
		HXP.debugDrawMask = false;
		HXP.debugEntityBound = false;
		
	}
	*/
	public override function begin()
	{
		HXP.camera.x = 0;
		HXP.camera.y = 0;
		
		
		var grid = new SlopedGrid(320, 320, 32, 32);
		grid.setRect(0, 0, 10, 1, Solid);
		grid.setRect(0, 9, 10, 1, Solid);
		grid.setRect(0, 0, 1, 10, Solid);
		grid.setRect(9, 0, 1, 10, Solid);
		grid.setRect(1, 4, 1, 2, Solid);
		grid.setRect(8, 4, 1, 2, Solid);

		// quick 45 degree slopes
		grid.setTile(1, 1, TopLeft);
		grid.setTile(8, 1, TopRight);
		grid.setTile(1, 8, BottomLeft);
		grid.setTile(8, 8, BottomRight);
		// custom slopes
		grid.setTile(4, 4, BelowSlope, -0.5, 1);
		grid.setTile(5, 4, BelowSlope, 0.5, 0.5);
		grid.setTile(4, 5, AboveSlope, 0.5);
		grid.setTile(5, 5, AboveSlope, -0.5, 0.5);

		grid.setTile(3, 8, BelowSlope, -0.25, 1);
		grid.setTile(4, 8, BelowSlope, -0.75, 0.75);
		grid.setTile(5, 8, BelowSlope, 0.75);
		grid.setTile(6, 8, BelowSlope, 0.25, 0.75);

		grid.setTile(3, 1, AboveSlope, 0.8, -0.5);
		grid.setTile(4, 1, AboveSlope, 0.2, 0.3);
		grid.setTile(5, 1, AboveSlope, -0.2, 0.5);
		grid.setTile(6, 1, AboveSlope, -0.8, 0.3);
		//addMask(grid, "mask", 80, 10);

		var colider = new Entity(80, 10, new Image(getTexture("gfx/slope.png")), "mask", 0, grid);
		add(colider);
		
		entity = new Ellipse(0, 0, 8, true);
		//entity.mask = new Circle(8, -8, -8);
		entity.centerOrigin();
		add(entity);
		
		
		
	 var caption:String = "Slope";
	 add(new Entity(HXP.width/2-(caption.length*8), 10,new ImageFont( caption, getTexture("gfx/xfilesfnt.png"), 0)));		
	
	 
	
	    var a_a:SelfButton = new SelfButton( 2, HXP.height - 50,  new Image(getTexture("gfx/b1.png")), new Image(getTexture("gfx/b2.png")));
		a_a.onClick = function click(b:SelfButton)
		{
			HXP.engine.enterStateTransition(StateTeste_5.ID,   new FadeOutTransition(0,500), new FadeInTransition(0, 500));
		}
		add(a_a);
		
	    var a_b:SelfButton = new SelfButton(HXP.width - 80, HXP.height - 50,  new Image(getTexture("gfx/f1.png")), new Image(getTexture("gfx/f2.png")));
		a_b.onClick = function click(b:SelfButton)
		{
		HXP.engine.enterStateTransition(StateTeste_1.ID,   new FadeOutTransition(0,500), new FadeInTransition(0, 500));
		}
	
		add(a_b);
		

    }

	override public function update() 
	{
		
		
	
		entity.x = Input.localX;
		entity.y = Input.localY;
		if (entity.collide("mask", entity.x, entity.y) != null)
		{
			entity.color = 0xFF0000;
		}
		else
		{
		  entity.color = 0xFFFFFF;
		}
		
		super.update();
		
		
	}
}