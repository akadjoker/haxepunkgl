package com.haxepunk.actions;
import com.haxepunk.utils.Ease;
import com.haxepunk.tweens.TweenEvent;
using com.haxepunk.Tween;

/**
 * ...
 * @author djoekr
 */
class BaseAction extends Action
{
	public dynamic function onComplete(a:BaseAction) { }
	
		public var active:Bool;

	/**
	 * Constructor. Specify basic information about the Tween.
	 * @param	duration		Duration of the tween (in seconds or frames).
	 * @param	type			Tween type, one of Tween.PERSIST (default), Tween.LOOPING, or Tween.ONESHOT.
	 * @param	complete		Optional callback for when the Tween completes.
	 * @param	ease			Optional easer function to apply to the Tweened value.
	 */
	public function new(duration:Float, ?type:TweenType,  ?ease:EaseFunction)
	{
		_target = duration;
		if (type == null) type = TweenType.Persist;
		_type = type;
		_ease = ease;
		_t = 0;
	    super();

	}





	
	override public function  act () :Bool
	{  
		_time += HXP.fixed ? 1 : HXP.elapsed;
		_t = _time / _target;
		if (_ease != null && _t > 0 && _t < 1) _t = _ease(_t);
		if (_time >= _target)
		{
			_t = 1;
			_finish = true;
		}
		
		update(_t);
		return active;
	}

	
	
	 private function update ( percent:Float)
	{
	
	}

	/**
	 * Starts the Tween, or restarts it if it's currently running.
	 */
	override public function start()
	{
		_time = 0;
		if (_target == 0)
		{
			active = false;
		//	dispatchEvent(new TweenEvent(TweenEvent.FINISH));
		}
		else
		{
			active = true;
		//	dispatchEvent(new TweenEvent(TweenEvent.START));
		}
	}

	/** @private Called when the Tween completes. */
	public function finish()
	{
		switch(_type)
		{
			case Persist:
				_time = _target;
				 active = false;
			case Looping:
				_time %= _target;
				_t = _time / _target;
				if (_ease != null && _t > 0 && _t < 1) _t = _ease(_t);
				start();
			case OneShot:
				_time = _target;
				active = false;
			if (actor != null)
		     {
			  actor.removeAction(this);
			  this.actor = null;
		     }
		}
		_finish = false;
	//	dispatchEvent(new TweenEvent(TweenEvent.FINISH));
		
		//if (_type == TweenType.OneShot && _callback != null)
		//{
		//	removeEventListener(TweenEvent.FINISH, _callback);
		//}
	}

	/**
	 * Immediately stops the Tween and removes it from its Tweener without calling the complete callback.
	 */
	public function cancel()
	{
		active = false;
		if (actor != null)
		{
			actor.removeAction(this);
			this.actor = null;
		}
	}
	
	public var percent(get, set):Float;
	private function get_percent():Float { return _time / _target; }
	private function set_percent(value:Float):Float { _time = _target * value; return _time; }

	public var isFinish(get_isFinish, null):Bool;
	private function get_isFinish():Bool { return _finish; }

	
	public var scale(get, null):Float;
	private function get_scale():Float { return _t; }

	private var _type:TweenType;
	private var _ease:EaseFunction;
	private var _t:Float;

	private var _time:Float;
	private var _target:Float;

	//private var _callback:CompleteCallback;
	private var _finish:Bool;
	

}