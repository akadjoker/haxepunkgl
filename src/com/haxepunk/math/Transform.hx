package com.haxepunk.math;

import flash.geom.Matrix;
import com.haxepunk.utils.Util;
import com.haxepunk.HXP;
import openfl.geom.Point;
import openfl.geom.Rectangle;
/**
 * ...
 * @author djoker
 */
class Transform
{
	
	    public static inline var LEFT:String   = "left";
        public static inline var CENTER:String = "center";
        public static inline var RIGHT:String  = "right";
		public static inline var TOP:String    = "top";
        public static inline var BOTTOM:String = "bottom";
		
		
    public var mTransformationMatrix:Matrix;
	public var parent:Transform;
    private static var sHelperRect:Rectangle = new Rectangle();
	private static var sHelperMatrix:Matrix  = new Matrix();
	   
 
	        private var mVisible:Bool;
            private var mTouchable:Bool;
		  private var mOrientationChanged:Bool;

		
		private var mX:Float;
        private var mY:Float;
        private var mPivotX:Float;
        private var mPivotY:Float;
        private var mScaleX:Float;
        private var mScaleY:Float;
        private var mSkewX:Float;
        private var mSkewY:Float;
        private var mRotation:Float;
		private var mAlpha:Float;

		public var scrollFactorX:Float ;
		public var scrollFactorY:Float ;
		
	public function new() 
	{
		parent = null;
		 mX = mY = mPivotX = mPivotY = mRotation = mSkewX = mSkewY = 0.0;
         mScaleX = mScaleY = mAlpha = 1.0;   
		mTransformationMatrix = new Matrix();
		 mVisible = mTouchable = true;
		 mOrientationChanged = false;
		 scrollFactorX = scrollFactorY = 1;
	}
	    /** Removes the object from its parent, if it has one, and optionally disposes it. */
        public function removeFromParent(dispose:Bool=false):Void
        {
           // if (mParent) parent.removeChild(this, dispose);
           // else if (dispose) this.dispose();
        }
		public function setParent(value:Transform):Void 
        {
            // check for a recursion
            var ancestor:Transform = value;
            while (ancestor != this && ancestor != null)
                ancestor = ancestor.parent;
            
            if (ancestor == this)
                throw ("An object cannot be added as a child to itself or one " +
                                        "of its children (or children's children, etc.)");
            else
                parent = value; 
        }
	

		
	public function getTransformationMatrix():Matrix
	{
		
	
			
		 if (mOrientationChanged)
            {
                mOrientationChanged = false;
                
			
                if (mSkewX == 0.0 && mSkewY == 0.0)
                {
                    // optimization: no skewing / rotation simplifies the matrix math
                    
                    if (mRotation == 0.0)
                    {
                        mTransformationMatrix.setTo(mScaleX, 0.0, 0.0, mScaleY, 
                            mX - mPivotX * mScaleX, mY - mPivotY * mScaleY);
                    }
                    else
                    {
                        var cos:Float = Math.cos(mRotation);
                        var sin:Float = Math.sin(mRotation);
                        var a:Float   = mScaleX *  cos;
                        var b:Float   = mScaleX *  sin;
                        var c:Float   = mScaleY * -sin;
                        var d:Float   = mScaleY *  cos;
                        var tx:Float  = mX - mPivotX * a - mPivotY * c;
                        var ty:Float  = mY - mPivotX * b - mPivotY * d;
                        
                        mTransformationMatrix.setTo(a, b, c, d, tx, ty);
                    }
                }
                else
                {
                    mTransformationMatrix.identity();
                    mTransformationMatrix.scale(mScaleX, mScaleY);
                    Util.skew(mTransformationMatrix, mSkewX, mSkewY);
                    mTransformationMatrix.rotate(mRotation);
                    mTransformationMatrix.translate(mX, mY);
                    
                    if (mPivotX != 0.0 || mPivotY != 0.0)
                    {
                        // prepend pivot transformation
                        mTransformationMatrix.tx = mX - mTransformationMatrix.a * mPivotX
                                                      - mTransformationMatrix.c * mPivotY;
                        mTransformationMatrix.ty = mY - mTransformationMatrix.b * mPivotX 
                                                      - mTransformationMatrix.d * mPivotY;
                    }
                }
				
            }
            
            return mTransformationMatrix;
	/*
		   mTransformationMatrix.identity();
	
				
			var cx:Float =  HXP.camera.x;
			var cy:Float =  HXP.camera.x;
			var sx:Float = x - cx * scrollFactorX;
			var sy:Float = y - cy * scrollFactorY;
			
         
                if (scaleX != 1.0 || scaleY != 1.0) mTransformationMatrix.scale(scaleX, scaleY);
                if (skewX  != 0.0 || skewY  != 0.0) Util.skew(mTransformationMatrix, skewX*HXP.RAD, skewY*HXP.RAD);
                if (rotation != 0.0)                 mTransformationMatrix.rotate(rotation*HXP.RAD);
                if (sx != 0.0 || sy != 0.0)          mTransformationMatrix.translate(sx, sy);
                
                if (pivotX != 0.0 || pivotY != 0.0)
                {
                    mTransformationMatrix.tx = sx - mTransformationMatrix.a * pivotX
                                                  - mTransformationMatrix.c * pivotY;
                    mTransformationMatrix.ty = sy - mTransformationMatrix.b * pivotX 
                                                  - mTransformationMatrix.d * pivotY;
                }
            return mTransformationMatrix;
		*/
	}
	  
	 /** Returns a rectangle that completely encloses the object as it appears in another 
         *  coordinate system. If you pass a 'resultRectangle', the result will be stored in this 
         *  rectangle instead of creating a new object. */ 
        public function getBounds():Rectangle
        {
            throw "override me";
            return null;
        }
		
		  /** Returns the object that is found topmost beneath a point in local coordinates, or nil if 
         *  the test fails. If "forTouch" is true, untouchable and invisible objects will cause
         *  the test to fail. */
        public function hitTest(localPoint:Point, forTouch:Bool=false):Transform
        {
            // on a touch test, invisible or untouchable objects cause the test to fail
            if (forTouch && (!mVisible || !mTouchable)) return null;
            
            // otherwise, check bounding box
            if (getBounds().containsPoint(localPoint)) return this;
            else return null;
        }
		
		  /** Transforms a point from the local coordinate system to global (stage) coordinates.
         *  If you pass a 'resultPoint', the result will be stored in this point instead of 
         *  creating a new object. */
        public function localToGlobal(localPoint:Point, resultPoint:Point=null):Point
        {
            sHelperMatrix=getTransformationMatrix();
            return Util.transformCoords(sHelperMatrix, localPoint.x, localPoint.y, resultPoint);
        }
        
        /** Transforms a point from global (stage) coordinates to the local coordinate system.
         *  If you pass a 'resultPoint', the result will be stored in this point instead of 
         *  creating a new object. */
        public function globalToLocal(globalPoint:Point, resultPoint:Point=null):Point
        {
            sHelperMatrix=getTransformationMatrix();
            sHelperMatrix.invert();
            return Util.transformCoords(sHelperMatrix, globalPoint.x, globalPoint.y, resultPoint);
        }
	public function getLocalToWorldMatrix():Matrix
    {
            if (parent == null)
            {
            return  getTransformationMatrix();
            }
           	else
            {
			return  getTransformationMatrix().mult(parent.getTransformationMatrix());
            }
            
       
    }
	   /** Moves the pivot point to a certain position within the local coordinate system
         *  of the object. If you pass no arguments, it will be centered. */ 
        public function alignPivot(hAlign:String="center", vAlign:String="center"):Void
        {
            var bounds:Rectangle = getBounds();
            mOrientationChanged = true;
            
            if (hAlign == Transform.LEFT)        pivotX = bounds.x;
            else if (hAlign == Transform.CENTER) pivotX = bounds.x + bounds.width / 2.0;
            else if (hAlign == Transform.RIGHT)  pivotX = bounds.x + bounds.width; 
            else throw ("Invalid horizontal alignment: " + hAlign);
            
            if (vAlign == Transform.TOP)         pivotY = bounds.y;
            else if (vAlign == Transform.CENTER) pivotY = bounds.y + bounds.height / 2.0;
            else if (vAlign == Transform.BOTTOM) pivotY = bounds.y + bounds.height;
            else throw ("Invalid vertical alignment: " + vAlign);
        }
	public function dispose()
	{
		this.mTransformationMatrix = null;
		
	}
	
    public var x(get_x, set_x):Float;
	private inline function get_x():Float
	{
			return mX;
	}
	private inline function set_x(v:Float):Float
	{
		 if (mX != v)
            {
                mX = v;
                mOrientationChanged = true;
            }
			return  v;
	}
	
		
    public var y(get_y, set_y):Float;
	private inline function get_y():Float
	{
			return mY;
	}
	private inline function set_y(v:Float):Float
	{
		 if (mY != v)
            {
                mY = v;
                mOrientationChanged = true;
            }
			return  v;
	}
	//**************************************************
	/**
	 * X center of the Entity's rotation.
	 */
	
	public var pivotX(get_pivotX, set_pivotX):Float;
	private inline function get_pivotX():Float
	{
			return mPivotX;
	}
	private inline function set_pivotX(v:Float):Float
	{
		 if (mPivotX != v)
            {
                mPivotX = v;
                mOrientationChanged = true;
            }
			return  v;
	}
	//**************************************************
	/**
	 * Y center of the Entity's rotation.
	 */
	public var pivotY(get_pivotY, set_pivotY):Float;
	private inline function get_pivotY():Float
	{
			return mPivotY;
	}
	private inline function set_pivotY(v:Float):Float
	{
		 if (mPivotY != v)
            {
                mPivotY = v;
                mOrientationChanged = true;
            }
				return  v;
	}
		//**************************************************
	
	public var scaleX(get_scaleX, set_scaleX):Float;
	private inline function get_scaleX():Float
	{
			return mScaleX;
	}
	private inline function set_scaleX(v:Float):Float
	{
		    if (mScaleX != v)
            {
                mScaleX = v;
                mOrientationChanged = true;
            }
				return  v;
	}
	//**************************************************
	
	public var scaleY(get_scaleY, set_scaleY):Float;
	private inline function get_scaleY():Float
	{
			return mScaleY;
	}
	private inline function set_scaleY(v:Float):Float
	{
		    if (mScaleY != v)
            {
                mScaleY = v;
                mOrientationChanged = true;
            }
				return  v;
	}
	
		//**************************************************
	
	public var skewX(get_skewX, set_skewX):Float;
	private inline function get_skewX():Float
	{
			return mSkewX;
	}
	private inline function set_skewX(v:Float):Float
	{
		v = Util.normalizeAngle(v);
		
		    if (mSkewX != v)
            {
                mSkewX = v;
                mOrientationChanged = true;
            }
				return  v;
	}
		
		//**************************************************
	
	public var skewY(get_skewY, set_skewY):Float;
	private inline function get_skewY():Float
	{
			return mSkewY;
	}
	private inline function set_skewY(v:Float):Float
	{
		v = Util.normalizeAngle(v);
		    if (mSkewY != v)
            {
                mSkewY = v;
                mOrientationChanged = true;
            }
				return  v;
	}
			//**************************************************
	
	public var rotation(get_rotation, set_rotation):Float;
	private inline function get_rotation():Float
	{
			return mRotation;
	}
	private inline function set_rotation(v:Float):Float
	{
		v = Util.normalizeAngle(v);
		    if (mRotation != v)
            {
                mRotation = v;
                mOrientationChanged = true;
            }
				return  v;
	}
				//**************************************************
	
	public var visible(get_visible, set_visible):Bool;
	private inline function get_visible():Bool
	{
			return mVisible;
	}
	private inline function set_visible(v:Bool):Bool
	{
		return mVisible = v;
	}
	//**************************************************
	
	public var touchable(get_touchable, set_touchable):Bool;
	private inline function get_touchable():Bool
	{
			return mTouchable;
	}
	private inline function set_touchable(v:Bool):Bool
	{
		return mTouchable = v;
	}
}