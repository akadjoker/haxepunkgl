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
class ExitLeftStateTransition extends MoveTransition
{
	/** The second state to cross with */
	
	
	private var currState:BasicGameState;


	
	public function new(delayTime:Int, ?ease:EaseFunction) 
	{
		currState = HXP.engine.currentState;
		
		super(currState.x, -HXP.width, delayTime, ease);
			
		
	}
	

	
override	public function update( delta:Float):Void 
	{
			super.update(delta);
		currState.x = progress();
		
		currState.updateState();
		
	}
	
override	public function  RenderBatch( container:SpriteBatch):Void
	{
		currState.render();
	
		
	}


	
override	public function isComplete():Bool 
	{
	  return ( currState.x<=-HXP.width);
	}
	
override public function end():Void 
	{
		
	}
	
	
}