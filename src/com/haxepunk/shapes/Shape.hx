package com.haxepunk.shapes;
import com.haxepunk.Entity;

/**
 * ...
 * @author djoekr
 */
class Shape extends Entity
{
    public var Filled:Bool;
 	private var _alpha:Float;
	private var _color:Int;
	private var red:Float;
	private var green:Float;
	private var blue:Float;
	
	public function new(x:Float,y:Float,fill:Bool,color:Int=0xffffff,type:String="shape") 
	{
		super(x, y, null, type);
		Filled = fill;
		this.color = color;
		_alpha = 1;
		
	}
	public var alpha(get, set):Float;
	private function get_alpha():Float { return _alpha; }
	private function set_alpha(value:Float):Float
	{
		value = value < 0 ? 0 : (value > 1 ? 1 : value);
		if (_alpha == value) return value;
		_alpha = value;
		return _alpha;
	}
	public var color(get, set):Int;
	private function get_color():Int { return _color; }
	private function set_color(value:Int):Int
	{
		value &= 0xFFFFFF;
		if (_color == value) return value;
		_color = value;
		red = HXP.getRed(_color) / 255;
		green = HXP.getGreen(_color) / 255;
		blue = HXP.getBlue(_color) / 255;
		return _color;
	}
	
}