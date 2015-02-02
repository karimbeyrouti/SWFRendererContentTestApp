
package com.kurst.loadtest.view
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.utils.MinimalConfigurator;
	import flash.display.Sprite;
	import flash.events.Event;

	public class SWFLoaderUI extends Sprite
	{

		//---------------------------------------------------------------------------------------------

		public var loadButton       : PushButton;
		public var unloadButton     : PushButton;
		public var loadIntoContext  : CheckBox;
		public var fps              : NumericStepper;

		//---------------------------------------------------------------------------------------------

		private var config 		: MinimalConfigurator;

		//---------------------------------------------------------------------------------------------

		private var mainLayout 	: XML = <comps>
											<Window title='SWFRenderer Test Content Loader' width='180' height='140' x='10' y='10'>
												<VBox x='10' y='10' spacing='10'>
													<CheckBox id='use_app_context_chk' label='Use app context'/>
													<PushButton id='load_btn' label='Load SWF' />
													<PushButton id='unload_btn' label='UNLoad SWF' />
													<HBox spacing='10'>
														<Label text='FPS'/>
														<NumericStepper id='fpsStepper' value='25'/>
													</HBox>
												</VBox>
											</Window>
										</comps>;

		//---------------------------------------------------------------------------------------------

		public function SWFLoaderUI()
		{

			Style.setStyle( Style.DARK );
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		private function onAddedToStage ( e : Event ) : void
		{
			config = new MinimalConfigurator(this);
			config.parseXML(mainLayout);

			fps             = config.getCompById('fpsStepper') as NumericStepper;
			loadButton      = config.getCompById('load_btn') as PushButton;
			unloadButton    = config.getCompById('unload_btn') as PushButton;
			loadIntoContext = config.getCompById('use_app_context_chk') as CheckBox;
		}
	}
}
