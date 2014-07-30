package states;

import com.haxepunk.Entity;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.gl.Texture;
import com.haxepunk.gl.BlendMode;
import com.haxepunk.graphics.EmitterGraphic;
import com.haxepunk.graphics.ImageFont;
import com.haxepunk.graphics.PexParticles;
import com.haxepunk.state.BasicGameState;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author djoekr
 */
class StateGame extends BasicGameState
{
	    var bfont:ImageFont;
		var emittg:EmitterGraphic;
	    var emit:Entity;
		var image:Texture;

	public static var ID:Int = 2;

	public  override function getID():Int 
	{
		return ID;
	}
	
		public override function init()
	{
		bfont = new ImageFont( "Game Scene", getTexture("gfx/xfilesfnt.png"), 0);
	
		bfont.scaleX = 0.8;
		bfont.scaleY = 0.8;
		
		add(new Entity(200, 100, bfont));
		
		 var particles:PexParticles = new PexParticles("atlas/explode.pex", "gfx/");
		emittg = particles.createEmitter();
		
		emit = new Entity(200, 100,emittg );
		add(emit);
		
		image = getTexture("gfx/grossini.png");
		
}

override public function  preRenderBatch(batch:SpriteBatch)
{
	
batch.RenderNormal(image, 100, 100, BlendMode.NORMAL );
batch.RenderNormal(image, 120, 190, BlendMode.NORMAL );
batch.RenderNormal(image, 40, 140, BlendMode.NORMAL );
batch.RenderNormal(image, 120, 150, BlendMode.NORMAL );
batch.RenderNormal(image, 160, 120, BlendMode.NORMAL );
batch.RenderNormal(image, 40, 120, BlendMode.NORMAL );
batch.RenderNormal(image, 60, 150, BlendMode.NORMAL );
batch.RenderNormal(image, 120, 120, BlendMode.NORMAL );
batch.RenderNormal(image, 140, 140, BlendMode.NORMAL );
batch.RenderNormal(image, 180, 100, BlendMode.ADD );
batch.RenderNormal(image, 220, 120, BlendMode.MULTIPLY );
batch.RenderNormal(image, 240, 140, BlendMode.SCREEN );


		

}
	override public function update() 
	{
		super.update();
		
		if (Input.mouseReleased)
		{
			emit.x = Input.mouseFlashX;
			emit.y = Input.mouseFlashY;
				
			emittg.restart();
		}
	}
}