package com.haxepunk.tiles;

import com.haxepunk.gl.Texture;
import com.haxepunk.graphics.SpriteSheet;
import com.haxepunk.utils.Util;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import openfl.Assets;


import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;

/**
 * ...
 * @author djoker
 */


class TmxTileMap 
{

	public var grid:Grid;

	public var widthInTiles:Int;
	public var heightInTiles:Int;

	public var tileWidth:Int;
	public var tileHeight:Int;
	public var margin:Int=0;
	public var spacing:Int=0;
	public var columns:Int;
	public var ortho:Bool;

	private var image:Texture;



private var invTexWidth:Float = 0;
private var invTexHeight:Float = 0;

//public var shader:SpriteShader;
	public var levelObjects:List<TileObject>;


//layers

public var layers:Array<TmxLayer>;


	

 public  function new (tiles:Texture,xml:String,?Build:Bool=true):Void 
		{
		image =tiles;
		 levelObjects = new List<TileObject>();
		var xml = Xml.parse(xml).firstElement();

		 widthInTiles = Std.parseInt(xml.get("width"));
		 heightInTiles = Std.parseInt(xml.get("height"));
		if (xml.get("orientation") == "orthogonal")
		{
		ortho = true;
		} else {
	    ortho = false;
		}
		// tileWidth = Std.parseInt(xml.get("tilewidth"));
		// tileHeight = Std.parseInt(xml.get("tileheight"));
		var properties = new Map<String, String>();
		layers = [];

		for (child in xml)
		{
		if (isValidElement(child)) 
			{
				if (child.nodeName == "tileset")
				{
					if (child.get("source") != null) 
					{
					   tilesfromGenericXml(getText(child.get("source")));
					} else 
					{
						tilesfromGenericXml(child.toString());
					}
				}

				else if (child.nodeName == "properties") 
				{
					for (property in child) 
					{
						if (!isValidElement(property))
							continue;
				//		properties.set(property.get("name"), property.get("value"));
					}
				}

				else if (child.nodeName == "layer") 
				{
					layerfromGenericXml(child);
				}

				else if (child.nodeName == "objectgroup") 
				{
				objectsfromGenericXml(child);
				}
			}
		}
		
		
		
		this.columns = Std.int(image.width / this.tileWidth);
		
		
		

}

public function clearLevelObjects()
	{
		
		if (levelObjects != null)
		{
			var count:Int = levelObjects.length;
	
			for (o in levelObjects.iterator())
			{
				levelObjects.remove(o);
				o = null;
			}
	
			levelObjects = null;
		}
	}


	

 
		


	
		public  function objectfromGenericXml(xml:Xml) 
		{
		var gid:Int = xml.get("gid") != null ? Std.parseInt(xml.get("gid")) : 0;
		var name:String = xml.get("name");
		var type:String = xml.get("type");
		var x:Int = Std.parseInt(xml.get("x"));
		var y:Int = Std.parseInt(xml.get("y"));
		var width:Int = Std.parseInt(xml.get("width"));
		var height:Int = Std.parseInt(xml.get("height"));
		
		var gObject:TileObject = new TileObject(name, type, x, y, width, height);
		levelObjects.add(gObject);
		
		//var polygon:TiledPolygon = null;
		//var polyline:TiledPolyline = null;
		var properties:Map<String, String> = new Map<String, String>();
		
		for (child in xml) 
		{
			if (isValidElement(child)) 
			{
				if (child.nodeName == "properties")
				{
					for (property in child) 
					{
						if (isValidElement(property)) 
						{
							properties.set(property.get("name"), property.get("value"));
						}
					}
				}
				
				if (child.nodeName == "polygon" || child.nodeName == "polyline")
				{
					var origin:Point = new Point(x, y);
					var points:Array<Point> = new Array<Point>();
					
					var pointsAsString:String = child.get("points");
					
					var pointsAsStringArray:Array<String> = pointsAsString.split(" ");
					
					for (p in pointsAsStringArray) 
					{
						//var coords:Array<String> = p.split(",");
						//points.push(new Point(Std.parseInt(coords[0]), Std.parseInt(coords[1])));
					}
					
					if (child.nodeName == "polygon") 
					{
						//polygon = new TiledPolygon(origin, points);
					} else if (child.nodeName == "polyline") 
					{
					//	polyline = new TiledPolyline(origin, points);
					}
				}
			}
		}
		
	
	}
		public  function objectsfromGenericXml(xml:Xml)
		{
		var name = xml.get("name");
		var color = xml.get("color");
		var width = Std.parseInt(xml.get("width"));
		var height = Std.parseInt(xml.get("height"));
		var properties:Map<String, String> = new Map<String, String>();
		//var objects:Array<TiledObject> = new Array<TiledObject>();
		
		for (child in xml) {
			if (isValidElement(child))
			{
				if (child.nodeName == "properties") {
					for (property in child) {
						if (isValidElement(property)) 
						{
							properties.set(property.get("name"), property.get("value"));
						}
					}
				}
				
				if (child.nodeName == "object") 
				{
					objectfromGenericXml(child);
				}
			}
		}
		
		
	}

	
	public  function isValidElement(element:Xml):Bool
	{
		return Std.string(element.nodeType) == "element";
	}
	public function getText(assetPath:String):String 
	{
		return Assets.getText(assetPath);
	}
	
	public  function tilesfromGenericXml(content:String)
	{
		var xml = Xml.parse(content).firstElement();

		var name:String = xml.get("name");
		tileWidth = Std.parseInt(xml.get("tilewidth"));
		tileHeight = Std.parseInt(xml.get("tileheight"));
		spacing = xml.exists("spacing") ? Std.parseInt(xml.get("spacing")) : 0;
		margin = xml.exists("margin") ? Std.parseInt(xml.get("margin")) : 0;
		
		var properties:Map<String, String> = new Map<String, String>();
		//var propertyTiles:Map<Int, PropertyTile> = new Map<Int, PropertyTile>();
		//var terrainTypes:Array<TerrainType> = new Array<TerrainType>();
		//var image:TilesetImage = null;

		var tileOffsetX:Int = 0;
		var tileOffsetY:Int = 0;

		for (child in xml.elements()) 
		{
			if (isValidElement(child)) 
			{
				if (child.nodeName == "properties") 
				{
					for (property in child) {
						if (isValidElement(property)) 
						{
							trace("tileHeight set name:" + property.get("name") +" - Value : " + property.get("value"));
						//	properties.set(property.get("name"), property.get("value"));
						}
					}
				}

				if (child.nodeName == "tileoffset") 
				{
					tileOffsetX = Std.parseInt(child.get("x"));
					tileOffsetY = Std.parseInt(child.get("y"));
				}

				if (child.nodeName == "image")
				{
					
					var width = Std.parseInt(child.get("width"));
					var height = Std.parseInt(child.get("height"));
                   // trace("Tile set: Image: " + child.get("source"));
				   
					//this.image.load("assets/" + child.get("source"));
					if (image!=null)
					{
					
					
					
					//trace("Columns:" + columns);
					}
					
				}

				if (child.nodeName == "terraintypes") 
				{
					for (element in child) 
					{

						if (isValidElement(element)) 
						{
							if (element.nodeName == "terrain") 
							{
						//		terrainTypes.push(new TerrainType(element.get("name"), Std.parseInt(element.get("tile"))));
							}
						}
					}
				}

			
				if (child.nodeName == "tile")
				{
					//trace("tile");
					var id:Int = Std.parseInt(child.get("id"));
					var properties:Map<String, String> = new Map<String, String>();

					for (element in child) 
					{

						if (isValidElement(element)) 
						{
							if (element.nodeName == "properties") 
							{
								for (property in element) {
									if (!isValidElement(property)) {
										continue;
									}

									//properties.set(property.get("name"), property.get("value"));
								}
							}
						}
					}

					//propertyTiles.set(id, new PropertyTile(id, properties));
				}
			}
		}

		//return new Tileset(name, tileWidth, tileHeight, spacing, properties, terrainTypes, image,
		//new Point(tileOffsetX, tileOffsetY));
	}	
	
	
	private  function csvToArray(input:String):Array<Int>
	{
		var result:Array<Int> = new Array<Int>();
		var rows:Array<String> = StringTools.trim(input).split("\n");
		var row:String;

		for (row in rows) {

			if (row == "") {
				continue;
			}

			var resultRow:Array<Int> = new Array<Int>();
			var entries:Array<String> = row.split(",");
			var entry:String;

			for (entry in entries) {

				if(entry != "") {
					result.push(Std.parseInt(entry));
				}
			}
		}
		return result;
	}
    
	
		public  function layerfromGenericXml(xml:Xml)
		{
			
			
		
		var name:String = xml.get("name");
		var width:Int = Std.parseInt(xml.get("width"));
		var height:Int = Std.parseInt(xml.get("height"));
		var opacity:Float = Std.parseFloat(xml.get("opacity") != null ?			xml.get("opacity") : "1.0");

		//var layer:Tilemap = new Tilemap(image,width * tileWidth, height * tileHeight, tileWidth, tileHeight,spacing,margin);
		//layer.alpha = opacity;
		
		var layer:TmxLayer = new TmxLayer(width , height , tileWidth, tileHeight,opacity,name);
		
		
		//layer.parent = this;
	 

		for (child in xml) 
		{
	
			if (isValidElement(child)) 
			{
				if (child.nodeName == "data") 
				{
					var encoding:String = "";
					if (child.exists("encoding"))
					{
						encoding = child.get("encoding");
					}
					var chunk:String = "";
					switch(encoding){
						case "base64":
							{
							chunk = child.firstChild().nodeValue;
							layer.tilesIDs = Util.base64ToArray(chunk, width, false);
							//trace("base64");
							}
						case "csv":
							{
							chunk = child.firstChild().nodeValue;
							layer.tilesIDs = csvToArray(chunk);
							//trace("csv");
				     	}
						default:
							{
								//trace("tiles");
							for (tile in child) 
							{
								if (isValidElement(tile)) 
								{
									var gid = Std.parseInt(tile.get("gid"));
									layer.tilesIDs.push(gid);
								}
							}
							}
					}
				}
			}
		}
		
		/*
		grid = new Grid(width * tileWidth, height * tileHeight, tileWidth, tileHeight);
		grid.loadFromString(toCSV(tilesIDs, width));
		setHitbox(grid.width, grid.height);
		type = "solid";
		mask = grid;
		
		
		
		layer.loadFromString(toCSV(tilesIDs, width));
		tilesIDs = null;
		*/
		layers.push(layer);
}

public function createEntity(index:Int, ?colisions:Bool=false):Entity
{
	var map:Tilemap = new Tilemap(image, widthInTiles * tileWidth, heightInTiles * tileHeight, tileWidth, tileHeight, spacing, margin);
	map.loadFromString(layers[index].toCSV());
	var l:Entity;
	if (colisions)
	{
	var grid:Grid = new Grid(widthInTiles * tileWidth, heightInTiles * tileHeight, tileWidth, tileHeight);
	grid.loadFromString(layers[index].toCSV());
	l = new Entity(0, 0, map, "tiles",grid);	
	l.name = layers[index].name;
	l.setHitbox(grid.width, grid.height);
	} else
	{
	l = new Entity(0, 0, map, "tiles");
	l.name = layers[index].name;
	}
	return l;
	
}
	

	


public function getTile(layer:Int,x:Float,y:Float):Int
{
	
	   if (layer >= layers.length) layer = layers.length;
	   
	   if (x < 0 || y < 0 || x > (widthInTiles*tileWidth) || y > (heightInTiles* tileHeight) ) 
	   {
		   return 0;
	   }
	   if (y < 0) 
	   {
		   return 0;
	   }
		  	

	   /*
	   if (x < 0) x = 0;
	   if (y < 0) y = 0;
	  	var column:Int = Std.int(x / tileWidth);
		var row:Int = Std.int(y / tileHeight);
	    if (column > widthInTiles) column = widthInTiles;
	    if (row > heightInTiles) row = heightInTiles;
		*/
		//   var column:Int = Std.int(x / tileWidth);
		//   var row:Int = Std.int(y / tileHeight);
	 
	  return layers[layer].getTile(Std.int(x),Std.int(y));
}



public function getCell(layer:Int, x:Int, y:Int):Int
{	 		
 return layers[layer].getTile(x,y);
}

		
 public function dispose():Void 
{
	 for (l in 0...layers.length)
	 {
	 layers[l].dispose();
	 }
	 Util.clearArray(layers);
	 
	 layers = null;
	 clearLevelObjects();
	
	
}
}