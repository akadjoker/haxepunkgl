package com.haxepunk.state.transition;

import com.haxepunk.gl.BatchPrimitives;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.state.GameState;


/**
 * ...
 * @author djoekr
 */
class FadeOutTransition implements Transition
{
    public var _red:Float;
	public var _green:Float;
	public var _blue:Float;

	    private var fadeTime:Int;
		private var color:UInt;
		private var alpha:Float = 0;
		
	public function new(color : UInt,fadeTime:Int) 
	{
		this.color = color;
		this.fadeTime = fadeTime;
		
		_red = HXP.getRed(color) / 255;
		_green = HXP.getGreen(color) / 255;
		_blue = HXP.getBlue(color) / 255;
		
	}
	
	/* INTERFACE org.slick.state.transition.Transition */
	
	public function update( delta:Float):Void 
	{
		alpha += delta * (1.0 / fadeTime);
		if (alpha > 1) 
		{
			alpha = 1;
		}

	//	trace("alpha:" + alpha);
	}
	
	public function  RenderLines( container:BatchPrimitives):Void
	{
		container.fillrect(0, 0, HXP.width, HXP.height, _red,_green,_blue, alpha);
		//g.beginFill(color, alpha);
	//g.drawRect(0, 0, container.screenWidth,container.screenHeight);
		//g.endFill();
	}
	public function  RenderBatch( container:SpriteBatch):Void
	{
		
	}
	
	public function isComplete():Bool 
	{
		return (alpha >= 1);
	}
	
	public function init(firstState:GameState, secondState:GameState):Void 
	{
		
	}
	public function end():Void 
	{
		
	}
}