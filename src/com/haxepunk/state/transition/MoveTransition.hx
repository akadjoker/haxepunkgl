package com.haxepunk.state.transition;

import com.haxepunk.gl.BatchPrimitives;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.state.GameState;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.Tween;
import com.haxepunk.utils.Ease;


/**
 * ...
 * @author djoekr
 */
class MoveTransition implements Transition
{
	
	public var tween:NumTween;
	public var isEnd:Bool;

	public function new(fromValue:Float, toValue:Float, duration:Float, ?ease:EaseFunction) 
	{
		tween = new NumTween(complete);
		tween.tween(fromValue, toValue, duration, ease);
		isEnd = false;
		
	}
	
	public function progress():Float
	{
		return tween.value;
	}
	
	public function complete(event:Dynamic)
	{
		trace("end");
	}
	
	public function update( delta:Float):Void 
	{
		tween.update();
	}
	
	public function RenderBatch( container:SpriteBatch):Void
	{
		
	}
	
	public  function  RenderLines( container:BatchPrimitives):Void
	
	{
		
	}
	
	public function isComplete():Bool 
	{
		return true;
	}
	
	public function init(firstState:BasicGameState, secondState:BasicGameState):Void 
	{
	
		
		
	}
	
	public function end():Void 
	{
		
	}
}