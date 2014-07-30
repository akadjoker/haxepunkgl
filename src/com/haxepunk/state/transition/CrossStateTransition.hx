package com.haxepunk.state.transition;

import com.haxepunk.gl.BatchPrimitives;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.state.BasicGameState;
import com.haxepunk.state.GameState;


import openfl.Lib;

/**
 * ...
 * @author djoekr
 */
class CrossStateTransition implements Transition
{
	/** The second state to cross with */
	private var secondState:BasicGameState;
	private var start:Int;
	private var isend:Int;

	
	public function new(delayTime:Int,secondState:BasicGameState) 
	{
		 this.secondState = secondState;
		 start = Lib.getTimer();
		 isend = delayTime;
		
		 secondState.updateState();
	}
	
	/* INTERFACE org.slick.state.transition.Transition */
	
	public function update( delta:Float):Void 
	{
		 secondState.updateState();
	}
	
	public function  RenderBatch( container:SpriteBatch):Void
	{
		secondState.render();
		
	}

	public function  RenderLines( container:BatchPrimitives):Void
	{
		
	}
	

	
	public function isComplete():Bool 
	{
	return ( Lib.getTimer() - start) > isend;
	}
	
	public function init(firstState:GameState, secondState:GameState):Void 
	{
		
	}
	public function end():Void 
	{
		
	}
	
}