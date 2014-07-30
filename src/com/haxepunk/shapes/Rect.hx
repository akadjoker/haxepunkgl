package com.haxepunk.shapes;
import com.haxepunk.gl.BatchPrimitives;

/**
 * ...
 * @author djoekr
 */
class Rect extends Shape
{

	public function new(x:Float, y:Float,w:Float,h:Float,fill:Bool,color:Int=0xffffff) 
	{
		super(x, y,fill,color, "rectangle");
		this.setHitbox(Std.int(w), Std.int(h));
	}
	
	public override function renderLines(canvas:BatchPrimitives):Void
	{
		if (Filled)
		{
			canvas.fillrect(x, y, width, height, red, green, blue, alpha);
		} else
		{
			canvas.rect(x, y, width, height, red, green, blue, alpha);
		}
	}
	
}