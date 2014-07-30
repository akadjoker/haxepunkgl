package com.haxepunk.graphics;

import com.haxepunk.gl.Clip;
import com.haxepunk.HXP;
import flash.display.BitmapData;
import flash.display.SpreadMethod;
import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.gl.Texture;
typedef CallbackFunction = Void -> Void;

/**
 * Performance-optimized animated Image. Can have multiple animations,
 * which draw frames from the provided source image to the screen.
 */
class Spritemap extends Image
{
	/**
	 * If the animation has stopped.
	 */
	public var complete:Bool;

	/**
	 * Optional callback function for animation end.
	 */
	public var callbackFunc:CallbackFunction;

	/**
	 * Animation speed factor, alter this to speed up/slow down all animations.
	 */
	public var rate:Float;

	/**
	 * Constructor.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 * @param	cbFunc			Optional callback function for animation end.
	 * @param	name			Optional name, necessary to identify the bitmapData if you are using flipped.
	 */
	public function new(source:Texture, cbFunc:CallbackFunction = null)
	{
		complete = true;
		rate = 1;
		_anims = new Map<String,Animation>();
		_timer = _frame = 0;

		

		super(source);

		_clips = new Array<Clip>();
		
	
		
		_frameCount = 0;
	 	callbackFunc = cbFunc;

		updateBuffer();
		active = true;
	}

	public function addClip(clip:Clip)
	{
	 _clips.push(clip);
	 _frameCount = _clips.length - 1;
	}
	public function addClips(clips:Array<Clip>)
	{
		for (i in 0 ... clips.length )
		{
	     _clips.push(clips[i]);
		}
		
	 _frameCount = _clips.length - 1;
	}
	
	public function spliteTexture(tileWidth:Int, tileHeight:Int,spacing:Int=0,margin:Int=0)
	{
			
		var columns:Int =Std.int(tex.width  / tileWidth );
		var rows:Int    =Std.int(tex.height / tileHeight ); 
	
	
	for ( y in 0...rows)
	{
		for (x in 0...columns)
		{
		
			var clip:Clip = new Clip();
			clip.y = y * (tileHeight + spacing);
			clip.y += margin;
			
			clip.x = x * (tileWidth + spacing);
			clip.x += margin;
			
			clip.width = tileWidth;
			clip.height = tileHeight;
			
		   _clips.push(clip);

		}
	
		}
		
		_frameCount =  columns * rows;
		
	}
	
	/**
	 * Updates the spritemap's buffer.
	 */
	 public function updateBuffer()
	{
	
		if(frame<=_clips.length)		this.clip = _clips[frame];
	
	}

	/** @private Updates the animation. */
	override public function update()
	{
		if (_anim != null && !complete)
		{
			_timer += (HXP.fixed ? _anim.frameRate / HXP.assignedFrameRate : _anim.frameRate * HXP.elapsed) * rate;
			if (_timer >= 1)
			{
				while (_timer >= 1)
				{
					_timer --;
					_index ++;
					if (_index == _anim.frameCount)
					{
						if (_anim.loop)
						{
							_index = 0;
							if (callbackFunc != null) callbackFunc();
						}
						else
						{
							_index = _anim.frameCount - 1;
							complete = true;
							if (callbackFunc != null) callbackFunc();
							break;
						}
					}
				}
				if (_anim != null) _frame = _anim.frames[_index];
				
		
				updateBuffer();
			}
		}
	}

	/**
	 * Add an Animation.
	 * @param	name		Name of the animation.
	 * @param	frames		Array of frame indices to animate through.
	 * @param	frameRate	Animation speed (in frames per second, 0 defaults to assigned frame rate)
	 * @param	loop		If the animation should loop
	 * @return	A new Anim object for the animation.
	 */
	public function add(name:String, frames:Array<Int>, frameRate:Float = 0, loop:Bool = true):Animation
	{
		if (_anims.get(name) != null)
			throw "Cannot have multiple animations with the same name";

		if(frameRate == 0)
			frameRate = HXP.assignedFrameRate;
			_frameCount = frames.length;
		var anim = new Animation(name, frames, frameRate, loop);
		_anims.set(name, anim);
		anim.parent = this;
		return anim;
	}

	/**
	 * Plays an animation.
	 * @param	name		Name of the animation to play.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 * @return	Anim object representing the played animation.
	 */
	public function play(name:String = "", reset:Bool = false):Animation
	{
		if (!reset && _anim != null && _anim.name == name) return _anim;
		if (_anims.exists(name))
		{
			_anim = _anims.get(name);
			_timer = _index = 0;
			_frame = _anim.frames[0];
			complete = false;
		}
		else
		{
			_anim = null;
			_frame = _index = 0;
			complete = true;
		}
		updateBuffer();
		return _anim;
	}

	
	

	/**
	 * Assigns the Spritemap to a random frame.
	 */
	public function randFrame()
	{
		frame = HXP.rand(_frameCount);
	}

	/**
	 * Sets the frame to the frame index of an animation.
	 * @param	name	Animation to draw the frame frame.
	 * @param	index	Index of the frame of the animation to set to.
	 */
	public function setAnimFrame(name:String, index:Int)
	{
		var frames:Array<Int> = _anims.get(name).frames;
		index = index % frames.length;
		if (index < 0) index += frames.length;
		frame = frames[index];
	}

	/**
	 * Sets the current frame index. When you set this, any
	 * animations playing will be stopped to force the frame.
	 */
	public var frame(get, set):Int;
	private function get_frame():Int { return _frame; }
	private function set_frame(value:Int):Int
	{
		_anim = null;
		value %= _frameCount;
		if (value < 0) value = _frameCount + value;
		if (_frame == value) return _frame;
		_frame = value;
		updateBuffer();
		return _frame;
	}

	/**
	 * Current index of the playing animation.
	 */
	public var index(get, set):Int;
	private function get_index():Int { return _anim != null ? _index : 0; }
	private function set_index(value:Int):Int
	{
		if (_anim == null) return 0;
		value %= _anim.frameCount;
		if (_index == value) return _index;
		_index = value;
		_frame = _anim.frames[_index];
		updateBuffer();
		return _index;
	}

	/**
	 * The amount of frames in the Spritemap.
	 */
	public var frameCount(get, null):Int;
	private function get_frameCount():Int { return _frameCount; }

	

	/**
	 * The currently playing animation.
	 */
	public var currentAnim(get, null):String;
	private function get_currentAnim():String { return (_anim != null) ? _anim.name : ""; }

	// Spritemap information.


	private var _frameCount:Int;
	private var _anims:Map<String,Animation>;
	private var _clips:Array<Clip>;
	private var _anim:Animation;
	private var _index:Int;
	private var _frame:Int;
	private var _timer:Float;

}
