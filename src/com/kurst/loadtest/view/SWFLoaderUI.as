
package com.kurst.loadtest.view
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
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
		public var urlParamsInput   : InputText;

		public var url              : InputText;
		public var loadURLBtn       : PushButton;

		//---------------------------------------------------------------------------------------------

		private var config 		: MinimalConfigurator;

		//---------------------------------------------------------------------------------------------

		private var mainLayout 	: XML = <comps>
											<Window title='SWFRenderer Test Content Loader' width='220' height='280' x='10' y='10'>
												<VBox x='10' y='10' spacing='10'>

													<Label text='URL Parameters'/>
													<InputText id='urlParams_input' text='x=10&title=20&d=anotherValue' width='200' />

													<CheckBox id='use_app_context_chk' label='Use app context'/>

													<HBox spacing='10'>
														<Label text='FPS'/>
														<NumericStepper id='fpsStepper' value='25'/>
													</HBox>

													<PushButton id='load_btn' label='Load SWF' />
													<PushButton id='unload_btn' label='UNLoad SWF' />

													<Label text='Load URL'/>
													<InputText id='url' text='' width='200' />
													<PushButton id='load_url_btn' label='Load URL' />

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
			urlParamsInput  = config.getCompById('urlParams_input') as InputText;

			url             = config.getCompById('url') as InputText;
			loadURLBtn      = config.getCompById('load_url_btn') as PushButton;

		}
	}
}
