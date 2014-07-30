package com.haxepunk;

import com.haxepunk.gl.BlendMode;
import com.haxepunk.gl.Clip;
import flash.display.BitmapData;
import flash.geom.Point;
import openfl.geom.Matrix;



typedef AssignCallback = Void -> Void;

class Graphic
{
	
	public var x:Float;
	public var y:Float;
	
		/**
	 * X scrollfactor, effects how much the camera offsets the drawn graphic.
	 * Can be used for parallax effect, eg. Set to 0 to follow the camera,
	 * 0.5 to move at half-speed of the camera, or 1 (default) to stay still.
	 */
	public var scrollX:Float;

	/**
	 * Y scrollfactor, effects how much the camera offsets the drawn graphic.
	 * Can be used for parallax effect, eg. Set to 0 to follow the camera,
	 * 0.5 to move at half-speed of the camera, or 1 (default) to stay still.
	 */
	public var scrollY:Float;
	
	/**
	 * If the graphic should update.
	 */
	public var active:Bool;

	/**
	 * If the graphic should render.
	 */
	public var visible(get, set):Bool;
	private function get_visible():Bool { return _visible; }
	private function set_visible(value:Bool):Bool { return _visible = value; }

	
	public var blendMode:Int;

	
	/**
	 * Rotation of the image, in degrees.
	 */
	public var angle:Float;

	/**
	 * Scale of the image, effects both x and y scale.
	 */
	public var scale(get, set):Float;
	private function get_scale():Float { return _scale; }
	private function set_scale(value:Float):Float { return _scale = value; }

	/**
	 * X scale of the image.
	 */
	public var scaleX:Float;

	/**
	 * Y scale of the image.
	 */
	public var scaleY:Float;

	


	/**
	 * Constructor.
	 */
	public function new()
	{
		active = false;
		visible = true;
	    scrollX = scrollY = 1;

	    _alpha = 1;
		x = y = 0;
		clip = new Clip(0, 0, 1, 1);
		_color = 0x00FFFFFF;
		_red = _green = _blue = 1;
	
		_point = new Point();
		blendMode = BlendMode.NORMAL;
		 angle = 0;
		scale = scaleX = scaleY = 1;
		_flipx = false;
		_flipy = false;
	}

	/**
	 * Updates the graphic.
	 */
	public function update()
	{

	}

	/**
	 * Removes the graphic from the scene
	 */
	public function destroy() { }



	/**
	 * Renders the graphic as an atlas.
	 * @param  layer      The layer to draw to.
	 * @param  point      The position to draw the graphic.
	 * @param  camera     The camera offset.
	 */
	public function render(m:Matrix, point:Point, camera:Point) { }
	public function renderDebug(m:Matrix,point:Point, camera:Point) { }


	/**
	 * Pause updating this graphic.
	 */
	public function pause()
	{
		active = false;
	}

	/**
	 * Resume updating this graphic.
	 */
	public function resume()
	{
		active = true;
	}

		/**
	 * Change the opacity of the Image, a value from 0 to 1.
	 */
	public var alpha(get, set):Float;
	private function get_alpha():Float { return _alpha; }
	private function set_alpha(value:Float):Float
	{
		value = value < 0 ? 0 : (value > 1 ? 1 : value);
		if (_alpha == value) return value;
		_alpha = value;
		return _alpha;
	}

	/**
	 * If you want to draw the Image horizontally flipped. This is
	 * faster than setting scaleX to -1 if your image isn't transformed.
	 */
	public var flipx(get, set):Bool;
	private function get_flipx():Bool { return _flipx; }
	private function set_flipx(value:Bool):Bool
	{
		

		_flipx = value;
	
		return _flipx;
	}

	public var flipy(get, set):Bool;
	private function get_flipy():Bool { return _flipy; }
	private function set_flipy(value:Bool):Bool
	{
		

		_flipy = value;
	
		return _flipy;
	}
	/**
	 * The tinted color of the Image. Use 0xFFFFFF to draw the Image normally.
	 */
	public var color(get, set):Int;
	private function get_color():Int { return _color; }
	private function set_color(value:Int):Int
	{
		value &= 0xFFFFFF;
		if (_color == value) return value;
		_color = value;
		// save individual color channel values
		_red = HXP.getRed(_color) / 255;
		_green = HXP.getGreen(_color) / 255;
		_blue = HXP.getBlue(_color) / 255;
		return _color;
	}

		// Color and alpha information.
	public var _alpha:Float;
	private var _color:Int;
	public var _red:Float;
	public var _green:Float;
	public var _blue:Float;

	// Graphic information.
	public var clip:Clip;
	private var _point:Point;
	private var _entity:Entity;
    private var _scale:Float;
	private var _visible:Bool;
		public var _flipx:Bool;
	public var _flipy:Bool;
}
