package com.haxepunk.actions;
import com.haxepunk.Entity;

/**
 * ...
 * @author djoekr
 */
class Action
{
	
	private var _actor:Entity;

	public function new() 
	{
		actor = null;
	}
	
	public var actor(get_actor, set_actor):Entity;
	private inline function get_actor():Entity
	{
			return _actor;
	}
	private inline function set_actor(v:Entity):Entity
	{
		return _actor = v;
	}
	
	public function act():Bool
	{
		return false;
	}

	public function start()
	{
		
	}


	
}