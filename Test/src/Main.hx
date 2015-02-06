package;

import extension.gamethrive.GameThrive;
import extension.gamethrive.IGameThrive;
import openfl.events.Event;

import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.Lib;

class Main extends Sprite implements IGameThrive
{
	// GameThrive ID
	public static inline var PROJECT_NUM = "xxxxxxxxxxxxx";
	public static inline var APP_ID = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
	
	public var t:TextField;
	
    public function new() 
	{
		super();
		
		trace("TEST!!! 1..2..3..");
		
		graphics.beginFill( 0xFF0000 );
		graphics.drawRect( 0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight );
		graphics.endFill();
		
        t = new TextField();
        addChild( t );
		
		t.text = "GameThrive";
		
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
    }
	
	private function addedToStageHandler( event:Event ):Void
	{
		removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		
		t.text += "\n" + "Configured";
		
		GameThrive.configure( this, APP_ID, PROJECT_NUM );
	}
	
	public function notificationOpened( message:String, additionalData:Dynamic, isActive:Bool ):Void
	{
		if ( additionalData.title == "" )
		{
			additionalData.title = "Default Title";
		}
	
		t.text += "\n" + message + "\nTitle:" + additionalData.title + "\n" + isActive;
		
		GameThrive.showDialog( additionalData.title, message );
	}
}