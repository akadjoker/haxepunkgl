package com.haxepunk.gui;

import com.haxepunk.Entity;
import com.haxepunk.gl.Texture;


/**
 * @author PigMess
 * @author AClockWorkLemon
 * @author Rolpege
 */

class Control extends Entity
{


	@:isVar public static var defaultSkin(get_defaultSkin, set_defaultSkin):Texture;
	static function get_defaultSkin() {
		
		if (defaultSkin != null) 
			return defaultSkin;
		else
			return defaultSkin =HXP.engine.game.getTexture("gfx/defaultSkin.png");

	}
	@:isVar static function set_defaultSkin(v) {
		return defaultSkin = v;
	}

	/** class constructor
	 * @param x - position of the component on the X axis
	 * @param y - position of the component on the Y axis
	 * @param width - width of the component
	 * @param height - height of the component
	 */
	public function new(x:Float = 0, y:Float = 0, width:Int = 1, height:Int = 1, ?skin:Texture) {
		super(x, y);
		this.width = width;
		this.height = height;
		_skin = (skin != null) ? skin : defaultSkin;
	}

	public override function added()
	{
		_lastX = setX(x);
		_lastY = setY(y);
	}

	override public function update()
	{
		if (x != _lastX) _lastX = setX(x);
		if (y != _lastY) _lastY = setY(y);
		super.update();
	}

	private function setX(value:Float):Float
	{
		return value;
	}

	private function setY(value:Float):Float
	{
		return value;
	}

	private var _lastX:Float;
	private var _lastY:Float;
	private var _skin:Texture;
}