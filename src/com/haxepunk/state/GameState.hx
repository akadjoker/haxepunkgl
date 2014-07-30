package com.haxepunk.state;



/**
 * ...
 * @author djoker
 */


/**
 * A single state building up part of the game. The state include rendering, logic and input handling
 * for the state.
 *
 * @author kevin
 */
 interface GameState  {
	/**
	 * Get the ID of this state
	 * 
	 * @return The game unique ID of this state
	 */
	function  getID():Int;
	

		
	
	 function init():Void ;

	
	
	/**
	 * Notification that we've entered this game state
	 * 
	 * @param container The container holding the game
	 * @param game The game holding this state
	 * @throws SlickException Indicates an internal error that will be reported through the
	 * standard framework mechanism
	 */
	function  enter():Void;
	

	/**
	 * Notification that we're leaving this game state
	 * 
	 * @param container The container holding the game
	 * @param game The game holding this state
	 * @throws SlickException Indicates an internal error that will be reported through the
	 * standard framework mechanism
	 */
	
	function  leave():Void;
	
	
}