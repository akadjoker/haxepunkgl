package com.haxepunk.gui;

import com.haxepunk.gl.Clip;
import com.haxepunk.gl.Texture;
import com.haxepunk.Graphic;
import com.haxepunk.gui.Control;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import openfl.geom.Matrix;

import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author AClockWorkLemon
 */
class NineSlice extends Graphic
{
	private var _skin:Texture;
	
	private var _topLeft:UiImage;
	private var _topCenter:UiImage;
	private var _topRight:UiImage;
	private var _centerLeft:UiImage;
	private var _centerCenter:UiImage;
	private var _centerRight:UiImage;
	private var _bottomLeft:UiImage;
	private var _bottomCenter:UiImage;
	private var _bottomRight:UiImage;
	
	private var _xScale:Float;
	private var _yScale:Float;
	
	private var _clipRect:Clip;
	
	private var width:Float;
	private var height:Float;
	
	/**
	 * Constructor. Initiates the class
	 * @param	width		Initial Width of the 9slice
	 * @param	height		Initial Height of the 9slice
	 * @param	clipRect	Rectangle of the area on the skin to use
	 * @param	gridSize	Grid spacing to use when chopping
	 * @param	skin		optional custom skin
	 */
	public function new(width:Float, height:Float, ?clipRect:Clip, ?skin:Texture)
	{
		super();
		_skin = (skin != null) ? skin : Control.defaultSkin;
	
		this.width = width;
		this.height = height;
		
		if (clipRect == null) clipRect = new Clip(0, 0, 1, 1);
		_clipRect = clipRect;
		
		_topLeft      = new UiImage(_skin, new Clip(clipRect.x                     , clipRect.y                      , clipRect.width, clipRect.height));
		_topCenter    = new UiImage(_skin, new Clip(clipRect.x + clipRect.width    , clipRect.y                      , clipRect.width, clipRect.height));
		_topRight     = new UiImage(_skin, new Clip(clipRect.x + clipRect.width * 2, clipRect.y                      , clipRect.width, clipRect.height));
		_centerLeft   = new UiImage(_skin, new Clip(clipRect.x                     , clipRect.y + clipRect.height    , clipRect.width, clipRect.height));
		_centerCenter = new UiImage(_skin, new Clip(clipRect.x + clipRect.width    , clipRect.y + clipRect.height    , clipRect.width, clipRect.height));
		_centerRight  = new UiImage(_skin, new Clip(clipRect.x + clipRect.width * 2, clipRect.y + clipRect.height    , clipRect.width, clipRect.height));
		_bottomLeft   = new UiImage(_skin, new Clip(clipRect.x                     , clipRect.y + clipRect.height * 2, clipRect.width, clipRect.height));
		_bottomCenter = new UiImage(_skin, new Clip(clipRect.x + clipRect.width    , clipRect.y + clipRect.height * 2, clipRect.width, clipRect.height));
		_bottomRight  = new UiImage(_skin, new Clip(clipRect.x + clipRect.width * 2, clipRect.y + clipRect.height * 2, clipRect.width, clipRect.height));
	}
	
	/**
	 * Updates the Image. Make sure to set graphic = output image afterwards.
	 * @param	width	New width
	 * @param	height	New height
	 * @return
	 */
	override public function render(m:Matrix,point:Point, camera:Point)
	{
		
		if (width  < _clipRect.width * 2)  width  = _clipRect.width * 2;
		if (height < _clipRect.height * 2) height = _clipRect.height * 2;
		
		_xScale = (width - _clipRect.width * 2) / _clipRect.width;
		_yScale = (height - _clipRect.height * 2) / _clipRect.height;
		
		_topCenter.scaleX = _xScale;
		_centerLeft.scaleY = _yScale;
		_centerCenter.scaleX = _xScale;
		_centerCenter.scaleY = _yScale;
		_centerRight.scaleY = _yScale;
		_bottomCenter.scaleX = _xScale;
		
		// half
		var hw = _clipRect.width / 2;
		var hh = _clipRect.height / 2;
		// half-scaled
		var hsw = (_clipRect.width + (_xScale * _clipRect.width)) / 2;
		var hsh = (_clipRect.height + (_yScale * _clipRect.height)) / 2;
		
		_topCenter.x    = hw;
		_topRight.x     = hsw;
		_centerLeft.y   = hh;
		_centerCenter.x = hw;
		_centerCenter.y = hh;
		_centerRight.x  = hsw;
		_centerRight.y  = hh;
		_bottomLeft.y   = hsh;
		_bottomCenter.x = hw;
		_bottomCenter.y = hsh;
		_bottomRight.x  = hsw;
		_bottomRight.y  = hsh;
		
		_topLeft.render(m, new Point(_topLeft.x + point.x, _topLeft.y + point.y), camera);
		_topCenter.render(m, new Point(_topCenter.x + point.x, _topCenter.y + point.y), camera);
		_topRight.render(m, new Point(_topRight.x + point.x, _topRight.y + point.y), camera);
		_centerLeft.render(m, new Point(_centerLeft.x + point.x, _centerLeft.y + point.y), camera);
		_centerCenter.render(m, new Point(_centerCenter.x + point.x, _centerCenter.y + point.y), camera);
		_centerRight.render(m, new Point(_centerRight.x + point.x, _centerRight.y + point.y), camera);
		_bottomLeft.render(m, new Point(_bottomLeft.x + point.x, _bottomLeft.y + point.y), camera);
		_bottomCenter.render(m, new Point(_bottomCenter.x + point.x, _bottomCenter.y + point.y), camera);
		_bottomRight.render(m, new Point(_bottomRight.x + point.x, _bottomRight.y + point.y), camera);
		
	}
	
}