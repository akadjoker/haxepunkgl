package com.haxepunk.gui;

import com.haxepunk.gl.Clip;
import com.haxepunk.HXP;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.gui.NineSlice;
import com.haxepunk.utils.Input;


class RadioButton extends ToggleButton
{
	
	public function new(x:Float = 0, y:Float = 0, text:String = "Checkbox", id:String = "radio", checked:Bool = false, width:Int = 100, active:Bool = true)
	{
	//	_align = TextFormatAlign.LEFT;
		_name = id;
		addButton();
		
		super(x, y, text, width, 0, checked, active);
		this.width = this.height = 16;
		
		normal = new UiImage(_skin, new Clip(0, 64, 16, 16));
		hover = new UiImage(_skin, new Clip(16, 64, 16, 16));
		down = new UiImage(_skin, new Clip(32, 64, 16, 16));
		hoverDown = new UiImage(_skin, new Clip(48, 64, 16, 16));
		inactive = new UiImage(_skin, new Clip(64, 64, 16, 16));
		inactiveDown = new UiImage(_skin, new Clip(80, 64, 16, 16));
	}
	
	private function addButton()
	{
		/*
		var buttons:Array<RadioButton> = _buttons.get(_name);
		if (buttons == null)
		{
			buttons = new Array<RadioButton>();
			buttons.push(this);
			_buttons.set(_name, buttons);
		}
		else
		{
			buttons.push(this);
		}
		*/
	}
	/*
	override private function setChecked(value:Bool):Bool
	{
		if (value)
		{
			var buttons:Array<RadioButton> = _buttons.get(_name);
			var button:RadioButton;
			for (button in buttons)
			{
				if (button != this)
					button._checked = false;
			}
		}
		return super.checked(value);
	}
	*/
	override private function setX(value:Float):Float
	{
		label.x = value + width + padding;
		_x = value;
		return _x;
	}
	
	//private var _name:String;
	private static var _buttons:Map<String,RadioButton> = new Map<String,RadioButton>();
	
}