package com.haxepunk.actions;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.TweenEvent;
/**
 * ...
 * @author djoekr
 */
class AlphaAction extends TransformAction
{

	override private function update ( percent:Float)
	{
		super.update(percent);
		if (actor != null) actor.setAlpha(getValue());
	}

	
	
}