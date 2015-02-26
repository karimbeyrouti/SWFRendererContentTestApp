package {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	public class FlashVarsMain extends Sprite
	{

		//---------------------------------------------------------------------

		private var textField:TextField = new TextField();

		//---------------------------------------------------------------------

	    public function FlashVarsMain()
	    {
		    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage );
	    }

		//---------------------------------------------------------------------

		/**
		 * onAddedToStage - SWF Added to stage event handler
		 * @param e
		 */
		private function onAddedToStage( e : Event ) : void
		{
			setTimeout( makeSureEverythingIsInitedDelay , 1 );
		}
		/**
		 * makeSureEverythingIsInitedDelay - Function called after delay to make sure SWF is initialised
		 */
		private function makeSureEverythingIsInitedDelay( ) : void
		{

			// Create TextField
			textField.multiline = true;
			textField.width     = 300;
			textField.height    = 600;

			addChild(textField);

			// Scan for Flash Variables and list them in the textfield.
			for ( var c : String in loaderInfo.parameters )
			{
				textField.text += c + ' : ' + loaderInfo.parameters[c] + '\n';
			}

			textField.text += '--> Done';

		}
	}

}
