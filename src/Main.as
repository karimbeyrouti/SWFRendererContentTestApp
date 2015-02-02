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

			file.addEventListener(Event.SELECT, onFileSelected , false, 0, true);
		}

		//------------------------------------------------------------------------------------------------------------------------------

		/**
		 *
		 * @param e
		 */
		private function onSWFContentError( e : ContentLoaderEvent ) : void
		{
			trace('onSWFContentError');
		}
		/**
		 *
		 * @param e
		 */
		private function onSWFContentLoadError( e : ContentLoaderEvent ) : void
		{
			trace('onSWFContentLoadError');
		}
		/**
		 *
		 * @param e
		 */
		private function onSWFLoaded( e : ContentLoaderEvent ) : void
		{

			if ( content )
			{
				container.removeChild( content );
				content = null;
			}

			content = e.content;
			container.addChild( content );
		}
		/**
		 *
		 * @param e
		 */
		private function onFileSelected( e : Event ) : void
		{

			var d : File = e.currentTarget as File;
			swfLoader.disposeContent();
			swfLoader.loadContentAsBytes( d.url , ui.loadIntoContext.selected );
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