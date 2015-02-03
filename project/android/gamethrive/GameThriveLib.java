package gamethrive;

import com.gamethrive.GameThrive;
import com.gamethrive.NotificationOpenedHandler;

import android.app.*;
import android.content.pm.ActivityInfo;
import android.os.*; 
import android.util.Log;
import android.view.*;  
import android.webkit.ValueCallback;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.*;

import org.json.JSONObject;

import org.haxe.lime.HaxeObject;
import org.haxe.lime.GameActivity;
import org.haxe.extension.Extension;

import java.util.*;

public class GameThriveLib extends Extension implements NotificationOpenedHandler
{
	public static String APP_ID = "";
	public static String PROJECT_NUM = "";
	public static HaxeObject callback = null;
	
	private static GameThriveLib instance;
	
	public static boolean configured = false;
	
	private GameThrive gameThrive;
	
	private String _message = "";
	private String _title = "";
	
	private String __message = "";
	private String __additionalData = "";
	private boolean __isActive = false;
	
	// Configure AdColony
	public static void configure( HaxeObject handler, String appID, String projectNum )
	{
		Log.d("GameThrive", "Configure called!");
		
		GameThriveLib.APP_ID = appID;
		GameThriveLib.PROJECT_NUM = projectNum;
		GameThriveLib.configured = true;
		GameThriveLib.callback = handler;
		
		if ( GameThriveLib.instance != null ) GameThriveLib.instance._configure();
    }
	
	// Show dialog
	public static void showDialog( String title, String message )
	{
		if ( GameThriveLib.instance != null ) GameThriveLib.instance._showDialog( title, message );
	}
	public void _showDialog( String title, String message )
	{
		_message = message;
		_title = title;
		
		Extension.callbackHandler.post( new Runnable()
		{
			@Override public void run() 
			{
				AlertDialog.Builder builder = null;
				builder = new AlertDialog.Builder( mainActivity ).setTitle( _title ).setMessage( _message );
				
				builder.setCancelable( true ).setPositiveButton( "OK", null ).create().show();
			}
		});
	}
	
	// Create GameThrive
	public void _configure()
	{
		Extension.callbackHandler.post( new Runnable()
		{
			@Override public void run() 
			{
				if (gameThrive == null)
					gameThrive = new GameThrive( mainActivity, GameThriveLib.PROJECT_NUM, GameThriveLib.APP_ID, GameThriveLib.instance );
			}
		});
	}
	
	// Ad Started Callback - called only when an ad successfully starts playing
	public void notificationOpened( String message, JSONObject additionalData, boolean isActive )
	{
		Log.d("GameThrive", "notificationOpened");
		
		__message = message;
		__additionalData = additionalData.toString();
		__isActive = isActive;
		
		Extension.callbackHandler.post (new Runnable()
		{
			@Override public void run () 
			{
				GameThriveLib.callback.call( "notificationOpened", new Object[] {
					__message,
					__additionalData,
					__isActive
				} );
			}
		});
	}
	
	/* Java Events */
	
	public void onCreate ( Bundle savedInstanceState ) 
	{
		GameThriveLib.instance = this;
		if ( GameThriveLib.configured ) _configure();
	}
	
	public void onPause()
	{
		if ( gameThrive != null ) gameThrive.onPaused();
	}
	
	public void onResume()
	{
		if ( gameThrive != null ) gameThrive.onResumed();
	}
}
