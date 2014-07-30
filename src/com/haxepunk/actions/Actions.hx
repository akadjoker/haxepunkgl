package com.haxepunk.actions;
import com.haxepunk.Entity;

/**
 * ...
 * @author djoekr
 */
class Actions
{

	public static function moveTo(actor:Entity, x:Float, y:Float, duration:Float):MoveToAction
	{
	        var action:MoveToAction = new MoveToAction(duration);
			action.setPosition(x,y);
			actor.addAction(action);
			return action;
	}
	public static function moveBy(actor:Entity, x:Float, y:Float, duration:Float):MoveByAction
	{
	        var action:MoveByAction = new MoveByAction(duration);
			action.setAmount(x,y);
			actor.addAction(action);
			return action;
	}			
	
}