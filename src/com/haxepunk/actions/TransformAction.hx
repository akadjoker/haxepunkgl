package com.haxepunk.actions;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.TweenEvent;
/**
 * ...
 * @author djoekr
 */
class TransformAction extends BaseAction
{
	private var _start:Float;
	private var _end:Float ;
	private var _value:Float;
	private var _swap:Bool ;
	
	

	public function new(start:Float,end:Float,swap:Bool,duration:Float,?loop:Bool=false,?ease:EaseFunction) 
	{
		var type:TweenType;
		if (loop) type = TweenType.Looping; else type = TweenType.OneShot;
		
		
		super(duration, type, ease);
		_start = start;
		_end = end;
		_swap = swap;
		_value = 0;
	}

	override public function start () 
	{
		
		if (_swap)
		{
	 	var tmp = _start;
		_start = _end;
	     _end = tmp;
		}
		super.start();
	}
	
	public function getValue () :Float
	{
		return _value;
	}
			

	override private function update ( percent:Float)
	{
		_value = _start + (_end - _start) * percent;
	}
/*
	override public function reset () 
	{
		super.reset();
		_value = 0;
	}
*/


	
}