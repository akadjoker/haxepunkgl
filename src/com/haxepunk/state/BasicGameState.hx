package com.haxepunk.state;
import com.haxepunk.Scene;

/**
 * ...
 * @author djoekr
 */
class BasicGameState extends Scene implements GameState
{


	
	
	
	public function getID():Int 
	{
		return - 1;
	}
	
	public function reset()
	{
		x = 0;
		y = 0;
		skewX = 0;
		skewY = 0;
		scaleX = 1;
		scaleY = 1;
		pivotX = 0;
		pivotY = 0;
		rotation = 0;
		HXP.camera.x = 0;
		HXP.camera.y = 0;
		
	}

	public function init():Void 
	{
	}
	
	public function enter():Void 
	{
		begin();
}
	
	public function leave():Void 
	{
     
      end();
	}
	
}