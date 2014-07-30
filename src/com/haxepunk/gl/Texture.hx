package com.haxepunk.gl;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLTexture;
import openfl.utils.UInt8Array;

import flash.display.Bitmap;
import flash.utils.ByteArray;
import flash.geom.Matrix;
import flash.display.BitmapData;
import flash.Lib;

import openfl.Assets;

import com.haxepunk.utils.Util;



	#if neko

import sys.io.File;
import sys.io.FileOutput;
		#end
		

/**
 * ...
 * @author djoker
 */
class Texture
{
	
	public static var Linear:Bool = true;
    public var data:GLTexture;
	public var width:Int;	
	public var height:Int;
	public var texHeight:Int;
	public var texWidth:Int;
	public var name:String;
	private var exists:Bool;
	public var invTexWidth:Float;
	public var invTexHeight:Float;
	
	public function Bind()
	{
	 if (!exists) return;
     GL.bindTexture(GL.TEXTURE_2D, data);
	}

	public function setData(bitmapData:BitmapData, ?flip:Bool = false,?newname:String="bitmap" )
	{
		exists = false;
		if (bitmapData == null) 
		{
			throw ("Bitmap is null");
		}
		
	this.name = newname;
	if (bitmapData == null) 
	throw( "data is null");
	

	if (flip)
	{
	  bitmapData = Util.flipBitmapData(bitmapData);
	}
    data = GL.createTexture ();	
	GL.bindTexture(GL.TEXTURE_2D, data);
		
		this.width = bitmapData.width;
		this.height = bitmapData.height;

		this.texWidth =  Util.getNextPowerOfTwo(width);
		this.texHeight = Util.getNextPowerOfTwo(height);
	
	#if debug trace("Texture "+ newname+" size :"+width + '<>' + height + '<>' + texWidth + '<>' + texHeight); #end
	
		
	GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
    GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
	
	if (Linear)
	{
     GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
	GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		}else
	{	
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
	GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
	}
	
		if (!Util.isTextureOk(bitmapData))
		{
			//bitmapData = Util.fixTextureSize(bitmapData);
			bitmapData = Util.getScaledDraw(bitmapData,texWidth, texHeight);
			//bitmapData = Util.getScaledDontFit(bitmapData);
			//bitmapData = Util.getScaledDraw(bitmapData, texWidth, texHeight);
			//Util.saveBitmapData(bitmapData, url);
		}
		
		    #if html5
			var pixelData = bitmapData.getPixels(bitmapData.rect).byteView;
			#else
			var pixelData = new UInt8Array(BitmapData.getRGBAPixels(bitmapData));
			#end
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, texWidth,texHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixelData);
      	
            bitmapData.dispose();
		    pixelData = null;
			
		
 

		     invTexWidth  = 1.0 /texWidth;
             invTexHeight = 1.0 /texHeight;

       
			// trace(url+": invWidth " + invTexWidth + " invHeight" + invTexHeight);
			exists = true;
	
	}
	
	public function load(url:String, ?flip:Bool = false ) 
	{
	name = url;
	var  bitmapData:BitmapData ;	
    bitmapData = Assets.getBitmapData(url);
	if (bitmapData == null) 
	throw( url +" dont exists");
	
	if (flip)
	{
	  bitmapData = Util.flipBitmapData(bitmapData);
	}
    data = GL.createTexture ();	
	GL.bindTexture(GL.TEXTURE_2D, data);
		
		this.width = bitmapData.width;
		this.height = bitmapData.height;

		this.texWidth =  Util.getNextPowerOfTwo(width);
		this.texHeight = Util.getNextPowerOfTwo(height);
	
	#if debug trace("Texture "+ url+" size :"+width + '<>' + height + '<>' + texWidth + '<>' + texHeight); #end
	
		
	GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
    GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
	if (Linear)
	{
     GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
	GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		}else
	{	
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
	GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
	}

	
		if (!Util.isTextureOk(bitmapData))
		{
			//bitmapData = Util.fixTextureSize(bitmapData);
			bitmapData = Util.getScaledDraw(bitmapData,texWidth, texHeight);
			//bitmapData = Util.getScaledDontFit(bitmapData);
			//bitmapData = Util.getScaledDraw(bitmapData, texWidth, texHeight);
			//Util.saveBitmapData(bitmapData, url);
		}
		
		    #if html5
			var pixelData = bitmapData.getPixels(bitmapData.rect).byteView;
			#else
			var pixelData = new UInt8Array(BitmapData.getRGBAPixels(bitmapData));
			#end
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, texWidth,texHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixelData);
      	
             bitmapData.dispose();
			 pixelData = null;
			
		
 

		     invTexWidth  = 1.0 /texWidth;
             invTexHeight = 1.0 /texHeight;

       
			// trace(url+": invWidth " + invTexWidth + " invHeight" + invTexHeight);
			exists = true;
	
		
	}
	/*
	public function load(url:String, ?flip:Bool = false ) 
	{
	name = url;
	var  bitmapData:BitmapData ;	
    bitmapData = Assets.getBitmapData(url);
	if (bitmapData==null) return ;
	
	if (flip)
	{
	bitmapData = Util.flipBitmapData(bitmapData);
	}
    data = GL.createTexture ();	
	GL.bindTexture(GL.TEXTURE_2D, data);
		
		this.width = bitmapData.width;
		this.height = bitmapData.height;

		this.texWidth =  Util.getNextPowerOfTwo(width);
		this.texHeight = Util.getNextPowerOfTwo(height);
	
		
			
		 var isPot = (bitmapData.width == texWidth && bitmapData.height == texHeight);
		  

			
	GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
	GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);

			
			if (!isPot)
			{
			var workingCanvas:BitmapData = Util.getScaledDraw(bitmapData, texWidth, texHeight);
			Util.saveBitmapData(workingCanvas, url);
			#if html5
			var pixelData = workingCanvas.getPixels(workingCanvas.rect).byteView;
			#else
			var pixelData = new UInt8Array(BitmapData.getRGBAPixels(workingCanvas));
			#end
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, workingCanvas.width, workingCanvas.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixelData);
			
		


				
				
			} else
			{
													
			#if html5
			var pixelData = bitmapData.getPixels(bitmapData.rect).byteView;
			#else
			var pixelData = new UInt8Array(BitmapData.getRGBAPixels(bitmapData));
			#end
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, texWidth, texHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixelData);
      		}

	


		     invTexWidth  = 1.0 / texWidth;
             invTexHeight = 1.0 /texHeight;

       
			exists = true;
	
		
	}
	

	
	public function load(url:String, ?flip:Bool = false ) 
	{
	name = url;
	var  bitmapData:BitmapData = Assets.getBitmapData(url);
	if (bitmapData==null) return ;
	
	if (flip)
	{
	bitmapData = Util.flipBitmapData(bitmapData);
	}
    data = GL.createTexture ();	
	GL.bindTexture(GL.TEXTURE_2D, data);
		
		this.width = bitmapData.width;
		this.height = bitmapData.height;

		
		
		  

			
	GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
	GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);

			
		    var potWidth = Util.getExponantOfTwo(bitmapData.width, 1024*4);
            var potHeight = Util.getExponantOfTwo(bitmapData.height, 1024 * 4);
			
				this.texWidth =  potWidth;
		        this.texHeight = potHeight;
	
		#if debug trace("Texture size:" +url +" "+width + '<>' + height + '<>' + texWidth + '<>' + texHeight); #end
		
		var workingCanvas:BitmapData;
		
            var isPot = (bitmapData.width == potWidth && bitmapData.height == potHeight);
			workingCanvas = bitmapData;

            if (!isPot) 
			{
               workingCanvas =getScaled(bitmapData, Std.int(potWidth/2), Std.int(potHeight/2));
            }
												
			#if html5
			var pixelData = workingCanvas.getPixels(workingCanvas.rect).byteView;
			#else
			var pixelData = new UInt8Array(BitmapData.getRGBAPixels(workingCanvas));
			#end
			
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, workingCanvas.width, workingCanvas.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixelData);
            

		     invTexWidth  = 1.0 / texWidth;
             invTexHeight = 1.0 /texHeight;

       
			exists = true;
	
		
	}
	*/
	public function new() 
	{
		this.width =0;
		this.height = 0;
		this.texWidth = 0;
		this.texHeight = 0;
		exists = false;
         
		 
	}
	
	public function dispose()
	{
		GL.deleteTexture(data);
		//trace(name);
	}
	
	
}