package actors;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.utils.Util;

/**
 * ...
 * @author djoekr
 */
class Bouncy extends Entity
{

	public function new( graphic:Graphic=null, type:String="entity", blendMode:Int=0, mask:Mask=null) 
	{
		super(HXP.randf(50,100), HXP.randf(50,100), graphic, type, blendMode, mask);
		
		 _vr = Math.random()*0.2 - 0.1;
        _vx = Math.random()*70 - 35;
        _vy = Math.random()*70 - 35;
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		
        var w = HXP.width;
        var h = HXP.height;

        var perSecond = 1000*0.05*HXP.elapsed;
        x += _vx*perSecond;
        y += _vy*perSecond;
        rotation += _vr*perSecond;

        _vy += 0.75*perSecond;

        if (y > h) {
            _vy *= -0.8;
            y = h;
            if (Math.random() < 0.5) {
                _vy -= Math.random()*12;
            }
        }

        if (x > w) {
            _vx *= -0.8;
            x = w;

        } else if (x< 0) {
            _vx *= -0.8;
            x = 0;
        }
		
	}
	
	 private var _vx :Float;
    private var _vy :Float;
    private var _vr :Float;
	
}