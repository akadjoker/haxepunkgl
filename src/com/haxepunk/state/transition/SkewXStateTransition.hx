package com.haxepunk.state.transition;

import com.haxepunk.gl.BatchPrimitives;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.state.GameState;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;


import openfl.Lib;

/**
 * ...
 * @author djoekr
 */
class SkewXStateTransition extends MoveTransition
{
	/** The second state to cross with */
	
	private var _end:Float;
	private var secondState:BasicGameState;

	
	public function new(start:Float, end:Float,delayTime:Int,secondStateID:Int,center:Bool, ?ease:EaseFunction) 
	{
		
		super(start, end, delayTime, ease);
		_end = end;
		this.secondState = HXP.engine.getState(secondStateID);
		secondState.skewX = start;
		if(center) secondState.setCenter();
	}
	

	
override	public function update( delta:Float):Void 
	{
		super.update(delta);
		secondState.skewX = progress();
		secondState.updateState();
	}
	
override	public function isComplete():Bool 
	{
		return (secondState.skewX==_end);
	}
	
override	public function  RenderBatch( container:SpriteBatch):Void
	{
	
	//	secondState.render();
		
	}

	
	
	
}