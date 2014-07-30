package com.haxepunk.graphics;

import com.haxepunk.gl.Game;
import com.haxepunk.Graphic;
import com.haxepunk.gl.Clip;
import com.haxepunk.HXP;
import com.haxepunk.gl.Texture;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Ease;
import com.haxepunk.gl.Texture;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.geom.Matrix;

/**
 * Particle emitter used for emitting and rendering particle sprites.
 * Good rendering performance with large amounts of particles.
 */
class Emitter extends Graphic
{
	/**
	 * Constructor. Sets the source image to use for newly added particle types.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 */
	public function new(source:Texture)
	{
		super();
		_p = new Point();
		_tint = new ColorTransform();
		_types = new Map<String,ParticleType>();

		tex = source;
		clip = new Clip(0, 0, tex.width, tex.height);
			
		_flipx = false;
		_flipy = false;
		
		_width = Std.int(source.width);
		_height = Std.int(source.height);
	
		active = true;
		particleCount = 0;
	}

	

	override public function update()
	{
		// quit if there are no particles
		if (_particle == null) return;

		// particle info
		var e:Float = HXP.fixed ? 1 / HXP.assignedFrameRate : HXP.elapsed,
			p:Particle = _particle,
			n:Particle;

		// loop through the particles
		while (p != null)
		{
			p._time += e; // Update particle time elapsed
			if (p._time >= p._duration  ) // remove on time-out
			{
				if (p._next != null) p._next._prev = p._prev;
				if (p._prev != null) p._prev._next = p._next;
				else _particle = p._next;
				n = p._next;
				p._next = _cache;
				p._prev = null;
				_cache = p;
				p = n;
				particleCount --;
					continue;
			}

			// get next particle
			p = p._next;
		}
	}

	/**
	 * Clears all particles.
	 */
	public function clear() 
	{
		// quit if there are no particles
		if (_particle == null) 
		{
			return;
		}
		
		// particle info
		var p:Particle = _particle, 
			n:Particle;

		// loop through the particles
		while (p != null)
		{
			// move this particle to the cache
			n = p._next;
			p._next = _cache;
			p._prev = null;
			_cache = p;
			p = n;
			particleCount--;
		}

		_particle = null;
	}

	private inline function renderParticles(fsx:Float,fsy:Float,  camera:Point)
	{
		
		if (particleCount < 0) return;
		
		// quit if there are no particles
		if (_particle == null)
		{
			return;
		}
		else
		{
			// get rendering position
				_point.x = -  camera.x * scrollX;
	            _point.y = -  camera.y * scrollY;

			// particle info
			var t:Float, td:Float,
				p:Particle = _particle,
				type:ParticleType;
				
			

			// loop through the particles
			while (p != null)
			{
				// get time scale
				t = p._time / p._duration;
				
				type = p._type;

				// get position
				td = (type._ease == null) ? t : type._ease(t);
				_p.x = _point.x + p._x + p._moveX * (type._backwards ? 1 - td : td);
				_p.y = _point.y + p._y + p._moveY * (type._backwards ? 1 - td : td);
				p._moveY += p._gravity * td;
				p._alpha = type._alpha + type._alphaRange * ((type._alphaEase == null) ? t : type._alphaEase(t));

				Game.spriteBatch.RenderScaleRotateClipFlipColorAlpha(tex,Math.floor(_p.x * fsx), Math.floor(_p.y * fsy), 
				fsx, fsy, type._angle + 90,
				clip,
				_flipx,_flipy,
				type._red + type._redRange * td,
				type._green + type._greenRange * td,
				type._blue + type._blueRange * td,
				p._alpha,blendMode);
				
			
	

				// get next particle
				p = p._next;
			}
		}
	}


	override public function render(m:Matrix,point:Point, camera:Point)
	{
		var fsx:Float = HXP.screen.fullScaleX,
			fsy:Float = HXP.screen.fullScaleY;
	    	
		//	
			renderParticles(fsx, fsy, camera);
	
		
	}

	/**
	 * Creates a new Particle type for this Emitter.
	 * @param	name		Name of the particle type.
	 * @param	frames		Array of frame indices for the particles to animate.
	 * @return	A new ParticleType object.
	 */
	public function newType(name:String, frames:Array<Int> = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);

		if (pt != null)
			throw "Cannot add multiple particle types of the same name";

		pt = new ParticleType(name,  _width);
		_types.set(name, pt);

		return pt;
	}

	/**
	 * Defines the motion range for a particle type.
	 * @param	name			The particle type.
	 * @param	angle			Launch Direction.
	 * @param	distance		Distance to travel.
	 * @param	duration		Particle duration.
	 * @param	angleRange		Random amount to add to the particle's direction.
	 * @param	distanceRange	Random amount to add to the particle's distance.
	 * @param	durationRange	Random amount to add to the particle's duration.
	 * @param	ease			Optional ease function.
	 * @param	backwards		If the motion should be played backwards.
	 * @return	This ParticleType object.
	 */
	public function setMotion(name:String, angle:Float, distance:Float, duration:Float, ?angleRange:Float = 0, ?distanceRange:Float = 0, ?durationRange:Float = 0, ?ease:EaseFunction = null, ?backwards:Bool = false):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setMotion(angle, distance, duration, angleRange, distanceRange, durationRange, ease, backwards);
	}

	/**
	 * Sets the gravity range for a particle type.
	 * @param	name      		The particle type.
	 * @param	gravity      	Gravity amount to affect to the particle y velocity.
	 * @param	gravityRange	Random amount to add to the particle's gravity.
	 * @return	This ParticleType object.
	 */
	public function setGravity(name:String, ?gravity:Float = 0, ?gravityRange:Float = 0):ParticleType
	{
		return cast(_types.get(name) , ParticleType).setGravity(gravity, gravityRange);
	}

	/**
	 * Sets the alpha range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting alpha.
	 * @param	finish		The finish alpha.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setAlpha(name:String, ?start:Float = 1, ?finish:Float = 0, ?ease:EaseFunction = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setAlpha(start, finish, ease);
	}

	/**
	 * Sets the color range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting color.
	 * @param	finish		The finish color.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setColor(name:String, ?start:Int = 0xFFFFFF, ?finish:Int = 0, ?ease:EaseFunction = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setColor(start, finish, ease);
	}

	/**
	 * Emits a particle.
	 * @param	name		Particle type to emit.
	 * @param	x			X point to emit from.
	 * @param	y			Y point to emit from.
	 * @return	The Particle emited.
	 */
	public function emit(name:String, ?x:Float = 0, ?y:Float = 0):Particle
	{
		var p:Particle, type:ParticleType = _types.get(name);

		if (type == null)
			throw "Particle type \"" + name + "\" does not exist.";

		if (_cache != null)
		{
			p = _cache;
			_cache = p._next;
		}
		else
		{
			p = new Particle();
		}
		p._next = _particle;
		p._prev = null;
		if (p._next != null) p._next._prev = p;

		p._type = type;
		p._time = 0;
		p._duration = type._duration + type._durationRange * HXP.random;
		var a:Float = type._angle + type._angleRange * HXP.random,
			d:Float = type._distance + type._distanceRange * HXP.random;
		p._moveX = Math.cos(a) * d;
		p._moveY = Math.sin(a) * d;
		p._x = x;
		p._y = y;
		p._gravity = type._gravity + type._gravityRange * HXP.random;
		particleCount ++;
		return (_particle = p);
	}

	/**
	 * Randomly emits the particle inside the specified radius
	 * @param	name		Particle type to emit.
	 * @param	x			X point to emit from.
	 * @param	y			Y point to emit from.
	 * @param	radius		Radius to emit inside.
	 *
	 * @return The Particle emited.
	 */
	public function emitInCircle(name:String, x:Float, y:Float, radius:Float):Particle
	{
		var angle = Math.random() * Math.PI * 2;
		radius *= Math.random();
		return emit(name, x + Math.cos(angle) * radius, y + Math.sin(angle) * radius);
	}

	/**
	 * Randomly emits the particle inside the specified area
	 * @param	name		Particle type to emit
	 * @param	x			X point to emit from.
	 * @param	y			Y point to emit from.
	 * @param	width		Width of the area to emit from.
	 * @param	height		height of the area to emit from.
	 *
	 * @return The Particle emited.
	 */
	public function emitInRectangle(name:String, x:Float, y:Float, width:Float ,height:Float):Particle
	{
		return emit(name, x + HXP.random * width, y + HXP.random * height);
	}
	




	/**
	 * Amount of currently existing particles.
	 */
	public var particleCount(default, null):Int;

	// Particle information.
	private var _types:Map<String,ParticleType>;
	private var _particle:Particle;
	private var _cache:Particle;



		
	private var _width:Int;
	private var _height:Int;

    private var tex:Texture;

	// Drawing information.
	private var _p:Point;
	private var _tint:ColorTransform;
	private static var SIN(get,never):Float;
	private static inline function get_SIN():Float { return Math.PI / 2; }
}
