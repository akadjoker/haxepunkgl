package com.haxepunk.gl;


import com.haxepunk.gl.filter.Filter;

import openfl.display.OpenGLView;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;


import flash.Lib;
import flash.geom.Rectangle;
import flash.display.BitmapData;

/**
 * ...
 * @author djoker
 */

 typedef TRender=Rectangle-> Void;
 
class Game extends OpenGLView
{
   public static inline var vertexStrideSize =  (3 + 2 + 4) * 4;
//   public static var primitiveShader:PrimitiveShader;
   //public static var spriteShader:SpriteShader;
   public static var game:Game;
   public static var camera:Camera;
   public static var spriteBatch:SpriteBatch;
   public static var lines:BatchPrimitives;
   private var textures:Map<String,Texture>;
   public var screenWidth:Int ;
   public var screenHeight:Int ;
	
	private var enableDepth:Bool;
    public var red:Float;
    public var green:Float;
    public var blue:Float;
	

	public function new(r:TRender):Void
	{
	 super();
	 
	   Game.game = this;
	   screenWidth = Lib.current.stage.stageWidth;
	   screenHeight = Lib.current.stage.stageHeight;
	   Game.camera = new Camera(screenWidth, screenHeight);
	
	   
		
       
		textures = new  Map<String,Texture>();
		spriteBatch = new SpriteBatch(1500);
		lines = new BatchPrimitives(500);
	
	
    GL.disable(GL.CULL_FACE);
    GL.enable(GL.BLEND);
	GL.blendFunc(GL.SRC_ALPHA,GL.DST_ALPHA );
	GL.pixelStorei(GL.PACK_ALIGNMENT, 2);
	GL.enable(GL.DEPTH_TEST);
    setDeph(true);
	clearColor(0, 0, 0);
	GL.depthMask(true);
	GL.colorMask(true, true, true, true);
	GL.activeTexture(GL.TEXTURE0);
	
	
 GL.disableVertexAttribArray (Filter.vertexAttribute);
 GL.disableVertexAttribArray (Filter.texCoordAttribute);
 GL.disableVertexAttribArray (Filter.colorAttribute);	
 GL.bindBuffer (GL.ARRAY_BUFFER, null);	
 GL.useProgram (null);	
 GL.blendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );
 
     this.render = r;// renderView;
	}

	public function setDeph(v:Bool)
	{
		enableDepth = v;
		if (v == true)
		{
		 GL.disable(GL.DEPTH_TEST);
		} else
		{
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.FASTEST);
    	}
	}
	public function clearColor(r:Float, g:Float, b:Float)
	{
		red = r;
		green = g;
		blue = b;
	//	GL.clearColor(red, green, blue, 1);
	  //  GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
	
	}

	

public function addTexture(bitmap:BitmapData,name:String, ?flip:Bool = false ):Texture 
{
 if (textures.exists(name))
	{
		return textures.get(name);
	} else
	{	
	var tex = new Texture();
	tex.setData(bitmap,flip,name);
	textures.set(name,tex);
	return tex;
	}
}

public function getTexture(url:String, ?flip:Bool = false ):Texture 
{
	
	
 if (textures.exists(url))
	{
		return textures.get(url);
	} else
	{	
	var tex = new Texture();
	tex.load(url, flip);
	textures.set(url,tex);
	return tex;
	}
}

public function getTextureEx(url:String,name:String, ?flip:Bool = false ):Texture 
{
 if (textures.exists(url))
	{
		return textures.get(url);
	} else
	{	
	var tex = new Texture();
	tex.load(url, flip);
	textures.set(name,tex);
	return tex;
	}
}

private function renderView(rect:Rectangle):Void 
{ 
	//GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
  //  GL.clearColor(0,0,0, 1);
 //   GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

/*	
GL.disableVertexAttribArray (Filter.vertexAttribute);
 GL.disableVertexAttribArray (Filter.texCoordAttribute);
 GL.disableVertexAttribArray (Filter.colorAttribute);	
 GL.bindBuffer (GL.ARRAY_BUFFER, null);	
 GL.useProgram (null);	
 GL.blendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );
 */
 
//


}

}