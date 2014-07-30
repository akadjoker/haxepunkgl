package com.haxepunk.gui;

import com.haxepunk.gl.Clip;
import com.haxepunk.HXP;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.gui.NineSlice;
import com.haxepunk.utils.Input;

class MenuItem extends Button
{
	
	public function new(text:String, click:Dynamic)
	{
		super(x, y, text, 0, 0, true);
		onClick = click;
	}
	
}