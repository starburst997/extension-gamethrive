package extension.gamethrive;

import haxe.Json;

#if android
import openfl.utils.JNI;
#end

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

class GameThrive 
{
	// Bridge to HXCPP
	#if android
	private static var __configure:Dynamic->String->String->Void = JNI.createStaticMethod("gamethrive/GameThriveLib", "configure", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;Ljava/lang/String;)V");
	private static var __showDialog:String->String->Void = JNI.createStaticMethod("gamethrive/GameThriveLib", "showDialog", "(Ljava/lang/String;Ljava/lang/String;)V");
	#elseif ios
	private static var __configure:Dynamic = Lib.load("gamethrive", "gamethrive_configure", 1);
	private static var __showDialog:Dynamic = Lib.load("gamethrive", "gamethrive_showDialog", 2);
	#else
	private static var __configure:Dynamic = null;
	private static var __showDialog:Dynamic = null;
	#end
	
	// Singleton
	private static var _instance:GameThrive = null;
	
	// Callback
	private var handler:IGameThrive = null;
	
	// Configure
    public static function configure( handler:IGameThrive, appID:String = "", projectNum:String = "" ):Void 
	{
		if ( _instance == null ) _instance = new GameThrive();
		
		if ( __configure != null ) 
		{
			_instance.handler = handler;
			
			#if android
			__configure( _instance, appID, projectNum );
			#elseif ios
			__configure( _instance.notificationOpened );
			#end
		}
    }
	
	// Show dialog
    public static function showDialog( title:String, message:String ):Void 
	{
		if ( __showDialog != null ) 
		{
			#if android
			__showDialog( title, message );
			#elseif ios
			__showDialog( title, message );
			#end
		}
	}
	
	// Is available
	public static inline function isAvailable():Bool 
	{
		#if (android || ios)
		return true;
		#else
		return false;
		#end
	}
	
	// When a notification has been received
	public function notificationOpened( message:String, additionalData:String, isActive:Bool ):Void
	{
		trace( "MESSAGE", message, "DATA", additionalData, "ACTIVE", isActive );
		
		if ( handler != null )
		{
			// Take the data and convert to Dynamic
			try
			{
				var data:Dynamic = Json.parse( additionalData );
				if ( data == null ) data = {};
				if ( data.title == null ) data.title = "";
				
				handler.notificationOpened( message, data, isActive );
			}
			catch ( e:Dynamic )
			{
				handler.notificationOpened( message, {title:""}, isActive );
			}
		}
	}
}