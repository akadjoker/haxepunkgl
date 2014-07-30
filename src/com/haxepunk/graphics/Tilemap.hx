package com.haxepunk.graphics;
import com.haxepunk.gl.Game;
import com.haxepunk.gl.Texture;
import com.haxepunk.gl.Clip;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import openfl.geom.Matrix;


typedef Array2D = Array<Array<Int>>
/**
 * A canvas to which Tiles can be drawn for fast multiple tile rendering.
 */
class Tilemap extends Graphic
{
	private var vertices:Array<Float>;

	
	/**
	 * If x/y positions should be used instead of columns/rows.
	 */
	public var usePositions:Bool;

	/**
	 * Constructor.
	 * @param	tileset				The source tileset image.
	 * @param	width				Width of the tilemap, in pixels.
	 * @param	height				Height of the tilemap, in pixels.
	 * @param	tileWidth			Tile width.
	 * @param	tileHeight			Tile height.
	 * @param	tileSpacingWidth	Tile horizontal spacing.
	 * @param	tileSpacingHeight	Tile vertical spacing.
	 */
	public function new(tex:Texture, width:Int, height:Int, tileWidth:Int, tileHeight:Int, ?tileSpacingWidth:Int=0, ?tileSpacingHeight:Int=0)
	{
		super();
		
		tiles = [];
		texture = tex;

		 vertices =   new Array<Float>();
		 
		margin = tileSpacingWidth;
		spacing = tileSpacingHeight;
	//	tilecolumns = Std.int(texture.width / this.tileWidth);
	
	   clip = new  Clip();
			
		
	//	prepareTiles( tileWidth, tileHeight, tileSpacingWidth, tileSpacingHeight);
		
		_rect = HXP.rect;
		
		scale = scaleX = scaleY = 1;

		// set some tilemap information
		_width = width - (width % tileWidth);
		_height = height - (height % tileHeight);
		
		
		
		_columns = Std.int(_width / tileWidth);
		_rows = Std.int(_height / tileHeight);

		this.tileSpacingWidth = tileSpacingWidth;
		this.tileSpacingHeight = tileSpacingHeight;

		if (_columns == 0 || _rows == 0)
			throw "Cannot create a bitmapdata of width/height = 0";

		// create the canvas
#if neko
		_maxWidth = 4000 - 4000 % tileWidth;
		_maxHeight = 4000 - 4000 % tileHeight;
#else
		_maxWidth -= _maxWidth % tileWidth;
		_maxHeight -= _maxHeight % tileHeight;
#end

		//super(_width, _height);

		// initialize map
		_tile = new Rectangle(0, 0, tileWidth, tileHeight);
		_map = new Array2D();
		for (y in 0..._rows)
		{
			_map[y] = new Array<Int>();
			for (x in 0..._columns)
			{
				_map[y][x] = -1;
			}
		}

		_alpha = 1;
		_color = 0x00FFFFFF;
		_red = _green = _blue = 1;
	
			_setColumns = Std.int(texture.width / tileWidth);
			_setRows = Std.int(texture.height / tileHeight);
		
		_setCount = _setColumns * _setRows;
	}
	
	    public function prepareTiles( tileWidth:Int, tileHeight:Int, tileMarginWidth:Int,tileMarginHeight:Int)
	{
		var cols:Int = Math.floor(texture.width / tileWidth);
		var rows:Int = Math.floor(texture.height / tileHeight);

		var clip:Clip = new Clip();
		clip.width = tileWidth;
		clip.height = tileHeight;

		HXP.point.x = HXP.point.y = 0;

		for (y in 0...rows)
		{
			clip.y = y * (tileHeight+tileMarginHeight);

			for (x in 0...cols)
			{
				clip.x = x * (tileWidth+tileMarginWidth);
				tiles.push(clip);

			}
		}
	}

	/**
	 * Sets the index of the tile at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 * @param	index		Tile index.
	 */
	public function setTile(column:Int, row:Int, index:Int = 0)
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
		}
		index %= _setCount;
		column %= _columns;
		row %= _rows;
		_map[row][column] = index;

	}

	/**
	 * Clears the tile at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 */
	public function clearTile(column:Int, row:Int)
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
		}
		column %= _columns;
		row %= _rows;
		_map[row][column] = -1;
	
	}

	/**
	 * Gets the tile index at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 * @return	The tile index.
	 */
	public function getTile(column:Int, row:Int):Int
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
		}
		return _map[row % _rows][column % _columns];
	}

	/**
	 * Sets a rectangular region of tiles to the index.
	 * @param	column		First tile column.
	 * @param	row			First tile row.
	 * @param	width		Width in tiles.
	 * @param	height		Height in tiles.
	 * @param	index		Tile index.
	 */
	public function setRect(column:Int, row:Int, width:Int = 1, height:Int = 1, index:Int = 0)
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
			width = Std.int(width / _tile.width);
			height = Std.int(height / _tile.height);
		}
		column %= _columns;
		row %= _rows;
		var c:Int = column,
			r:Int = column + width,
			b:Int = row + height,
			u:Bool = usePositions;
		usePositions = false;
		while (row < b)
		{
			while (column < r)
			{
				setTile(column, row, index);
				column ++;
			}
			column = c;
			row ++;
		}
		usePositions = u;
	}

	/**
	 * Clears the rectangular region of tiles.
	 * @param	column		First tile column.
	 * @param	row			First tile row.
	 * @param	width		Width in tiles.
	 * @param	height		Height in tiles.
	 */
	public function clearRect(column:Int, row:Int, width:Int = 1, height:Int = 1)
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
			width = Std.int(width / _tile.width);
			height = Std.int(height / _tile.height);
		}
		column %= _columns;
		row %= _rows;
		var c:Int = column,
			r:Int = column + width,
			b:Int = row + height,
			u:Bool = usePositions;
		usePositions = false;
		while (row < b)
		{
			while (column < r)
			{
				clearTile(column, row);
				column ++;
			}
			column = c;
			row ++;
		}
		usePositions = u;
	}

	/**
	 * Set the tiles from an array.
	 * The array must be of the same size as the Tilemap.
	 *
	 * @param	array	The array to load from.
	 */
	public function loadFrom2DArray(array:Array2D):Void
	{

		_map = array;
	}

	/**
	* Loads the Tilemap tile index data from a string.
	* The implicit array should not be bigger than the Tilemap.
	* @param str			The string data, which is a set of tile values separated by the columnSep and rowSep strings.
	* @param columnSep		The string that separates each tile value on a row, default is ",".
	* @param rowSep			The string that separates each row of tiles, default is "\n".
	*/
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

				
				_map[y][x] = Std.parseInt(col[x]);
			}
		}
	}

	/**
	* Saves the Tilemap tile index data to a string.
	* @param columnSep		The string that separates each tile value on a row, default is ",".
	* @param rowSep			The string that separates each row of tiles, default is "\n".
	*
	* @return	The string version of the array.
	*/
	public function saveToString(columnSep:String = ",", rowSep:String = "\n"): String
	{
		var s:String = '',
			x:Int, y:Int;
		for (y in 0..._rows)
		{
			for (x in 0..._columns)
			{
				s += Std.string(getTile(x, y));
				if (x != _columns - 1) s += columnSep;
			}
			if (y != _rows - 1) s += rowSep;
		}
		return s;
	}

	/**
	 * Gets the index of a tile, based on its column and row in the tileset.
	 * @param	tilesColumn		Tileset column.
	 * @param	tilesRow		Tileset row.
	 * @return	Index of the tile.
	 */
	public inline function getIndex(tilesColumn:Int, tilesRow:Int):Int
	{
		return (tilesRow % _setRows) * _setColumns + (tilesColumn % _setColumns);
	}

	/**
	 * Shifts all the tiles in the tilemap.
	 * @param	columns		Horizontal shift.
	 * @param	rows		Vertical shift.
	 * @param	wrap		If tiles shifted off the canvas should wrap around to the other side.
	 */
	public function shiftTiles(columns:Int, rows:Int, wrap:Bool = false)
	{
		if (usePositions)
		{
			columns = Std.int(columns / _tile.width);
			rows = Std.int(rows / _tile.height);
		}

		if (columns != 0)
		{
			var y:Int = 0;
			for (y in 0..._rows)
			{
				var row = _map[y];
				if (columns > 0)
				{
					for (x in 0...columns)
					{
						var tile:Int = row.pop();
						if (wrap) row.unshift(tile);
					}
				}
				else
				{
					for (x in 0...Std.int(Math.abs(columns)))
					{
						var tile:Int = row.shift();
						if (wrap) row.push(tile);
					}
				}
			}
			_columns = _map[Std.int(y)].length;

#if flash
		//	shift(Std.int(columns * _tile.width), 0);
			_rect.x = columns > 0 ? 0 : _columns + columns;
			_rect.y = 0;
			_rect.width = Math.abs(columns);
			_rect.height = _rows;
			updateRect(_rect, !wrap);
#end
		}

		if (rows != 0)
		{
			if (rows > 0)
			{
				for (y in 0...rows)
				{
					var row:Array<Int> = _map.pop();
					if (wrap) _map.unshift(row);
				}
			}
			else
			{
				for (y in 0...Std.int(Math.abs(rows)))
				{
					var row:Array<Int> = _map.shift();
					if (wrap) _map.push(row);
				}
			}
			_rows = _map.length;

#if flash
		//	shift(0, Std.int(rows * _tile.height));
			_rect.x = 0;
			_rect.y = rows > 0 ? 0 : _rows + rows;
			_rect.width = _columns;
			_rect.height = Math.abs(rows);
			updateRect(_rect, !wrap);
#end
		}
	}

	/** @private Used by shiftTiles to update a rectangle of tiles from the tilemap. */
	private function updateRect(rect:Rectangle, clear:Bool)
	{
		var x:Int = Std.int(rect.x),
			y:Int = Std.int(rect.y),
			w:Int = Std.int(x + rect.width),
			h:Int = Std.int(y + rect.height),
			u:Bool = usePositions;
		usePositions = false;
		if (clear)
		{
			while (y < h)
			{
				while (x < w) clearTile(x ++, y);
				x = Std.int(rect.x);
				y ++;
			}
		}
		else
		{
			while (y < h)
			{
				while (x < w) updateTile(x ++, y);
				x = Std.int(rect.x);
				y ++;
			}
		}
		usePositions = u;
	}
	
	public function getClip(num:Int):Clip
		{
				var cols:Int = Math.floor(texture.width / tileWidth);
	
			clip.set(
			this.margin + (this.tileWidth  + this.spacing) * num % cols,
			this.margin + (this.tileHeight + this.spacing) * Std.int(num / cols),
			this.tileWidth, this.tileHeight);
			
			return clip;
		}

     override	 public function render( m:Matrix, point:Point,camera:Point)
	{
		// determine drawing location
		_point.x = point.x + x - camera.x * scrollX;
		_point.y = point.y + y - camera.y * scrollY;


		var scalex:Float =  HXP.screen.fullScaleX; 
		var scaley:Float =  HXP.screen.fullScaleY;
		var	tw:Int = Math.ceil(tileWidth);
		var	th:Int = Math.ceil(tileHeight);

		var scx = scale * scaleX,
			scy = scale * scaleY;

		// determine start and end tiles to draw (optimization)
		var startx = Math.floor( -_point.x / (tw * scx)),
			starty = Math.floor( -_point.y / (th * scy)),
			destx = startx + 1 + Math.ceil(HXP.windowWidth / (tw * scx)),
			desty = starty + 1 + Math.ceil(HXP.windowHeight / (th * scy));

		// nothing will render if we're completely off screen
		//if (startx > _columns || starty > _rows || destx < 0 || desty < 0)
		//	return;

		// clamp values to boundaries
		if (startx < 0) startx = 0;
		if (destx > _columns) destx = _columns;
		if (starty < 0) starty = 0;
		if (desty > _rows) desty = _rows;

		var wx:Float, sx:Float = (_point.x + startx * tw * scx) * scalex,
			wy:Float = (_point.y + starty * th * scy) * scaley,
			stepx:Float = tw * scx * scalex,
			stepy:Float = th * scy * scaley,
			tile:Int = 0;

		// adjust scale to fill gaps
		scx = Math.ceil(stepx) / tileWidth;
		scy = Math.ceil(stepy) / tileHeight;

		for (y in starty...desty)
		{
			wx = sx;
			for (x in startx...destx)
			{
				tile = _map[y % _rows][x % _columns];
				if (tile >= 0)
				{
					//Game.spriteBatch.RenderTileScaleColor(texture, Std.int(wx), Std.int(wy), tileWidth, tileHeight,  scx, scy, getClip(tile-1), false, false,_red,_green,_blue,_alpha,blendMode);
					Game.spriteBatch.drawEntitySize(texture, m, getClip(tile-1),tileWidth*scx, tileHeight*scy, Std.int(wx), Std.int(wy), false, false, _red, _green, _blue, _alpha, blendMode);
	
					//Game.spriteBatch.RenderTileBatch( Std.int(wx), Std.int(wy), tileWidth, tileHeight,  scx, scy, new Clip(0,0,32,32), false, false, _red, _green, _blue, _alpha);
					//trace(tile);
					//RenderTileScaleColor( Std.int(wx), Std.int(wy), tileWidth, tileHeight,  scx, scy, getClip(tile-1), false, false, _red, _green, _blue, _alpha);
					
				}
				wx += stepx;
			}
			wy += stepy;
		}

	}

	
public   function RenderTileScaleColor(x:Float,y:Float,width:Float,height:Float,scaleX:Float,scaleY:Float,clip:Clip,flipx:Bool,flipy:Bool,r:Float,g:Float,b:Float,a:Float)
{
	
	





	    var fx:Float = x;
		var fy:Float = y;
		var fx2:Float = x+(width*scaleX) ;
		var fy2:Float = y+(height*scaleY) ;
		
		
		
		
var left, right, top, bottom:Float;

  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;




   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);


				

 if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		

		
vertices.push(fx);
vertices.push(fy);
vertices.push(0);
vertices.push(left);
vertices.push(top);
vertices.push(r);
vertices.push(g);
vertices.push(b);
vertices.push(a);


vertices.push(fx);
vertices.push(fy2);
vertices.push(0);
vertices.push(left);
vertices.push(bottom);
vertices.push(r);
vertices.push(g);
vertices.push(b);
vertices.push(a);


vertices.push(fx2);
vertices.push(fy2);
vertices.push(0);
vertices.push(right);
vertices.push(bottom);
vertices.push(r);
vertices.push(g);
vertices.push(b);
vertices.push(a);

vertices.push(fx2);
vertices.push(fy);
vertices.push(0);
vertices.push(right);
vertices.push(top);
vertices.push(r);
vertices.push(g);
vertices.push(b);
vertices.push(a);

	
	
		
}




	
	/** @private Used by shiftTiles to update a tile from the tilemap. */
	private function updateTile(column:Int, row:Int)
	{
		setTile(column, row, _map[row % _rows][column % _columns]);
	}

	/**
	 * The tile width.
	 */
	public var tileWidth(get, never):Int;
	private inline function get_tileWidth():Int { return Std.int(_tile.width); }

	/**
	 * The tile height.
	 */
	public var tileHeight(get, never):Int;
	private inline function get_tileHeight():Int { return Std.int(_tile.height); }

	/**
	 * The tile horizontal spacing of tile.
	 */
	public var tileSpacingWidth(default, null):Int;

	/**
	 * The tile vertical spacing of tile.
	 */
	public var tileSpacingHeight(default, null):Int;

	/**
	 * How many tiles the tilemap has.
	 */
	public var tileCount(get, never):Int;
	private inline function get_tileCount():Int { return _setCount; }

	/**
	 * How many columns the tilemap has.
	 */
	public var columns(get, null):Int;
	private inline function get_columns():Int { return _columns; }

	/**
	 * How many rows the tilemap has.
	 */
	public var rows(get, null):Int;
	private inline function get_rows():Int { return _rows; }

	// Tilemap information.
	private var _map:Array2D;
	private var _columns:Int;
	private var _rows:Int;
	private var tiles:Array<Clip>;
	private var texture:Texture;
	public var margin:Int=0;
	public var spacing:Int = 0;


	// Tileset information.
	private var _set:BitmapData;
	private var _setColumns:Int;
	private var _setRows:Int;
	private var _setCount:Int;
	private var _tile:Rectangle;
	private var _width:Int;
	private var _height:Int;
	
	private var _rect:Rectangle;
	private var _maxWidth:Int = 4000;
	private var _maxHeight:Int = 4000;

}
