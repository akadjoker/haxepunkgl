package com.haxepunk.actions;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.TweenEvent;
using com.haxepunk.Tween;

/**
 * ...
 * @author djoekr
 */
class MoveToAction extends BaseAction
{
	private var startX:Float=0;
	private var startY:Float=0;
	private var endX:Float=0;
	private var endY:Float = 0;
	
	
	
	public function new(endx:Float,endy:Float,duration:Float,?loop:Bool=false,?ease:EaseFunction) 
	{
		var type:TweenType;
		if (loop) type = TweenType.Looping; else type = TweenType.OneShot;
		
		super(duration, type, ease);
		
		this.endX = endx;
		this.endY = endy;		
	}
	
    override public function  start () 
	{
		
		startX = actor.x;
		startY = actor.y;
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