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
package
{
	import com.kurst.loadtest.view.SWFLoaderUI;
	import com.kurst.swfrender.services.render.events.ContentLoaderEvent;
	import com.kurst.swfrender.services.render.utils.SWFContentLoader;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	[SWF(backgroundColor="#444444", frameRate="30", width="800", height="600")]
	public class Main extends Sprite
	{

		//------------------------------------------------------------------------------------------------------------------------------

		private var ui          : SWFLoaderUI;
		private var container   : Sprite;
		private var file        : File = new File();
		private var swfLoader   : SWFContentLoader = new SWFContentLoader();
		private var content     : DisplayObject;

		//------------------------------------------------------------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function Main()
		{
			stage.scaleMode     = StageScaleMode.NO_SCALE;
			stage.align         = StageAlign.TOP_LEFT;

			addChild( container = new Sprite() );
			addChild( ui        = new SWFLoaderUI() );

			swfLoader           = new SWFContentLoader();
			swfLoader.addEventListener( ContentLoaderEvent.LOAD_COMPLETE , onSWFLoaded );
			swfLoader.addEventListener( ContentLoaderEvent.CONTENT_ERROR , onSWFContentError );
			swfLoader.addEventListener( ContentLoaderEvent.CONTENT_LOAD_ERROR , onSWFContentLoadError );

			ui.loadButton.addEventListener( MouseEvent.CLICK, onClickLoadButton )
			ui.unloadButton.addEventListener( MouseEvent.CLICK, onClickUnLoadButton )
			ui.loadURLBtn.addEventListener( MouseEvent.CLICK, onClickLoadURLButton )

			file.addEventListener(Event.SELECT, onFileSelected , false, 0, true);
		}

		//------------------------------------------------------------------------------------------------------------------------------

		/**
		 * Content Error ( Possibly Scripting in Loaded SWF)
		 * @param e
		 */
		private function onSWFContentError( e : ContentLoaderEvent ) : void
		{
			trace('onSWFContentError');
		}
		/**
		 * Error loading the SWF
		 * @param e
		 */
		private function onSWFContentLoadError( e : ContentLoaderEvent ) : void
		{
			trace('onSWFContentLoadError');
		}
		/**
		 * SWF Successfully loaded
		 * @param e
		 */
		private function onSWFLoaded( e : ContentLoaderEvent ) : void
		{

			// If there is loaded SWF content - unload it
			if ( content )
			{
				container.removeChild( content );
				content = null;
			}

			// Add the new loaded content
			stage.frameRate     = ui.fps.value;
			content             = e.content;
			container.addChild( content );
		}
		/**
		 * File selected
		 * @param e
		 */
		private function onFileSelected( e : Event ) : void
		{
			var d : File = e.currentTarget as File;
			swfLoader.disposeContent(); // dispose any loaded content
			swfLoader.loadSWFAsBytes( d.url , ui.loadIntoContext.selected  , ui.urlParamsInput.text ); // load new SWF
		}
		/**
		 *
		 * @param e
		 */
		private function onClickLoadURLButton( e : Event ) : void
		{

			var url                 : String = ui.url.text; // Full url to SWF file
			var queryArgumentsPos   : int       = url.indexOf( '?'); // Check for query string vars
			var flashVars           : String = ''; // Flash variables ( Extracted URL parameters )


			if ( queryArgumentsPos != -1 ) // Strip query arguments if there are any and assign to flash vars
			{
				flashVars = url.substr( queryArgumentsPos + 1 , url.length ); // Assign URL params to flash vars
				url       = url.substr( 0 , queryArgumentsPos); // Get url without query string vars
			}

			if (  ui.loadIntoContext.selected )
			{
				swfLoader.loadSWFAsBytes( url , true , flashVars ); // Load into application context ( Note: Flash vars / URL params will not work )
			}
			else
			{
				swfLoader.loadSWFURL( url , flashVars ); // Load SWF
			}

		}
		/**
		 * Click Load Button
		 * @param e
		 */
		private function onClickLoadButton( e : MouseEvent ) : void
		{
			var ff : FileFilter = new FileFilter('SWF Files', '*.swf' );
			file.browseForOpen('Select SWF', [ff]);
		}
		/**
		 * Click Unload Button
		 * @param e
		 */
		private function onClickUnLoadButton( e : MouseEvent ) : void
		{
			if ( content )
			{
				container.removeChild( content );
				content = null;
			}

			swfLoader.disposeContent();
		}

	}

}