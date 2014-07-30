package com.haxepunk.actions;
import com.haxepunk.utils.Ease.EaseFunction;

/**
 * ...
 * @author djoekr
 */
class SkewYAction extends TransformAction
{

	override private function update ( percent:Float)
	{
		super.update(percent);
		if (actor != null) actor.skewY=getValue();
		
	}

	

	
}