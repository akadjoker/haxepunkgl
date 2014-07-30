package com.haxepunk.actions;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.TweenEvent;
using com.haxepunk.Tween;

/**
 * ...
 * @author djoekr
 */
class StartMoveToAction extends BaseAction
{
	private var startX:Float=0;
	private var startY:Float=0;
	private var endX:Float=0;
	private var endY:Float = 0;
	private var firstStar:Bool;
	private var swapvalue:Bool;
	
	
	
	public function new(endx:Float,endy:Float,duration:Float,?swap:Bool,?loop:Bool=false,?ease:EaseFunction) 
	{
		var type:TweenType;
		if (loop) type = TweenType.Looping; else type = TweenType.OneShot;
		
		super(duration, type, ease);
		
		this.endX = endx;
		this.endY = endy;	
		firstStar = true;
		swapvalue = swap;

	}
	
	 override public function  start () 
	{
		if (firstStar)
		{		
		startX = actor.x;
		startY = actor.y;
		firstStar = false;
		}
		
		if (swapvalue)
		{
			var tmpx = startX;
			startX = endX;
			endX = tmpx;
			
			var tmpy = startY;
			startY = endY;
			endY = tmpy;
			
		}
		
		super.start();
	}
	


	override private function update ( percent:Float)
	{		
	 if (actor != null) actor.setPosition(startX + (endX - startX) * percent, startY + (endY - startY) * percent);
	}
	public function setPosition ( x:Float,  y:Float) 
	{
		endX = x;
		endY = y;
	}
	
}