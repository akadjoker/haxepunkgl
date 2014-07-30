package com.haxepunk.gui;

import com.haxepunk.gl.Clip;
import com.haxepunk.HXP;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.gui.NineSlice;
import com.haxepunk.utils.Input;

class CheckBox extends ToggleButton
{
	
	public function new(x:Float = 0, y:Float = 0, text:String = "Checkbox", checked:Bool = false, width:Int = 100, active:Bool = true)
	{
		//_align = TextFormatAlign.LEFT;
		super(x, y, text, width, 0, checked, active);
		this.width = this.height = 16;
		
		normal = new UiImage(_skin, new Clip(0, 48, 16, 16));
		hover = new UiImage(_skin, new Clip(16, 48, 16, 16));
		down = new UiImage(_skin, new Clip(64, 48, 16, 16));
		hoverDown = new UiImage(_skin, new Clip(80, 48, 16, 16));
		inactive = new UiImage(_skin, new Clip(96, 0, 16, 16));
		inactiveDown = new UiImage(_skin, new Clip(96, 32, 16, 16));
	}
	
	override private function setX(value:Float):Float
	{
		label.x = value + width + padding;
		_x = value;
		return _x;
	}
	
}