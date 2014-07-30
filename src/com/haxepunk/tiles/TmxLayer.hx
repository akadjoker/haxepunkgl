package com.haxepunk.tiles;

/**
 * ...
 * @author djoker
 */
class TmxLayer
{
public var tilesIDs:Array<Int>;
public var tileWidth:Int;
public var tileHeight:Int;
public var name:String;
public var width:Int;
public var height:Int;
public var opacity:Float ;

	public function new(w:Int,h:Int,tw:Int,th:Int,alpha:Float,name:String) 
	{
	tilesIDs = [];
	this.width = w;
	this.height = h;
	this.tileWidth = tw;
	this.tileHeight = th;
	this.name = name;
	this.opacity = alpha;
	}
	public function getTile(x:Int, y:Int):Int
	{
			 return  tilesIDs[y * this.width + x];
			
	}
		
	public function setTile(x:Int, y:Int,t:Int)
	{
		  tilesIDs[y * this.width + x]=t;
			
	}
	public function loadFromString(str:String, columnSep:String = ",", rowSep:String = "\n")
	{
		var row:Array<String> = str.split(rowSep),
			rows:Int = row.length,
			col:Array<String>, cols:Int, x:Int, y:Int;
		for (y in 0...rows)
		{
			if (row[y] == '') continue;
			col = row[y].split(columnSep);
			cols = col.length;
			for (x in 0...cols)
			{
				if (col[x] == '') continue;
				setTile(x,y, Std.parseInt(col[x]));
			}
		}
	}
	public function dispose():Void 
    {
	tilesIDs = [];	
	}
	
	
	
public function toCSV():String 
{
	var counter:Int = 0;
		var csv:String = "";

		for (tile in tilesIDs) 
		{
			var tileGID = tile;

			if (counter >= width) 
			{
				// remove the last ","
				csv = csv.substr(0, csv.length - 1);

				// add a new line and reset counter
				csv += '\n';
				counter = 0;
			}

			csv += tileGID;
			csv += ',';

			counter++;
		}

		// remove the last ","
		csv = csv.substr(0, csv.length - 1);

		return csv;
	}

	
}