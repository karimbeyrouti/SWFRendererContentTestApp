/********************************************************************************************************************************************************************************
* 
* Class Name  	: com.innovid.app.swfrender.exporter.ultils.ContentLoader
* Version 	  	: 1
* Description 	: Content Loader / Load SWF file for SwfToPNG
* 
********************************************************************************************************************************************************************************
* 
* Author 		: Karim Beyrouti
* 
********************************************************************************************************************************************************************************
* 
* METHODS
* 
* 	loadContent( file : File )
* 	unloadContent()
*
* EVENTS
* 
* 	com.innovid.swfrender.events.ContentLoaderEvent.LOAD_COMPLETE
* 	com.innovid.swfrender.events.ContentLoaderEvent.CONTENT_ERROR
* 	com.innovid.swfrender.events.ContentLoaderEvent.CONTENT_LOAD_ERROR
* 
 **********************************************************************************************************************************************************************************/
package com.kurst.swfrender.services.render.utils
{

	import com.kurst.swfrender.services.render.events.ContentLoaderEvent;
	import com.kurst.swfrender.services.render.settings.AvmProps;

	import flash.display.ActionScriptVersion;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class SWFContentLoader extends EventDispatcher {

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var loader 					: Loader; 			// SWF content loader
		private var _contentUrl				: String;			// Target file to load
		private var loaderContext			: LoaderContext;
		private var urlStream				: URLStream;
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function SWFContentLoader() {
		
			super();
		
			loaderContext 						= new LoaderContext();
   			loaderContext.allowCodeImport 		= true;
   			loaderContext.checkPolicyFile 		= false;
			loaderContext.applicationDomain		= new ApplicationDomain( ApplicationDomain.currentDomain );
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PUBLIC-----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		/**
		 *  
		 * loadContent( file : File ) : void 
		 * 
		 * Load content to process 
		 *  
		 * @param file : File - File to load
		 */
		public function loadContent( file : File ) : void 
		{
			loadURL( file.url );
		}
		/**
		 */
		public function loadURL( url : String ) : void
		{
			disposeContent();			
			
			_contentUrl 	= url;
		 	loader 			= new Loader(); 
			
		 	loader.contentLoaderInfo.addEventListener( Event.COMPLETE , loadComplete , false ,0 , true );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR , ioError , false ,0 , true );
		 	loader.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler , false ,0 , true  );
			loader.contentLoaderInfo.addEventListener(Event.UNLOAD, unload , false ,0 , true );
		 	loader.load( new URLRequest( _contentUrl ) , loaderContext );   
		}

		/**
		 *
		 * @param url
		 * @param loadIntoAppContext
		 */
		public function loadContentAsBytes( url : String , loadIntoAppContext : Boolean = false ) : void
		{
			
			disposeContent();
			
			_contentUrl = url;
			
			if ( loadIntoAppContext )
			{
				urlStream = new URLStream();
				urlStream.addEventListener( Event.COMPLETE, loadURLStreamComplete , false ,0 , true );
				urlStream.addEventListener( IOErrorEvent.IO_ERROR, ioError, false ,0 , true);
				urlStream.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false ,0 , true);
				urlStream.load( new URLRequest( _contentUrl ) );
			}
			else
			{
				var f 		: File 			= new File( url );
				var stream	: FileStream 	= new FileStream();
					stream.open( f , FileMode.READ);
					
				var bytesRead	: ByteArray = new ByteArray();
				
				stream.readBytes(bytesRead,0,stream.bytesAvailable);
	
			 	loader = new Loader(); 
			 	loader.contentLoaderInfo.addEventListener( Event.COMPLETE , loadComplete , false ,0 , true );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR , ioError , false ,0 , true );
			 	loader.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler , false ,0 , true  );
				loader.contentLoaderInfo.addEventListener( Event.UNLOAD, unload , false ,0 , true );
				loader.loadBytes( bytesRead , loaderContext );
			}		
		}
		/**
		 *  
		 * unloadContent() : void 
		 * 
		 * unload / nullify any content from the loader
		 * 
		 */
		public function disposeContent( ) : void 
		{
			disposeLoader();
		 	_contentUrl = null;
			
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-PRIVATE----------------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/*
		 */
		private function disposeLoader() : void
		{
			
			SoundMixer.stopAll(); // TICKY: REMOVE ALL SOUNDS / HELP GC
			
			if ( urlStream )
			{
				urlStream.removeEventListener( Event.COMPLETE, loadURLStreamComplete );
				urlStream.removeEventListener( IOErrorEvent.IO_ERROR, ioError);
				urlStream.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				urlStream = null;
			}
			
		 	if ( loader != null )
			{				
					 			
				loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR , ioError );
		 		loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , loadComplete );
		 		loader.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler , false );
				loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, unload );
						 	
		 		loader.unloadAndStop( true );

		 		loader = null;
		 		
		 	}
		}
		/**
		 *  
		 * initialize loaded content, and dispatch ContentLoaderEvent.LOAD_COMPLETE event;
		 * 
		 * 	ContentLoaderEvent.LOAD_COMPLETE:
		 * 	
		 * 		ContentLoaderEvent.AVM
		 * 		ContentLoaderEvent.content
		 * 		ContentLoaderEvent.totalFrames ( AS3 Only )
		 * 		ContentLoaderEvent.contentWidth
		 * 		ContentLoaderEvent.contentHeight 
		 * 
		 */
		private function initLoadedContent() : void 
		{
			
			var loadCompleteEvent 	: ContentLoaderEvent 	= new ContentLoaderEvent( ContentLoaderEvent.LOAD_COMPLETE , true );
			var isAVM1 				: Boolean 				= ( loader.contentLoaderInfo.actionScriptVersion == ActionScriptVersion.ACTIONSCRIPT2 );// Check loaded file action script version
			var mc 					: MovieClip;			
			
			if( isAVM1 )// AVM1 - AS2 
			{ 
				
				loadCompleteEvent.AVM 				= AvmProps.AVM1;
				loadCompleteEvent.content 			= loader;
								
			} 
			else //AVM2  - AS3 
			{ 
			
				loadCompleteEvent.AVM 				= AvmProps.AVM2;
				loadCompleteEvent.content 			= loader.content;
				mc 									= loader.content as MovieClip;
				
				if ( mc )
				{
					loadCompleteEvent.totalFrames 	= mc.totalFrames;
				}

			}
			
			loadCompleteEvent.contentWidth 		= loader.contentLoaderInfo.width;
			loadCompleteEvent.contentHeight 	= loader.contentLoaderInfo.height;
			
			dispatchEvent( loadCompleteEvent );
			
		}
		/*
		 */
		private function initLoadedURLStreamContent() : void
		{
			var bytesRead	: ByteArray = new ByteArray();
			
			urlStream.readBytes( bytesRead , 0 , urlStream.bytesAvailable);
			
		 	loader = new Loader(); 
		 	loader.contentLoaderInfo.addEventListener( Event.COMPLETE , loadComplete , false ,0 , true );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR , ioError , false ,0 , true );
		 	loader.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler , false ,0 , true  );
			loader.contentLoaderInfo.addEventListener( Event.UNLOAD, unload , false ,0 , true );			
			loader.loadBytes(  bytesRead , loaderContext );
		}

		//------------------------------------------------------------------------------------------------------------------------------------------------------------
		//-EVENT HANDLERS-------------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------------------------------

		/**
		 * 
		 * Catch errors in the loaded content - usually these tend to be :
		 * 
		 * 															AddedToStage mis-configurations, 
		 * 															Access to External Data ( without -use-network=false ), 
		 * 															Script errors.
		 * 
		 * Dispatch ContentLoaderEvent.CONTENT_ERROR:
		 * 	
		 * 		ContentLoaderEvent.errorID
		 * 		ContentLoaderEvent.filename
		 * 		
		 * @param event:UncaughtErrorEvent
		 */
        private function uncaughtErrorHandler(event:UncaughtErrorEvent):void 
		{

			var result : String; 
        	var error 		: Error;
        	var errorEvent	: ErrorEvent; 	

            if ( event.error is Error ) 
			{
                error 			= event.error as Error;
                result 			= error.message;
            } 
			else if ( event.error is ErrorEvent ) 
			{
                errorEvent		= event.error as ErrorEvent;
                result			= 'ErrorEvent: ' + errorEvent.errorID + ' ' + errorEvent.type;
            } 
			else 
			{
                result 			= 'GeneralError: ' + event.toString();
            }

            var e : ContentLoaderEvent 	= new ContentLoaderEvent( ContentLoaderEvent.CONTENT_ERROR , true  );
            	e.message 				= result;
            	e.url					= _contentUrl;;
            dispatchEvent( e );
            
        }
		/**
		 * ioError(event : IOErrorEvent) : void
		 * 
		 * loader input / output error - due to file not found
		 * 
		 */
		private function ioError(event : IOErrorEvent) : void 
		{
            var e : ContentLoaderEvent 	= new ContentLoaderEvent( ContentLoaderEvent.CONTENT_LOAD_ERROR , true  );
            	e.message 				= "IOErrorEvent";
            	e.url					= _contentUrl;
            dispatchEvent( e );
		}
		/**
		 */
		private function securityErrorHandler(event : SecurityErrorEvent) : void
		{
            var e : ContentLoaderEvent 	= new ContentLoaderEvent( ContentLoaderEvent.CONTENT_LOAD_ERROR , true  );
            	e.message 				= "SecurityError";
            	e.url					= _contentUrl;
            dispatchEvent( e );
		}
		/**
		 */
		private function loadURLStreamComplete(event : Event) : void
		{
			initLoadedURLStreamContent();
		}
		/**
		 */
		private function unload(event : Event) : void
		{
			SoundMixer.stopAll(); // Stop All sounds ( helps GC for content with audio );
		}
		/**
		 *  
		 *  loader / complete event handler
		 * 
		 * @param load complete / loader event handler
		 */
		private function loadComplete( event : Event ) : void 	
		{
			initLoadedContent();
		}

	}
		
}