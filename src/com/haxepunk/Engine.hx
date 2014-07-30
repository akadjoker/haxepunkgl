package com.haxepunk;

import com.haxepunk.gl.SpriteBatch;
import com.haxepunk.state.BasicGameState;
import com.haxepunk.state.GameState;
import com.haxepunk.state.transition.EmptyTransition;
import com.haxepunk.state.transition.Transition;
import openfl.display.OpenGLView;
import openfl.gl.GL;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import haxe.EnumFlags;
import haxe.Timer;

import com.haxepunk.gl.Game;
import com.haxepunk.gl.filter.Filter;
import com.haxepunk.utils.Input;
import com.haxepunk.Tweener;


import openfl.display.OpenGLView;
/**
 * Main game Sprite class, added to the Flash Stage. Manages the game loop.
 */
class Engine extends Sprite
{
	
	public var game:Game;
	/**
	 * If the game should stop updating/rendering.
	 */
	public var paused:Bool;

	/**
	 * Cap on the elapsed time (default at 30 FPS). Raise this to allow for lower framerates (eg. 1 / 10).
	 */
	public var maxElapsed:Float;

	/**
	 * The max amount of frames that can be skipped in fixed framerate mode.
	 */
	public var maxFrameSkip:Int;

	/**
	 * The amount of milliseconds between ticks in fixed framerate mode.
	 */
	public var tickRate:Int;

	/**
	 * Constructor. Defines startup information about your game.
	 * @param	width			The width of your game.
	 * @param	height			The height of your game.
	 * @param	frameRate		The game framerate, in frames per second.
	 * @param	fixed			If a fixed-framerate should be used.
	 * @param   renderMode      Overrides the default render mode for this target
	 */
	public function new(width:Int = 0, height:Int = 0, frameRate:Float = 60, fixed:Bool = false)
	{
		super();
		
		
		states = new  Map<Int,BasicGameState>();

		currentState = new BasicGameState();
		HXP.scene = currentState;
		

		// global game properties
		HXP.bounds = new Rectangle(0, 0, width, height);
		HXP.assignedFrameRate = frameRate;
		HXP.fixed = fixed;

		// global game objects
		HXP.engine = this;
		HXP.width = width;
		HXP.height = height;

		if (HXP.screen == null)
			HXP.screen = new Screen();
		else
			HXP.screen.init();

		// miscellaneous startup stuff
		if (HXP.randomSeed == 0) HXP.randomizeSeed();

		HXP.entity = new Entity();
		HXP.time = Lib.getTimer();

		paused = false;
		maxElapsed = 0.0333;
		maxFrameSkip = 5;
		tickRate = 4;
		_frameList = new Array<Int>();
		_systemTime = _delta = _frameListSum = 0;
		_frameLast = 0;

		 game = new Game(renderView);
   
		// on-stage event listener

		addEventListener(Event.ADDED_TO_STAGE, onStage);
		Lib.current.addChild(this);


  
	}
	
/**
	 * Get the number of states that have been added to this game
	 * 
	 * @return The number of states that have been added to this game
	 */
	public function getStateCount():Int 
	{
		var i:Int = 0;
		 for ( key in states.keys())
		 {
			 i++;
		 }
		 return i;
	}
	
/**
	 * Get the ID of the state the game is currently in
	 * 
	 * @return The ID of the state the game is currently in
	 */
	public function getCurrentStateID() :Int
	{
		return currentState.getID();
	}
	
	/**
	 * Get the state the game is currently in
	 * 
	 * @return The state the game is currently in
	 */
	public function getCurrentState() :GameState
	{
		return currentState;
	}
	
	/**
	 * Add a state to the game. The state will be updated and maintained
	 * by the game
	 * 
	 * @param state The state to be added
	 */
	public function addState( state:BasicGameState) 
	{
	
		states.set(state.getID(), state);
		
		if (currentState.getID() == -1) 
		{
			currentState = state;
		}
	}
		/**
	 * Get a state based on it's identifier
	 * 
	 * @param id The ID of the state to retrieve
	 * @return The state requested or null if no state with the specified ID exists
	 */
	public function  getState(id:Int):BasicGameState 
	{
		return states.get(id) ;
	}
		/**
	 * Enter a particular game state with no transition
	 * 
	 * @param id The ID of the state to enter
	 */
	public function enterState( id:Int) 
	{
		enterStateTransition(id, new EmptyTransition(), new EmptyTransition());
	}
	
	
	/**
	 * Enter a particular game state with the transitions provided
	 * 
	 * @param id The ID of the state to enter
	 * @param leave The transition to use when leaving the current state
	 * @param enter The transition to use when entering the new state
	 */
	public function enterStateTransition( id:Int,  leave:Transition,  enter:Transition) :Void
	{
		if (leave == null) 
		{
			leave = new EmptyTransition();
		}
		if (enter == null)
		{
			enter = new EmptyTransition();
		}
		leaveTransition = leave;
		enterTransition = enter;
		
		nextState = getState(id);
		if (nextState == null) 
		{
			throw ("No game state registered with the ID: "+id);
		}
		
		leaveTransition.init(currentState, nextState);
	}
	
	/**
	 * Initialise the list of states making up this game
	 * 
	 * @param container The container holding the game
	 * @throws SlickException Indicates a failure to initialise the state based game resources
	 */
	public function initStatesList( ):Void
	{
		
	}	

	
	
private function renderView(rect:Rectangle):Void 
{ 
	
    GL.clearColor(0,0,0.4, 1);
    GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	

	if (HXP.screen.needsResize) 
	{
	 Game.camera.resize(rect, HXP.width, HXP.height);
	}



Game.camera.update();
 
	

EnterFrame();

	
 GL.disableVertexAttribArray (Filter.vertexAttribute);
 GL.disableVertexAttribArray (Filter.texCoordAttribute);
 GL.disableVertexAttribArray (Filter.colorAttribute);	
 GL.bindBuffer (GL.ARRAY_BUFFER, null);	
 GL.useProgram (null);	
 GL.blendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );	
 
}
	
	/**
	 * Override this, called after Engine has been added to the stage.
	 */
	public function init() 
	{ 
		
		
		initStatesList();
		
		 for (state in states.iterator())
		 {
			 state.init();
			 
		 }
		
		if (currentState != null) 
		{
			currentState.enter();
		}
		
		
	}
	
	private function transitioning() :Bool
	{
		return (leaveTransition != null) || (enterTransition != null);
	}

	/**
	 * Override this, called when game gains focus
	 */
	public function focusGained() { }

	/**
	 * Override this, called when game loses focus
	 */
	public function focusLost() { }

	/**
	 * Updates the game, updating the Scene and Entities.
	 */
	public function update()
	{
		
		
		if (leaveTransition != null) 
		{
			leaveTransition.update(  HXP.elapsed*1000);
			if (leaveTransition.isComplete()) 
			{
			    currentState.clear();
				currentState.leave();
				currentState.reset();
				var  prevState:BasicGameState = currentState;
				currentState = nextState;
				leaveTransition.end();
				nextState = null;
				leaveTransition = null;
				currentState.enter();
			} else
			{
				return;
			}
		}
		
		if (enterTransition != null) 
		{
			enterTransition.update(  HXP.elapsed*1000);
			if (enterTransition.isComplete()) 
			{
				enterTransition.end();
				currentState.reset();
				enterTransition = null;
			} else 
			{
				return;
			}
		}
		
		HXP.scene = currentState;
		currentState.updateLists();
		if (HXP.tweener.active && HXP.tweener.hasTween) HXP.tweener.updateTweens();
		if (	currentState.active)
		{
			if (currentState.hasTween) currentState.updateTweens();
			currentState.update();
		}
			currentState.updateLists(false);
		
	
		 
	}

	/**
	 * Renders the game, rendering the Scene and Entities.
	 */
	public function render()
	{

	
		if (HXP.screen.needsResize) HXP.resize(HXP.windowWidth, HXP.windowHeight);

		// timing stuff
		var t:Float = Lib.getTimer();
		if (_frameLast == 0) _frameLast = Std.int(t);
		
		SpriteBatch.numVertx = 0;
		SpriteBatch.numTris = 0;
		SpriteBatch.numTex = 0;
	    SpriteBatch.numBlend = 0;
		 

		// render loop
		  currentState.preRender();
		  Game.spriteBatch.Begin();
		  currentState.preRenderBatch(Game.spriteBatch);
		  currentState.render();
		  currentState.postRenderBatch(Game.spriteBatch);
		  
		  if (leaveTransition != null) 
		{
			leaveTransition.RenderLines(Game.lines);
		} else if (enterTransition != null) 
		{
			enterTransition.RenderLines(Game.lines);
		}
		
          Game.spriteBatch.End();
		  currentState.postRender();
		  
		
	    Game.lines.begin();
		  currentState.renderEntityLines();
		  currentState.renderFades();
		  
		if (leaveTransition != null) 
		{
			leaveTransition.RenderLines(Game.lines);
		} else if (enterTransition != null) 
		{
			enterTransition.RenderLines(Game.lines);
		}
		
		Game.lines.end();
		


       HXP.scene.updateCamera();
		

		// more timing stuff
		t = Lib.getTimer();
		_frameListSum += (_frameList[_frameList.length] = Std.int(t - _frameLast));
		if (_frameList.length > 10) _frameListSum -= _frameList.shift();
		HXP.frameRate = 1000 / (_frameListSum / _frameList.length);
		_frameLast = t;
	}

	/**
	 * Sets the game's stage properties. Override this to set them differently.
	 */
	private function setStageProperties()
	{
		

		HXP.stage.frameRate = HXP.assignedFrameRate;
		HXP.stage.align = StageAlign.TOP_LEFT;
		#if !js
		HXP.stage.quality = StageQuality.HIGH;
		#end
		

		HXP.stage.scaleMode = StageScaleMode.NO_SCALE;
		HXP.stage.displayState = StageDisplayState.NORMAL;
		HXP.windowWidth = HXP.stage.stageWidth;
		HXP.windowHeight = HXP.stage.stageHeight;


		resize(); // call resize once to initialize the screen

		// set resize event
		HXP.stage.addEventListener(Event.RESIZE, function (e:Event) {
			resize();
		});

		HXP.stage.addEventListener(Event.ACTIVATE, function (e:Event) {
			HXP.focused = true;
			focusGained();
			HXP.scene.focusGained();
		});

		HXP.stage.addEventListener(Event.DEACTIVATE, function (e:Event) {
			HXP.focused = false;
			focusLost();
			HXP.scene.focusLost();
		});

#if !(flash || html5)
		flash.display.Stage.shouldRotateInterface = function(orientation:Int):Bool {
			if (HXP.indexOf(HXP.orientations, orientation) == -1) return false;
			var tmp = HXP.height;
			HXP.height = HXP.width;
			HXP.width = tmp;
			resize();
			return true;
		}
#end
	}

	/** @private Event handler for stage resize */
	private function resize()
	{
		if (HXP.width == 0)  HXP.width = HXP.stage.stageWidth;
		if (HXP.height == 0) HXP.height = HXP.stage.stageHeight;
		// calculate scale from width/height values
		HXP.windowWidth = HXP.stage.stageWidth;
		HXP.windowHeight = HXP.stage.stageHeight;
		HXP.screen.scaleX = HXP.stage.stageWidth / HXP.width;
		HXP.screen.scaleY = HXP.stage.stageHeight / HXP.height;
		HXP.resize(HXP.stage.stageWidth, HXP.stage.stageHeight);
		HXP.screen.needsResize = true;
	}

	/** @private Event handler for stage entry. */
	private function onStage(e:Event = null)
	{
		
		// remove event listener

		removeEventListener(Event.ADDED_TO_STAGE, onStage);
		HXP.stage = stage;


		setStageProperties();


		HXP.stage = Lib.current.stage;
		// enable input
		Input.enable();

		// switch scenes
		if (!HXP.gotoIsNull()) checkScene();


		
		// game start

		init();

		// start game loop
		_rate = 1000 / HXP.assignedFrameRate;
		if (HXP.fixed)
		{
			// fixed framerate
			_skip = _rate * (maxFrameSkip + 1);
			_last = _prev = Lib.getTimer();
			_timer = new Timer(tickRate);
			_timer.run = onTimer;
		}
		else
		{
			// nonfixed framerate
			_last = Lib.getTimer();
		//	addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		
        addChild(game);
	}

	/** @private Framerate independent game loop. */
	private function onEnterFrame(e:Event)
	{
		
		// update timer
		_time = _gameTime = Lib.getTimer();
		HXP._systemTime = _time - _systemTime;
		_updateTime = _time;
		HXP.elapsed = (_time - _last) / 1000;
		if (HXP.elapsed > maxElapsed) HXP.elapsed = maxElapsed;
		HXP.elapsed *= HXP.rate;
		_last = _time;

		// update loop
		if (!paused) update();

		// update input
		Input.update();

		// update timer
		_time = _renderTime = Lib.getTimer();
		HXP._updateTime = _time - _updateTime;

		// render loop
		if (paused) _frameLast = _time; // continue updating frame timer
		//if (paused) _frameLast = _time; // continue updating frame timer
		//else render();

		// update timer
		_time = _systemTime = Lib.getTimer();
		HXP._renderTime = _time - _renderTime;
		HXP._gameTime = _time - _gameTime;
	}

	
	private function EnterFrame()
	{
		
		// update timer
		_time = _gameTime = Lib.getTimer();
		HXP._systemTime = _time - _systemTime;
		_updateTime = _time;
		HXP.elapsed = (_time - _last) / 1000;
		if (HXP.elapsed > maxElapsed) HXP.elapsed = maxElapsed;
		HXP.elapsed *= HXP.rate;
		_last = _time;

		// update loop
		if (!paused) update();

	
		// update input
		Input.update();

		// update timer
		_time = _renderTime = Lib.getTimer();
		HXP._updateTime = _time - _updateTime;

		// render loop
		//if (paused) _frameLast = _time; // continue updating frame timer
		if (paused) _frameLast = _time; // continue updating frame timer
		else render();

		// update timer
		_time = _systemTime = Lib.getTimer();
		HXP._renderTime = _time - _renderTime;
		HXP._gameTime = _time - _gameTime;
	}
	
	
	/** @private Fixed framerate game loop. */
	private function onTimer()
	{
		// update timer
		_time = Lib.getTimer();
		_delta += (_time - _last);
		_last = _time;

		// quit if a frame hasn't passed
		if (_delta < _rate) return;

		// update timer
		_gameTime = Std.int(_time);
		HXP._systemTime = _time - _systemTime;

		// update loop
		if (_delta > _skip) _delta = _skip;
		while (_delta >= _rate)
		{
			HXP.elapsed = _rate * HXP.rate * 0.001;

			// update timer
			_updateTime = _time;
			_delta -= _rate;
			_prev = _time;

			// update loop
			if (!paused) update();

	
			// update input
			Input.update();

			// update timer
			_time = Lib.getTimer();
			HXP._updateTime = _time - _updateTime;
		}

		// update timer
		_renderTime = _time;

		// render loop
		//if (!paused) render();

		// update timer
		_time = _systemTime = Lib.getTimer();
		HXP._renderTime = _time - _renderTime;
		HXP._gameTime =  _time - _gameTime;
	}

	/** @private Switch scenes if they've changed. */
	private function checkScene()
	{
		if (HXP.gotoIsNull()) return;

		if (HXP.scene != null)
		{
			HXP.scene.end();
			HXP.scene.updateLists();
			if (HXP.scene.autoClear && HXP.scene.hasTween) HXP.scene.clearTweens();
			if (contains(HXP.scene.sprite)) removeChild(HXP.scene.sprite);
			HXP.swapScene();
			addChild(HXP.scene.sprite);
			HXP.camera = HXP.scene.camera;
			HXP.scene.updateLists();
			HXP.scene.begin();
			HXP.scene.updateLists();
		}
	}

	// Timing information.
	private var _delta:Float;
	private var _time:Float;
	private var _last:Float;
	private var _timer:Timer;
	private var	_rate:Float;
	private var	_skip:Float;
	private var _prev:Float;

	// Debug timing information.
	private var _updateTime:Float;
	private var _renderTime:Float;
	private var _gameTime:Float;
	private var _systemTime:Float;

	// FrameRate tracking.
	private var _frameLast:Float;
	private var _frameListSum:Int;
	private var _frameList:Array<Int>;
	
	
		/** The current state */
	public var currentState:BasicGameState;
	/** The next state we're moving into */
	private var nextState:BasicGameState;
	/** The title of the game */	
	private var states:Map<Int,BasicGameState>;
	private var title:String;

		
	/** The transition being used to enter the state */
	private var enterTransition:Transition;
	/** The transition being used to leave the state */
	private var leaveTransition:Transition;
	
}
