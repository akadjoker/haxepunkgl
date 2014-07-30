package com.haxepunk.gui;

import com.haxepunk.graphics.ImageFont;
import com.haxepunk.HXP;


/**
 * @author PigMess
 * @author Rolpege
 */

class Label extends Control
{
	public static var defaultSize:Float = 16;
	public static var defaultColor:Int = 0xffffff;

	
	public function new(text:String = "", x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0)
	{
	
		_textField = new ImageFont( text, HXP.engine.game.getTexture("gfx/04f.png"), 0);
	//	_textField = new ImageFont( text, HXP.engine.game.getTexture("gfx/arial.png"), 0);
		_textField.characterWidth = 12;
		_textField.color = defaultColor;
	
		width  =  _textField.getTextWidth(text)+2;
		height =  16;
        graphic = _textField;
		super(x, y, width, height);
		
		
		
		
	}
	

	
	public var text(get_text, set_text):String;
	private function get_text():String { return _textField.caption; }
	private function set_text(value:String):String 
	{
		_textField.caption = value;
		return value;
	}
	public var size(get_size, set_size):Dynamic;
	private function get_size():Dynamic { return _textField.characterHeight; }
	private function set_size(value:Dynamic):Dynamic 
	{
		//_textField.defaultTextFormat.size = value;
		return value;
	}
	
	
	/*
	public var color(getColor, setColor):Int;
	private function getColor():Int { return _textField.textColor; }
	private function setColor(value:Int):Int {
		_textField.textColor = value;
		return value;
	}
	

	
	public var length(getLength, null):Int;
	private function getLength():Int { return _textField.length; }
	
	public var size(getSize, setSize):Dynamic;
	private function getSize():Dynamic { return _textField.defaultTextFormat.size; }
	private function setSize(value:Dynamic):Dynamic {
		_textField.defaultTextFormat.size = value;
		return value;
	}
	
	public var font(getFont, setFont):String;
	private function getFont():String { return _textField.defaultTextFormat.font; }
	private function setFont(value:String):String {
		_textField.defaultTextFormat.font = value;
		return value;
	}
	*/

	private var _textField:ImageFont;
	
}