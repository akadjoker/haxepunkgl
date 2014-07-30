package com.haxepunk.actions;
import com.haxepunk.utils.Ease.EaseFunction;

/**
 * ...
 * @author djoekr
 */
class SkewAction extends TransformAction
{

	override private function update ( percent:Float)
	{
		super.update(percent);
		if (actor != null) actor.setSkew(getValue());
		
	}

	

	
}