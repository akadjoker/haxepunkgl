package  com.haxepunk.group;

import com.haxepunk.actors.Body;
import com.haxepunk.Scene;


import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

/**
 * ...
 * @author djoker
 */
class Group
{
	private var scene:Scene;
    private var bodys:Array<Body>;

	public function new(scene:Scene) 
	{
	 this.scene = scene;	
	 bodys = new Array<Body>();
	}
	public function remove(b:Body):Void
	{
		b.group = null;
		bodys.remove(b);
		scene.remove(b);
		b.destroy();
		b = null;
		
	}
	public function add(b:Body):Body
	{
		b.group = this;
		bodys.push(b);
		scene.add(b);
		return b;
	}
	public function colision()
	{
		for (i in 0...bodys.length)
		{
		 for (j in (i+1)...bodys.length)
		 {
	
				 
			
			  var a:Body = bodys[i];
			  var b:Body = bodys[j];
	
			 if (!a.collidable || !a.active) continue;
			 if (!b.collidable || !a.active) continue;
			
			 if (a != b)
			 {

				 if (separate(a, b))
				 {
					 a.touch(b);
					 b.touch(a);
				 }
			 }
		 }
      }
	}
	
	public  function separate(Object1:Body, Object2:Body):Bool
	{
		var separatedX:Bool = separateX(Object1, Object2);
		var separatedY:Bool = separateY(Object1, Object2);
		return separatedX || separatedY;
	}
	public  function separateObject(Object1:Body, Object2:Body):Bool
	{
		var separatedX:Bool = separateX(Object1, Object2);
		var separatedY:Bool = separateY(Object1, Object2);
		return separatedX || separatedY;
	}
	
	
	 public  function separateX(Object1:Body, Object2:Body):Bool
	{
		//can't separate two immovable objects
		var obj1immovable:Bool = Object1.immovable;
		var obj2immovable:Bool = Object2.immovable;
		if (obj1immovable && obj2immovable)
		{
			return false;
		}
		

		
		//First, get the two object deltas
		var overlap:Float = 0;
		var obj1delta:Float = Object1.x - Object1.lastPosition.x;
		var obj2delta:Float = Object2.x - Object2.lastPosition.x;
		

		if (obj1delta != obj2delta)
		{
			//Check if the X hulls actually overlap
			var obj1deltaAbs:Float = (obj1delta > 0)?obj1delta: -obj1delta;
			var obj2deltaAbs:Float = (obj2delta > 0)?obj2delta: -obj2delta;
			
			 HXP.r1.setTo(Object1.x - ((obj1delta > 0)?obj1delta:0), Object1.lastPosition.y, Object1.width + ((obj1delta > 0)?obj1delta: -obj1delta), Object1.height);
			 HXP.r2.setTo(Object2.x - ((obj2delta > 0)?obj2delta:0), Object2.lastPosition.y, Object2.width + ((obj2delta > 0)?obj2delta: -obj2delta), Object2.height);
			
	
		    var obj1rect:Rectangle =  HXP.r1;
			var obj2rect:Rectangle =  HXP.r2;
			
			if ((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
				{
				var maxOverlap:Float = obj1deltaAbs + obj2deltaAbs + Body.SEPARATE_BIAS;
				
				//If they did overlap (and can), figure out by how much and flip the corresponding flags
				if (obj1delta > obj2delta)
				{
					overlap = Object1.x + Object1.width - Object2.x;
					if ((overlap > maxOverlap) || ((Object1.allowCollisions & Body.RIGHT) == 0) || ((Object2.allowCollisions & Body.LEFT) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object1.touchingType = Object2;
						Object2.touchingType = Object1;
						Object1.touching |= Body.RIGHT;
						Object2.touching |= Body.LEFT;
					}
				}
				else if (obj1delta < obj2delta)
				{
					overlap = Object1.x - Object2.width - Object2.x;
					if ((-overlap > maxOverlap) || ((Object1.allowCollisions & Body.LEFT) == 0) || ((Object2.allowCollisions & Body.RIGHT) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object2.touchingType = Object1;
						Object1.touchingType = Object2;
		
						Object1.touching |= Body.LEFT;
						Object2.touching |= Body.RIGHT;
					}
				}
			}
		}
		
		//Then adjust their positions and velocities accordingly (if there was any overlap)
		if (overlap != 0)
		{
			var obj1v:Float = Object1.velocity.x;
			var obj2v:Float = Object2.velocity.x;
			
			if (!obj1immovable && !obj2immovable)
			{
				overlap *= 0.5;
				Object1.x = Object1.x - overlap;
				Object2.x += overlap;
				
				var obj1velocity:Float = Math.sqrt((obj2v * obj2v * Object2.mass) / Object1.mass) * ((obj2v > 0)?1: -1);
				var obj2velocity:Float = Math.sqrt((obj1v * obj1v * Object1.mass) / Object2.mass) * ((obj1v > 0)?1: -1);
				var average:Float = (obj1velocity + obj2velocity) * 0.5;
				obj1velocity -= average;
				obj2velocity -= average;
				Object1.velocity.x = average + obj1velocity * Object1.elasticity;
				Object2.velocity.x = average + obj2velocity * Object2.elasticity;
			}
			else if (!obj1immovable)
			{
				Object1.x = Object1.x - overlap;
				Object1.velocity.x = obj2v - obj1v * Object1.elasticity;
			}
			else if (!obj2immovable)
			{
				Object2.x += overlap;
				Object2.velocity.x = obj1v - obj2v * Object2.elasticity;
			}
			return true;
		}
		else
		{
			return false;
		}
	}
	

	public  function separateY(Object1:Body, Object2:Body):Bool
	{
		//can't separate two immovable objects
		var obj1immovable:Bool = Object1.immovable;
		var obj2immovable:Bool = Object2.immovable;
		if (obj1immovable && obj2immovable)
		{
			return false;
		}
		


		//First, get the two object deltas
		var overlap:Float = 0;
		var obj1delta:Float = Object1.y - Object1.lastPosition.y;
		var obj2delta:Float = Object2.y - Object2.lastPosition.y;
		
		if (obj1delta != obj2delta)
		{
			//Check if the Y hulls actually overlap
			var obj1deltaAbs:Float = (obj1delta > 0)?obj1delta: -obj1delta;
			var obj2deltaAbs:Float = (obj2delta > 0)?obj2delta: -obj2delta;
			
			HXP.r1.setTo(Object1.x, Object1.y - ((obj1delta > 0)?obj1delta:0), Object1.width, Object1.height + obj1deltaAbs);
			HXP.r2.setTo(Object2.x, Object2.y - ((obj2delta > 0)?obj2delta:0), Object2.width, Object2.height + obj2deltaAbs);
		    //var obj1rect:Rectangle = Object1.bound;// Util.r1;
		//	var obj2rect:Rectangle = Object2.bound;//  Util.r2;
		    var obj1rect:Rectangle =  HXP.r1;
			var obj2rect:Rectangle =  HXP.r2;
			
			//if (obj1rect.intersects(obj2rect))
			if ((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
			{
				var maxOverlap:Float = obj1deltaAbs + obj2deltaAbs +Body.SEPARATE_BIAS;
				
				//If they did overlap (and can), figure out by how much and flip the corresponding flags
				if (obj1delta > obj2delta)
				{
					overlap = Object1.y + Object1.height - Object2.y;
					if ((overlap > maxOverlap) || ((Object1.allowCollisions & Body.DOWN) == 0) || ((Object2.allowCollisions & Body.UP) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object1.touching |= Body.DOWN;
						Object2.touching |= Body.UP;
						Object1.touchingType = Object2;
						Object2.touchingType = Object1;
		
					}
				}
				else if (obj1delta < obj2delta)
				{
					overlap = Object1.y - Object2.height - Object2.y;
					if ((-overlap > maxOverlap) || ((Object1.allowCollisions & Body.UP) == 0) || ((Object2.allowCollisions & Body.DOWN) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object1.touching |= Body.UP;
						Object2.touching |= Body.DOWN;
						Object2.touchingType = Object1;
						Object1.touchingType = Object2;
		
					}
				}
			}
		}
		
		// Then adjust their positions and velocities accordingly (if there was any overlap)
		if (overlap != 0)
		{
			var obj1v:Float = Object1.velocity.y;
			var obj2v:Float = Object2.velocity.y;
			
			if (!obj1immovable && !obj2immovable)
			{
				overlap *= 0.5;
				Object1.y = Object1.y - overlap;
				Object2.y += overlap;
				
				var obj1velocity:Float = Math.sqrt((obj2v * obj2v * Object2.mass)/Object1.mass) * ((obj2v > 0)?1:-1);
				var obj2velocity:Float = Math.sqrt((obj1v * obj1v * Object1.mass)/Object2.mass) * ((obj1v > 0)?1:-1);
				var average:Float = (obj1velocity + obj2velocity) * 0.5;
				obj1velocity -= average;
				obj2velocity -= average;
				Object1.velocity.y = average + obj1velocity * Object1.elasticity;
				Object2.velocity.y = average + obj2velocity * Object2.elasticity;
			}
			else if (!obj1immovable)
			{
				Object1.y = Object1.y - overlap;
				Object1.velocity.y = obj2v - obj1v*Object1.elasticity;
				// This is special case code that handles cases like horizontal moving platforms you can ride
				if (Object1.collisonXDrag && Object2.active && Object2.moves && (obj1delta > obj2delta))
				{
					Object1.x += Object2.x - Object2.lastPosition.x;
				}
			}
			else if (!obj2immovable)
			{
				Object2.y += overlap;
				Object2.velocity.y = obj1v - obj2v*Object2.elasticity;
				// This is special case code that handles cases like horizontal moving platforms you can ride
				if (Object2.collisonXDrag && Object1.active && Object1.moves && (obj1delta < obj2delta))
				{
					Object2.x += Object1.x - Object1.lastPosition.x;
				}
			}
			return true;
		}
		else
		{
			return false;
		}
	}
	
}