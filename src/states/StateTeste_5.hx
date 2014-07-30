package states;

import actors.Player;
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
import com.haxepunk.state.transition.FromRightStateTransition;
import com.haxepunk.state.transition.ExitLeftStateTransition;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.masks.Grid;
import com.haxepunk.utils.VirtualDPad;
/**
 * ...
 * @author djoekr
 */
class StateTeste_5 extends BasicGameState
{

	private static var map:Array<Array<Int>> = [
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1],
		[1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1],
		[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1],
		[1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	];
    private var player:Player;
	var dpad:VirtualDPad;
	
	
	public static var ID:Int = 5;

	public  override function getID():Int 
	{
		return ID;
	}
	override public function leave():Void 
	{
		super.leave();
		reset();
	}
	public override function begin()
	{
		  add(new Entity(0, 0, new Backdrop(getTexture("gfx/tile.png"))));
 	
		  dpad = new VirtualDPad(30, 180, 85, 10, 100);
		  add(dpad);
		
		
		  player = new Player(dpad,getTexture("gfx/character.png"),10 * 32, 11 * 32);
		   add(player);

		   
		var mapWidth:Int = map[0].length;
		var mapHeight:Int = map.length;

		// Create tilemap
		var tilemap:Tilemap = new Tilemap(getTexture("gfx/block.png"), mapWidth * 32, mapHeight * 32, 32, 32);
		// Create grid mask
		var grid:Grid = new Grid(tilemap.columns * tilemap.tileWidth, tilemap.rows * tilemap.tileHeight, tilemap.tileWidth, tilemap.tileHeight);

		// Fill the tilemap and grid programatically
		for (i in 0...tilemap.columns)
		{
			for (j in 0...tilemap.rows)
			{
				var tile = map[j][i];
				if (tile != 0)
				{
					tilemap.setTile(i, j, tile);
					grid.setTile(i, j, true);
				}
			}
		}

		// Create a new entity to use as a tilemap
		var entity:Entity = new Entity(0, 0, tilemap, "solid", 0, grid);
		add(entity);
		
	 var caption:String = "Tiles";
	 add(new Entity(HXP.width/2-(caption.length*8), 10,new ImageFont( caption, getTexture("gfx/xfilesfnt.png"), 0)));		
	
	 
	
	    var a_a:SelfButton = new SelfButton( 2, HXP.height - 50,  new Image(getTexture("gfx/b1.png")), new Image(getTexture("gfx/b2.png")));
		a_a.onClick = function click(b:SelfButton)
		{
		HXP.engine.enterStateTransition(StateTeste_4.ID,   new ExitLeftStateTransition(1, Ease.bounceIn), new FromRightStateTransition(1, StateTeste_4.ID, Ease.bounceOut));
		}
		add(a_a);
		
	    var a_b:SelfButton = new SelfButton(HXP.width - 80, HXP.height - 50,  new Image(getTexture("gfx/f1.png")), new Image(getTexture("gfx/f2.png")));
		a_b.onClick = function click(b:SelfButton)
		{
		HXP.engine.enterStateTransition(StateTeste_6.ID,   new ExitLeftStateTransition(1, Ease.bounceIn), new FromRightStateTransition(1, StateTeste_6.ID, Ease.bounceOut));
	
		}
	
		add(a_b);
		
		   

    }

	override public function update() 
	{
		//backdrop.x += 1;
		//backdrop.y += 2 * HXP.sign(player.gravity.y);
		super.update();
		if (player != null)
		{
		HXP.camera.x = player.x - HXP.halfWidth;
		HXP.camera.y = player.y - HXP.halfHeight;
		}
		
		
		
	}
}