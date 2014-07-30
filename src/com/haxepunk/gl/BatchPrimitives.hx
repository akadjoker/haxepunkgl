package com.haxepunk.gl;

import com.haxepunk.math.Vector2;
import flash.geom.Matrix;
import flash.geom.Point;

import com.haxepunk.gl.Game;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;



/**
 * ...
 * @author djoker
 */
class BatchPrimitives 
{
	public var colorBuffer:GLBuffer;
	public var colorIndex:Int;
	public var colors:Float32Array;
	public var vertexBuffer:GLBuffer;
	public var vertices:Float32Array;

	   
	private var cp:Vector2 = new Vector2(0, 0);
	
	public var fcolorBuffer:GLBuffer;
	public var fcolorIndex:Int;
	public var fcolors:Float32Array;
	public var fvertexBuffer:GLBuffer;
	public var fvertices:Float32Array;
	
	
    private var capacity:Int;



	private var alpha:Float = 1;
	public var _red:Float=1;
	public var _green:Float=1;
	public var _blue:Float=1;


	private var currentBlendMode:Int;


	private var idxCols:Int;
	private var idxPos:Int;

	
    private var fidxCols:Int;
	private var fidxPos:Int;

   
    public var shader:PrimitiveShader;
  




	
	public function new(capacity:Int) 
	{
	this.vertexBuffer =  GL.createBuffer();
	this.colorBuffer =  GL.createBuffer();
	this.fvertexBuffer =  GL.createBuffer();
	this.fcolorBuffer =  GL.createBuffer();
	this.capacity = capacity;

    idxPos=0;
	idxCols = 0;


	fidxPos=0;
	fidxCols = 0;

    vertices = new Float32Array(capacity * 3 *4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
	GL.bufferData(GL.ARRAY_BUFFER,this.vertices , GL.DYNAMIC_DRAW);
	colors = new Float32Array(capacity * 4 * 4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.colorBuffer);
	GL.bufferData(GL.ARRAY_BUFFER, this.colors , GL.DYNAMIC_DRAW);
    
	fvertices = new Float32Array(capacity * 3 *4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.fvertexBuffer);
	GL.bufferData(GL.ARRAY_BUFFER,this.fvertices , GL.DYNAMIC_DRAW);
	fcolors = new Float32Array(capacity * 4 * 4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.fcolorBuffer);
	GL.bufferData(GL.ARRAY_BUFFER, this.fcolors , GL.DYNAMIC_DRAW);

	currentBlendMode = BlendMode.NORMAL;
	shader = new PrimitiveShader();
	}
	
	

	
	
public function vertex(x:Float, y:Float, ?z:Float = 0.0)
{
		vertices[idxPos++] = x;
        vertices[idxPos++] = y;
        vertices[idxPos++] = z;
	
}
public function color(r:Float, g:Float,b:Float, ?a:Float =0.0)
	{
	colors[idxCols++] = r;
	colors[idxCols++] = g;
	colors[idxCols++] = b;
	colors[idxCols++] = a;	
	}

public function fvertex(x:Float, y:Float, ?z:Float = 0.0)
{
		fvertices[fidxPos++] = x;
        fvertices[fidxPos++] = y;
        fvertices[fidxPos++] = z;
	
}
public function fcolor(r:Float, g:Float,b:Float, ?a:Float =0.0)
	{
	fcolors[fidxCols++] = r;
	fcolors[fidxCols++] = g;
	fcolors[fidxCols++] = b;
	fcolors[fidxCols++] = a;	
	}


	public function begin()
	{
	 idxPos=0;
	 idxCols = 0;
	 fidxPos=0;
	 fidxCols = 0;

	}
    public function end()
	{

	shader.Enable();
	BlendMode.setBlend(currentBlendMode);

	shader.setProjMatrix(Game.camera.projMatrix);
	shader.setViewMatrix(Game.camera.viewMatrix);
	

   
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.fvertexBuffer);	
     GL.bufferSubData(GL.ARRAY_BUFFER, 0, this.fvertices);
     GL.vertexAttribPointer(shader.vertexAttribute, 3, GL.FLOAT, false, 0, 0);
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.fcolorBuffer);
	 GL.bufferSubData(GL.ARRAY_BUFFER, 0, this.fcolors);
     GL.vertexAttribPointer(shader.colorAttribute, 4, GL.FLOAT, false, 0, 0);
 	 GL.drawArrays( GL.TRIANGLES, 0, Std.int(fidxPos / 3));

	 
	 
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);	
     GL.bufferSubData(GL.ARRAY_BUFFER, 0, this.vertices);
     GL.vertexAttribPointer(shader.vertexAttribute, 3, GL.FLOAT, false, 0, 0);
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.colorBuffer);
	 GL.bufferSubData(GL.ARRAY_BUFFER, 0, this.colors);
     GL.vertexAttribPointer(shader.colorAttribute, 4, GL.FLOAT, false, 0, 0);
	 GL.drawArrays(GL.LINES, 0, Std.int(idxPos / 3));
  
	
	}


	
	//**********
	public function circle (x:Float, y:Float, radius:Float , segments:Int,r:Float,g:Float,b:Float,?a:Float=1 ) 
	{
	
		var angle:Float = 2 * 3.1415926 / segments;
		var cos:Float = Math.cos(angle);
		var sin:Float = Math.sin(angle);
		var cx:Float = radius;
		var cy:Float = 0;
		for ( i  in 0...segments)
		 {
	
				vertex(x + cx, y + cy, 0);color(r, g, b, a);
				var temp = cx;
				cx = cos * cx - sin * cy;
				cy = sin * temp + cos * cy;
				
				vertex(x + cx, y + cy, 0);color(r, g, b, a);
			}
			
			vertex(x + cx, y + cy, 0);color(r, g, b, a);
			
			vertex(x, y, 0);color(r, g, b, a);
			
			vertex(x + cx, y + cy, 0);color(r, g, b, a);
		

		var temp:Float = cx;
		cx = radius;
		cy = 0;
		
		vertex(x + cx, y + cy, 0);color(r, g, b, a);
	}
public function fillcircle (x:Float, y:Float, radius:Float , segments:Int,r:Float,g:Float,b:Float,?a:Float=1 ) 
	{
	
		var angle:Float = 2 * 3.1415926 / segments;
		var cos:Float = Math.cos(angle);
		var sin:Float = Math.sin(angle);
		var cx:Float = radius;
		var cy:Float = 0;
		segments--;
		for ( i  in 0...segments)
		 {
				fvertex(x, y, 0);fcolor(r, g, b, a);
				fvertex(x + cx, y + cy, 0);fcolor(r, g, b, a);
				var temp:Float = cx;
				cx = cos * cx - sin * cy;
				cy = sin * temp + cos * cy;

				fvertex(x + cx, y + cy, 0);fcolor(r, g, b, a);
				
			}
		
			
	
			fvertex(x, y, 0);fcolor(r, g, b, a);
			fvertex(x + cx, y + cy, 0);fcolor(r, g, b, a);
		

		var temp:Float = cx;
		cx = radius;
		cy = 0;
		
		fvertex(x + cx, y + cy, 0);fcolor(r, g, b, a);
	}

	public function ellipse ( x:Float, y:Float, width:Float, height:Float, segments:Int,r:Float,g:Float,b:Float,?a:Float=1 ) 
	{
	
		var  angle:Float = 2 * 3.1415926/ segments;

		var cx:Float = x + width / 2; 
		var cy:Float = y + height / 2;
		

			for (i in 0... segments)
			{
	
				vertex(cx + (width * 0.5 * Math.cos(i * angle)), cy + (height * 0.5 * Math.sin(i * angle)), 0);
				color(r, g, b, a);

		
				vertex(cx + (width * 0.5 * Math.cos((i + 1) * angle)),cy + (height * 0.5 * Math.sin((i + 1) * angle)), 0);
				color(r, g, b, a);
			}
		
	}
	public function fillellipse ( x:Float, y:Float, width:Float, height:Float, segments:Int,r:Float,g:Float,b:Float,?a:Float=1 ) 
	{
	
		var  angle:Float = 2 * 3.1415926/ segments;

		var cx:Float = x + width / 2; 
		var cy:Float = y + height / 2;
		

			for (i in 0... segments)
			{
	
				fvertex(cx + (width * 0.5 * Math.cos(i * angle)), cy + (height * 0.5 * Math.sin(i * angle)), 0);
				fcolor(r, g, b, a);

		     	fvertex(cx ,cy, 0);
				fcolor(r, g, b, a);
				
				fvertex(cx + (width * 0.5 * Math.cos((i + 1) * angle)),cy + (height * 0.5 * Math.sin((i + 1) * angle)), 0);
				fcolor(r, g, b, a);
			}
		
	}	
public function line(x1:Float,y1:Float,x2:Float,y2:Float,r:Float,g:Float,b:Float,?a:Float=1)
{

vertex(x1, y1);
color(r, g, b, a);
vertex(x2, y2);
color(r, g, b, a);
}

public function rect(x:Float,y:Float,width:Float,height:Float,r:Float,g:Float,b:Float,?a:Float=1)
{
			vertex(x, y, 0);color(r, g, b, a);
			vertex(x + width, y, 0);color(r, g, b, a);
			vertex(x + width, y, 0);color(r, g, b, a);
			vertex(x + width, y + height, 0);color(r, g, b, a);
			vertex(x + width, y + height, 0);color(r, g, b, a);
			vertex(x, y + height, 0);color(r, g, b, a);
			vertex(x, y + height, 0);color(r, g, b, a);
			vertex(x, y, 0);color(r, g, b, a);
}

public function fillrect(x:Float,y:Float,width:Float,height:Float,r:Float,g:Float,b:Float,?a:Float=1)
{
		
			fvertex(x, y, 0);fcolor(r, g, b, a);
			fvertex(x + width, y, 0);fcolor(r, g, b, a);
			fvertex(x + width, y + height, 0);fcolor(r, g, b, a);
			fvertex(x + width, y + height, 0);fcolor(r, g, b, a);
			fvertex(x, y + height, 0);fcolor(r, g, b, a);
			fvertex(x, y, 0);fcolor(r, g, b, a);
}
 public function dispose():Void 
{
		this.vertices = null;
		this.colors = null;
    	GL.deleteBuffer(vertexBuffer);
		GL.deleteBuffer(colorBuffer);
	
		this.fvertices = null;
		this.fcolors = null;
    	GL.deleteBuffer(fvertexBuffer);
		GL.deleteBuffer(fcolorBuffer);

}

///****************************************FLASH COMPA
public function lineStyle(thickness:Float = 0, color:Int = 0, alpha:Float = 1.0):Void
{
	     this.alpha = alpha;
      	color &= 0xFFFFFF;
	    _red = HXP.getRed(color) / 255;
		_green = HXP.getGreen(color) / 255;
		_blue = HXP.getBlue(color) / 255;
}
public function beginFill(color:Int = 0, alpha:Float = 1.0):Void
{
	    this.alpha = alpha;
      	color &= 0xFFFFFF;
	    _red = HXP.getRed(color) / 255;
		_green = HXP.getGreen(color) / 255;
		_blue = HXP.getBlue(color) / 255;
}
public function endFill():Void
{
	    
}

public function drawRect(x:Float, y:Float, width:Float, height:Float):Void
{
rect(x, y, width, height, _red, _green, _blue, alpha);
}

public function moveTo(x:Float, y:Float):Void
{
cp.set(x, y);
}
public function lineTo(x:Float, y:Float):Void
{
	line(cp.x, cp.y,x,y,_red,_green,_blue,alpha);
	cp.set(x, y);

}
public function drawCircle(x:Float, y:Float,radius:Float):Void
{
circle(x,y,radius,12,_red, _green, _blue, alpha);
}



}