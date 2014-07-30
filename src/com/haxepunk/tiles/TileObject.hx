package com.haxepunk.tiles;

/**
 * ...
 * @author djoker
 */
class TileObject
{
public var name:String;
public var type:String;
public var x:Int;
public var y:Int;
public var width:Int;
public var height:Int;

	public function new(name:String,type:String,x:Int,y:Int,w:Int,h:Int) 
	{
		this.name = name;
		this.type = type;
		this.x = x;
		this.y = y;
		this.width  = w;
		this.height = h;
	//trace("add " + name);
	}
	
}