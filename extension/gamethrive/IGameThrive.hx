package extension.gamethrive;

/**
 * Interface for GameThrive extension
 */
interface IGameThrive
{
	function notificationOpened( message:String, additionalData:Dynamic, isActive:Bool ):Void;
}