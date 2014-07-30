package com.haxepunk.shapes;
import com.haxepunk.gl.BatchPrimitives;
import haxe.Constraints.FlatEnum;
/**
 * ...
 * @author djoekr
 */
class Ellipse extends Shape
{
	private var rad:Float;

	public function new(x:Float, y:Float,r:Float,fill:Bool,color:Int=0xffffff) 
	{
		super(x, y, fill, color, "circle");
		rad = r;
		this.setHitbox(Std.int(r*2), Std.int(r*2));
	}
	
	public override function renderLines(canvas:BatchPrimitives):Void
	{
		if (Filled)
		{
			canvas.fillcircle(x, y, rad,11, red, green, blue, alpha);
		} else
		{
			canvas.circle(x, y, rad,11, red, green, blue, alpha);
		}
	}
	
}