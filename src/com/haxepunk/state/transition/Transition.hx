package com.haxepunk.state.transition;

import com.haxepunk.gl.BatchPrimitives;
import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.state.GameState;

/**
 * ...
 * @author djoker
 */

/**
 * A transition between two game states
 *
 * @author kevin
 */
 interface Transition {
	/** 
	 * Update the transition. Cause what ever happens in the transition to happen
	 * 
	 * @param game The game this transition is being rendered as part of
	 * @param container The container holding the game
	 * @param delta The amount of time passed since last update
	 * @throws SlickException Indicates a failure occured during the update 
	 */
	
	function  update(delta:Float):Void;
		

	
	
	/**
	 * Render the transition over the existing state rendering
	 * 
	 * @param game The game this transition is being rendered as part of
	 * @param container The container holding the game
	 * @param g The graphics context to use when rendering the transiton
	 * @throws SlickException Indicates a failure occured during the render 
	 */
	
	function  RenderBatch( container:SpriteBatch):Void;
	 
	function  RenderLines( container:BatchPrimitives):Void;
	
	
	/**
	 * Check if this transtion has been completed
	 * 
	 * @return True if the transition has been completed
	 */
	function isComplete():Bool;
	
	/**
	 * Initialise the transition
	 * 
	 * @param firstState The first state we're rendering (this will be rendered by the framework)
	 * @param secondState The second stat we're transitioning to or from (this one won't be rendered)
	 */
	function  init(firstState:BasicGameState, secondState:BasicGameState):Void;
	
	function  end():Void;
	
}