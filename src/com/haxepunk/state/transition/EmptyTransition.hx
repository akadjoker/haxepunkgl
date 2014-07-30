package com.haxepunk.state.transition;

import com.haxepunk.gl.BatchPrimitives;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.state.GameState;

/**
 * ...
 * @author djoekr
 */
class EmptyTransition implements Transition
{

	public function new() 
	{
		
	}
	
	
	
	public function update( delta:Float):Void 
	{
		
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
	
	public function init(firstState:GameState, secondState:GameState):Void 
	{
		
	}
		public function end():Void 
	{
		
	}
	
}