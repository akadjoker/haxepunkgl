package com.haxepunk.actions;

/**
 * ...
 * @author djoekr
 */
class MoveByAction extends RelativeAction
{

		private var amountX:Float;
		private var amountY:Float;
		
		
	override private function updateRelative ( percentDelta:Float)
	{		
		if (actor != null) actor.translate(amountX * percentDelta, amountY * percentDelta);
	}
	public function setAmount ( x:Float,  y:Float) 
	{
		amountX = x;
		amountY = y;
	}
	
}