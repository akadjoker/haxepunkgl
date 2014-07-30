package com.haxepunk.utils;


import com.haxepunk.Entity;
import com.haxepunk.gl.BatchPrimitives;
import flash.geom.Matrix3D;
import openfl.geom.Point;



class VirtualAnalogStick extends Entity {
	// Direction that the user is pressing:
	public var angle   : Float;
	public var strength: Float;
	private var alpha:Float=1;
	private var _grabbed:Bool;
	private var knob:Point = new Point();
	private var _vx:Float = 0;
		private var _vy:Float = 0;
		private var _spring:Float = 400;
		private var _friction:Float = 0.0005;
		
	// To check if the user is currently using the virtual analog stick at all:
	public var user_is_interacting: Bool;
		// Indicates that the user is interacting with the virtual analog stick, because he clicked/touched it.
		// The interaction is continued until the user releases the mouse button or stops touching. It
		// is continued even while the mouse/touch position is outside of the virtual analog stick.
	
	// Position and sizes:

	public var size         : Int;
	public var dead_distance: Int; // No reaction inside the dead_distance to the center
	public var full_distance: Int; // Full reaction (strength 1.0) at full_distance to the center
	public var move_distance: Int; // No reaction outside the move_distance to the center
	
	//
	// Constructor
	//
	// x, y     : Position on screen in pixels
	// size     : Size in pixels (used for both width and height)
	// dead_area: Within this area in the center no direction is pressed
	// move_area: Outside of this area no direction is pressed
	//
	public function new(x: Float, y: Float, size: Int, dead_distance: Int,  move_distance: Int) 
	{
	 super(x, y, null, "VirtualAnalogStick");
		this.size          = size;
		this.dead_distance = dead_distance;
         full_distance = 1;
		this.move_distance = move_distance;
		
		resetInteraction();
	}
	
	//
	// reset()
	//
	// If the interaction should be canceled, for example if your game or a level in your game restarts,
	// or if the stick loses focus, because a window has been opened, or in any similar case, call reset().
	//
	public function reset() {
		resetInteraction();
	}
	
	// Private
	private function resetInteraction() {
		angle    = 0.0;
		strength = 0.0;
		user_is_interacting = false;
	}
	
	// Private
	private function updateDirection(mouse_x: Int, mouse_y: Int) 
	{
		angle    = 0.0;
	 	strength = 0.0;
		if (user_is_interacting) {
			// Determine the direction in which the virtual analog stick is hold.
			// No direction inside the "dead-area" or outside the "move-area".
			if ((isMouseWithinMoveDistance(mouse_x, mouse_y)) && (!isMouseWithinDeadDistance(mouse_x, mouse_y))) 
			{
				var mid_x: Float = x + size / 2;
				var mid_y: Float = y + size / 2;
				var dx: Float = mouse_x - mid_x;
				var dy: Float = mouse_y - mid_y;
				knob.x = dx;
				knob.y = dy;
				if (dx == 0.0 && dy == 0.0) { // Angle not defined in the center
					angle    = 0.0;
					strength = 0.0;
				}
				else {
					angle    = Math.atan2(dy, dx);
					strength = (Math.sqrt(dx * dx + dy * dy) - dead_distance) / (full_distance - dead_distance);
					if (strength > 1.0) strength = 1.0;
				}
				
				
			}
		}
	}
	
	//
	// Mouse handlers
	//
	// Call these when the mouse handlers in your Game-class are called
	//
	
	public function mouseMove(mouse_x: Int, mouse_y: Int) {
		updateDirection(mouse_x, mouse_y);
		_grabbed = true;
	}
	
	public function mouseDown(mouse_x: Int, mouse_y: Int) {
		if (checkMouseCollision(mouse_x, mouse_y))
		{
			_grabbed = true;
			user_is_interacting = true;
			updateDirection(mouse_x, mouse_y);
		}
	}
	
	public function mouseUp(mouse_x: Int, mouse_y: Int)
	{
		user_is_interacting = false;
		_grabbed = false;
	}
	
	//
	// checkMouseCollision()
	//
	// Checks if the mouse or touch is on the virtual analog stick.
	// Here, this is just a simple circle collision test.
	// If your stick has another shape, override this function.
	//
	public function checkMouseCollision(mouse_x: Int, mouse_y: Int): Bool {
		if ((mouse_x >= x) && (mouse_y >= y) && (mouse_x < x + size) && (mouse_y < y + size)) return true;
		return false;
	}
	

	
	public function distanceToCenter(mouse_x: Int, mouse_y: Int): Float {
		var mid_x: Float = x + size / 2;
		var mid_y: Float = y + size / 2;
		var dx: Float = mouse_x - mid_x;
		var dy: Float = mouse_y - mid_y;
		var distance: Float = Math.sqrt(dx * dx + dy * dy);
		return distance;
	}
	
	public function isMouseWithinMoveDistance(mouse_x: Int, mouse_y: Int): Bool {
		if (distanceToCenter(mouse_x, mouse_y) <= move_distance) return true;
		return false;
	}
	/*
	public function isMouseWithinFullDistance(mouse_x: Int, mouse_y: Int): Bool {
		if (distanceToCenter(mouse_x, mouse_y) <= full_distance) return true;
		return false;
	}
*/	
	public function isMouseWithinDeadDistance(mouse_x: Int, mouse_y: Int): Bool {
		if (distanceToCenter(mouse_x, mouse_y) <= dead_distance) return true;
		return false;
	}
	
	public override function update()
	{
		super.update();
		if (Input.mouseDown)
		{
			mouseDown(Input.mouseFlashX, Input.mouseFlashY);
		} else
		if (Input.mouseReleased)
		{
			mouseUp(Input.mouseFlashX, Input.mouseFlashY);
		}
		
		        if (!_grabbed)
				{
		         	_vx += -knob.x * _spring;
					_vy += -knob.y * _spring;
					knob.x += (_vx *= _friction);
					knob.y += (_vy *= _friction);
				}
				
	}
	public override function renderLines(canvas:BatchPrimitives):Void
	{
		var a :Float= 0; 
		
		if (user_is_interacting)
		{
			a = 1;
		} else
		{
			a = 0.1;
			
		}

		alpha = Util.lerp(alpha, a, 5 *  HXP.elapsed);
		
		var dead_area:Float = 2;
		
	    canvas.rect(x, y, size, size,0,1,1,alpha);
		// Cross
		//canvas.rect(x + Std.int((size - dead_area) / 2), y                                  , dead_area, size,1,0,0,alpha);
		//canvas.rect(x, y + Std.int((size - dead_area) / 2), size, dead_area,1,0,0,alpha);
		// Center of cross
		
		
		
		canvas.rect(x + Std.int(size / 2) - dead_distance, y + Std.int(size / 2) - dead_distance, dead_distance * 2 + 1, dead_distance * 2 + 1, 1,0,0,alpha);
        canvas.circle(x + Std.int((size - dead_area) / 2)+knob.x,  y + Std.int((size - dead_area) / 2)+knob.y, 10, 12, 1, 1, 1, 1);
		
	}
	
}
