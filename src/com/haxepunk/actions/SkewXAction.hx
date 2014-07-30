package com.haxepunk.actions;
import com.haxepunk.utils.Ease.EaseFunction;

/**
 * ...
 * @author djoekr
 */
class SkewXAction extends TransformAction
{

	override private function update ( percent:Float)
	{
		super.update(percent);
		if (actor != null) actor.skewX=getValue();
		
	}

	

	
}