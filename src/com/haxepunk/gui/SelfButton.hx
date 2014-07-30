package com.haxepunk.gui;

import com.haxepunk.Entity;
import com.haxepunk.gl.Clip;
import com.haxepunk.gl.Texture;
import com.haxepunk.HXP;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.utils.Input;

import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;

/**
 * ...
 * @author djoekr
 */
class SelfButton extends Entity
{
/**
	 * This function will be called when the button is pressed. 
	 */		
	public dynamic function onClick(button:SelfButton) { }
	
	/**
	 * This function will be called when the mouse overs the button. 
	 */		
	public dynamic function onHover(button:SelfButton) { }
	
	public var normal:Graphic;
	public var down:Graphic;

	
	public function new(x:Float,y:Float,normal:Graphic,press:Graphic,active:Bool=true) 
	{
		super(x, y);
		this.normal = normal;
	    this.down = press;
		this.type = "selfbutton";
		isActive = active;
		centerPivot();
		centerOrigin();
		width = normal.clip.width;
		height = normal.clip.height;
		layer = -100;
	
	}


	
	
	override public function update()
	{
		//setHitbox(Std.int(width*scaleX),Std.int(height*scaleY));
		if (graphic != null)
		{
		 width = Std.int(graphic.clip.width*scaleX);
		 height = Std.int(graphic.clip.height * scaleY);
		}
		
		//trace(Input.mouseX + "<>" + Input);
	
		if (_active)
		{
			super.update();
			
			if(collidePoint(x, y, Input.localX, Input.localY))
			{
				if(Input.mouseDown)
				{
					graphic = down;
					if(collidePoint(x, y, Input.localX, Input.localY)) onClick(this);
				//	trace("down");
				}
				else
				{
					graphic = normal;
					if(!_overCalled)
					{
						if(onHover != null) onHover(this);
						_overCalled = true;
					}
				}
			}
			else
			{
				graphic = normal;
				_overCalled = false;
			}
		}
		else
		{
			graphic = normal;
		}
			this.graphic.scrollX = 0;
		this.graphic.scrollY = 0;
	
	}
	
	
	

	
	/**
	 * @private
	 */
	override public function removed()
	{
		super.removed();

		onClick = null;
		onHover = null;
		normal = null;
		down = null;
		
		
		//if(HXP.stage != null) HXP.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

    public var isActive(get_isActive, set_isActive):Bool;
	private function get_isActive():Bool { return _active; }
	private function set_isActive(value:Bool):Bool {
		_active = value;
		return _active;
	}
	/** @private */ private var _overCalled:Bool;
	/** @private */ private var _active:Bool;
	
	
}