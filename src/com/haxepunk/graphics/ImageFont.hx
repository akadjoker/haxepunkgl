package com.haxepunk.graphics;


import com.haxepunk.gl.BlendMode;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.Graphic;
import com.haxepunk.gl.Clip;
import com.haxepunk.gl.Game;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.gl.Texture;
import openfl.geom.Matrix;

import flash.display.Graphics;
import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;



/**
 * ...
 * @author djoker
 */
class ImageFont extends Graphic
{




public var image:Texture;
private var offsetX:Int;
private var offsetY:Int;

public var characterWidth:Int;
public var characterHeight:Int;
private var characterSpacingX:Int;
private var characterSpacingY:Int;
private var characterPerRow:Int;
private var glyphs:Array<Clip>;
private var align:Int;




public var customSpacingX:Int;
public var customSpacingY:Int;

public var caption:String;



public function new(text:String, tex:Texture, ?trim:Int = 0):Void
{
super();


this.caption = text;

align = 0;
customSpacingX = 0;
customSpacingY = 0;


	
scrollX = scrollY = 0;

image = tex;


characterWidth  =   Std.int( image.width / 16);
characterHeight =   Std.int( image.height / 16);
characterSpacingX = 0;
characterSpacingY = 0;
characterPerRow =  Std.int(image.width / characterWidth);
offsetX = 0;
offsetY = 0;

glyphs = new Array<Clip>();


var currentX:Int = offsetX;
var currentY:Int = offsetY;
var r:Int = 0;
var index:Int = 0;

for(c in 30...200)
//for(c in 30...150)
{
glyphs[index++] = new Clip(currentX, currentY, characterWidth, characterHeight);
r++;
if (r == characterPerRow)
{
r = 0;
currentX = offsetX;
currentY += characterHeight + characterSpacingY;
}
else
{
currentX += characterWidth + characterSpacingX;
}
}

}


public function getTextWidth(caption:String):Int 
	{
		var w:Int = 0;
		var textLength:Int = caption.length;
		for (i in 0...(textLength)) 
		{
        var glyph = glyphs[caption.charCodeAt(i)];
		if (glyph != null) 
			{
				w += characterWidth;// glyph.width;
			}
		w = Math.round(w * scale);
		if (textLength > 1)
		{
			w += (textLength - 1) * characterSpacingX;
		}
		}
		return w;
	}

override public function render(m:Matrix, point:Point, camera:Point)
{
	var cx:Int = 0;
    var cy:Int = 0;
	var X:Float = 0;
	var Y:Float = 0;
	var newLine:Float = characterHeight + characterSpacingY;

	   switch (align) 
       { 
       case 0:
       cx = 0;
       case 1:
       cx = getTextWidth(caption);
       case 2:
       cx = Std.int(getTextWidth(caption) / 2);
       }
	   


  for (c in 0...caption.length)   
   {
    if(caption.charAt(c) == " ")
    {
       X += characterWidth + customSpacingX;
    }
    else
	  if(caption.charAt(c) == "\n")
    {
	   Y += newLine;	
       X = characterWidth + customSpacingX;
    } else
      {
        var glyph = glyphs[caption.charCodeAt(c)];
        X += characterWidth + customSpacingX;
        if (glyph != null)
		
		   _point.x = (X-cx)-characterWidth- camera.x * scrollX;
	  	   _point.y = Y - camera.y * scrollY; 
		
	//Game.spriteBatch.RenderFontScale(image,(X-cx)-characterWidth, Y,scaleX,scaleY, glyph, false, true,red,green,blue,alpha,BlendMode.NORMAL);
	Game.spriteBatch.drawEntity(image, m, glyph, _point.x,_point.y, false, false,_red,_green,_blue,alpha,BlendMode.NORMAL);
	
     }
  }
}
public function print(batch:SpriteBatch,caption:String, x:Float, y:Float,?align:Int=0)
{

	var cx:Int = 0;
    var cy:Int = 0;
	var X:Float = x;
	var Y:Float = y;
	var newLine:Float = characterHeight + characterSpacingY;

	   switch (align) 
       { 
       case 0:
       cx = 0;
       case 1:
       cx = getTextWidth(caption);
       case 2:
       cx = Std.int(getTextWidth(caption) / 2);
       }
	   


  for (c in 0...caption.length)   
   {
    if(caption.charAt(c) == " ")
    {
       X += characterWidth + customSpacingX;
    }
    else
	  if(caption.charAt(c) == "\n")
    {
	   Y += newLine;	
       X = x-characterWidth + customSpacingX;
    } else
      {
        var glyph = glyphs[caption.charCodeAt(c)];
        X += characterWidth + customSpacingX;
        if(glyph!=null) batch.RenderFontScale(image,(X-cx)-characterWidth, Y,scaleX,scaleY, glyph, false, true,_red,_green,_blue,alpha,BlendMode.NORMAL);
     }
  }
}

  public function dispose()
{
	for (i in 0...glyphs.length)
	{
		glyphs[i] = null;
	}
	glyphs = null;

}
	
}