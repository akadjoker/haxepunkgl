package com.haxepunk.actions;

/**
 * ...
 * @author djoekr
 */
class RelativeAction extends BaseAction
{
	private var lastPercent:Float = 0;

     override	private function  begin () 
	{
		lastPercent = 0;
	}

	override private function update ( percent:Float)
	{
		updateRelative(percent - lastPercent);
		lastPercent = percent;
	}
	 private function updateRelative ( percentDelta:Float)
	{
	}	
	
	
}