package com.kurst.swfrender.services.render.events
{

	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ContentLoaderEvent extends Event {
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public static const CONTENT_ERROR 		: String = "ContentLoaderEvent_CONTENT_ERROR";
		public static const LOAD_COMPLETE 		: String = "ContentLoaderEvent_LOAD_COMPLETE";
		public static const CONTENT_LOAD_ERROR 	: String = "ContentLoaderEvent_CONTENT_LOAD_ERROR";
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public var message 			: String;
		public var AVM 				: String;
		public var totalFrames 		: int;
		public var contentWidth 	: int;
		public var contentHeight 	: int;
		public var url				: String;
		public var content 			: DisplayObject;
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function ContentLoaderEvent( type : String , bubbles : Boolean = false , cancelable : Boolean = false ) {
			
			super( type , bubbles , cancelable );
			
		}
		
		override public function clone() : Event{
			
			var e : ContentLoaderEvent = new ContentLoaderEvent(type , bubbles , cancelable );
			
				e.message  			= message;
				e.AVM 				= AVM;
				e.content 			= content;
				e.totalFrames 		= totalFrames;
				e.contentWidth 		= contentWidth; 
				e.contentHeight 	= contentHeight;
				e.url				= url;
				
			return e;
			
		}
		
	}
}
