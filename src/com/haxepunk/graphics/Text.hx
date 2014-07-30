package com.haxepunk.graphics;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import openfl.geom.Matrix;
import openfl.geom.Point;
using com.haxepunk.graphics.Font;
/**
 * ...
 * @author djoekr
 */
class Text extends Graphic
{

	private var dirty:Bool = false;
	
 /** The text being displayed. Can contain contain newline characters (\n) for multiline text. */
    public var text (get, set) :String;

    /** The font used to display the text. */
    public var font (get, set) :Font;

    /**
     * The maximum available width of this text before word wrapping to a new line. Defaults to 0
     * (no word wrapping).
     */
    public var wrapWidth:Float=0;

    /**
     * Additional horizontal space to apply between letters, in pixels. Defaults to 0. Positive
     * values make text look "looser", negative values look "tighter".
     */
    public var letterSpacing:Float = 0;

    /**
     * Additional vertical space to apply between lines, in pixels. Defaults to 0. Positive values
     * make lines look "looser", negative values look "tighter".
     */
    public var lineSpacing :Float = 0;

    /**
     * The horizontal text alignment, for multiline text. Left by default.
     */
    public var align (get, set) :TextAlign;

    public function new (font :String, ?text :String = "text")
    {
        super();
        _font = new Font(font);
        _text = text;
        _align = Left;
        dirty = true;
    }
	
	override public function render(m:Matrix, point:Point, camera:Point)
	{
		 updateLayout();
		 
		 _point.x = Math.floor(point.x + x - camera.x * scrollX);
		 _point.y = Math.floor(point.y + y - camera.y * scrollY);
		
		 _layout.draw(m,_point);
	}
/*
    override public function draw (g :Graphics)
    {
        updateLayout();


        // Draw the bounding boxes for debugging
//        g.fillRect(0xff0000, 0, 0, getNaturalWidth(), getNaturalHeight());
 //       g.fillRect(0x00ff00, _layout.bounds.x, _layout.bounds.y, _layout.bounds.width, _layout.bounds.height);

        _layout.draw(g);
    }
*/
     public function getNaturalWidth () :Float
    {
        updateLayout();
        return (wrapWidth > 0) ? wrapWidth : _layout.bounds.width;
    }

     public function getNaturalHeight () :Float
    {
        updateLayout();
        var paddedHeight = _layout.lines * (_font.lineHeight+lineSpacing);
        var boundsHeight = _layout.bounds.height;
        return Math.max(paddedHeight, boundsHeight);
    }

     public function containsLocal (localX :Float, localY :Float) :Bool
    {
        updateLayout();
        return _layout.bounds.contains(localX, localY);
    }

    /**
     * Chainable convenience method to set the wrap width.
     * @returns This instance, for chaining.
     */
    public function setWrapWidth (wrapWidth :Float) :Text
    {
        this.wrapWidth = wrapWidth;
        return this;
    }

    /**
     * Chainable convenience method to set the letter spacing.
     * @returns This instance, for chaining.
     */
    public function setLetterSpacing (letterSpacing :Float) :Text
    {
        this.letterSpacing = letterSpacing;
        return this;
    }

    /**
     * Chainable convenience method to set the line spacing.
     * @returns This instance, for chaining.
     */
    public function setLineSpacing (lineSpacing :Float) :Text
    {
        this.lineSpacing = lineSpacing;
        return this;
    }

    /**
     * Chainable convenience method to set the text alignment.
     * @returns This instance, for chaining.
     */
    public function setAlign (align :TextAlign) :Text
    {
        this.align = align;
        return this;
    }

    inline private function get_text () :String
    {
        return _text;
    }

    private function set_text (text :String) :String
    {
        if (text != _text) 
		{
            _text = text;
        dirty = true;
        }
        return text;
    }

    inline private function get_font () :Font
    {
        return _font;
    }

    private function set_font (font :Font) :Font
    {
        if (font != _font) {
            _font = font;
         dirty = true;
        }
        return font;
    }

    inline private function get_align () :TextAlign
    {
        return _align;
    }

    private function set_align (align :TextAlign) :TextAlign
    {
        if (align != _align) {
            _align = align;
         dirty = true;
        }
        return align;
    }

    private function updateLayout ()
    {


        // Recreate the layout if necessary
        if (dirty = true) 
		{
                    _layout = font.layoutText(_text, _align, wrapWidth, letterSpacing, lineSpacing);
					dirty = false;
        }
    }


    private var _font :Font;
    private var _text :String;
    private var _align :TextAlign;
    private var _layout :TextLayout = null;

}
