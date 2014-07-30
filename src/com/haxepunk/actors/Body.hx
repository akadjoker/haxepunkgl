package com.haxepunk.actors;


import flash.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.group.Group;
/**
 * ...
 * @author djoker
 */
class Body extends Entity
{
	public static var SEPARATE_BIAS:Float = 4;
	public static inline var LEFT:Int	= 0x0001;
	public static inline var RIGHT:Int	= 0x0010;
	public static inline var UP:Int		= 0x0100;
	public static inline var DOWN:Int	= 0x1000;
	public static inline var NONE:Int	= 0;
	public static inline var CEILING:Int= UP;
	public static inline var FLOOR:Int	= DOWN;
	public static inline var WALL:Int	= LEFT | RIGHT;
	public static inline var ANY:Int	= LEFT | RIGHT | UP | DOWN;
	public var collisonXDrag:Bool = true;
	
	public var immovable:Bool;
	public var position:Point; 
	public var lastPosition:Point; 
	public var velocity:Point; 
	public var angle:Float;
	public var acceleration:Point;
	public var drag:Point;
	public var maxVelocity:Point;
	public var mass:Float;
	public var moves:Bool;
	public var elasticity:Float ;
	public var angularVelocity:Float ;
	public var angularAcceleration:Float ;
	public var angularDrag:Float ;
	public var maxAngular:Float;
	public var touchingType:Body;
	public var touching:Int ;
	public var wasTouching:Int ;
	public var allowCollisions:Int ;
	public var group:Group;
	
		
	public function new(x:Float = 0, y:Float = 0,t:String) 
	{
		super(x, y);
		elasticity = 0;
		angularAcceleration = 0;
		angularVelocity = 0;
		angularDrag = 0;
		maxAngular = 1000;
		mass = 1;
		angle = 0;
		touching = NONE;
		wasTouching = NONE;
		allowCollisions = ANY;
		type = t;

		
		
		position = new Point(0, 0);
		velocity = new Point(0, 0);
		lastPosition= new Point(0, 0);
		immovable = false;
		moves = true;
	    acceleration = new Point(0,0);
	    drag= new Point(0,0);
	    maxVelocity = new Point(1000, 1000);
	}
	
    public function touch(other:Body)
	{
		
	}
    public function hit(other:Body)
	{
		
	}	
	private inline function updateMotion(dt:Float):Void
	{
		var delta:Float;
		var velocityDelta:Float;
		

		
		velocityDelta = 0.5 * (HXP.computeVelocity(angularVelocity, angularAcceleration, angularDrag, maxAngular,dt) - angularVelocity);
		angularVelocity += velocityDelta; 
		angle += angularVelocity * dt;
		angularVelocity += velocityDelta;
		
		velocityDelta = 0.5 * (HXP.computeVelocity(velocity.x, acceleration.x, drag.x, maxVelocity.x,dt) - velocity.x);
		velocity.x += velocityDelta;
		delta = velocity.x * dt;
		velocity.x += velocityDelta;
		x += delta;
		
		velocityDelta = 0.5 * (HXP.computeVelocity(velocity.y, acceleration.y, drag.y, maxVelocity.y,dt) - velocity.y);
		velocity.y += velocityDelta;
		delta = velocity.y * dt;
		velocity.y += velocityDelta;
		y += delta;
	}
	
	
	override public function update():Void 
	{
		lastPosition.x = x;
		lastPosition.y = y;
		if (moves)
		{
			updateMotion(HXP.elapsed);
		}
		wasTouching = touching;
		touchingType = null;
		touching = NONE;
	}
	public  function isTouching(Direction:Int):Bool
	{
		return (touching & Direction) > NONE;
	}

	public function destroy():Void
		{
			
		}

}