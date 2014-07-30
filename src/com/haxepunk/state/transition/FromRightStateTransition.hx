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
class FromRightStateTransition extends MoveTransition
{
	/** The second state to cross with */
	
	
	private var currState:BasicGameState;
	private var secondState:BasicGameState;

	
	public function new(delayTime:Int,secondStateID:Int, ?ease:EaseFunction) 
	{
		
		super(HXP.width, 0, delayTime, ease);
		currState = HXP.engine.currentState;
		this.secondState = HXP.engine.getState(secondStateID);
		this.secondState.x = HXP.width;
	}
	

	
override	public function update( delta:Float):Void 
	{
		super.update(delta);
		secondState.x = progress();
		if(currState!=null) currState.updateState();
		secondState.updateState();
	}
	
override	public function isComplete():Bool 
	{
		return (secondState.x<=0);
	}
	
override	public function  RenderBatch( container:SpriteBatch):Void
	{
		if(currState!=null) currState.render();
		secondState.render();
		
	}

	override public function end():Void 
	{
		
	}
	
	
}