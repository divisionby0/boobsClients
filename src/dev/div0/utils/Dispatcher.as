package dev.div0.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Dispatcher implements IEventDispatcher
	{
		private static var instance : EventDispatcher = new EventDispatcher();
		
		public function Dispatcher() {            
			if (instance) {
				throw new Error( "Dispatcher and can only be accessed through Dispatcher.getInstance()" ); 
			}
		}
		
		public static function getInstance() : EventDispatcher {
			return instance;
		}
		
		/* Miembros de flash.events.IEventDispatcher */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, 
										 useWeakReference:Boolean = false):void{
			instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {            
			return instance.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean { 
			return instance.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			instance.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean{
			return instance.willTrigger(type);
		}
	}
}