#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GameThrive/GameThrive.h"

extern "C" void notificationOpened( const char* message, const char* additionalData, bool isActive );

@interface GameThriveLib:NSObject

	+ (GameThriveLib *)instance;

	@property (strong, nonatomic) GameThrive *gameThrive;

@end

@interface NMEAppDelegate : NSObject <UIApplicationDelegate>

	

@end
@interface NMEAppDelegate (GameThriveLib)

	
	
@end

@implementation NMEAppDelegate (GameThriveLib)

	// Changing to didFinishLaunchingWithOptions will make the app crash
	-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		NSLog(@"This is never called...");
		
		return YES;
	}
	
@end

@implementation GameThriveLib
	
	- (void)applicationDidBecomeActive:(UIApplication *)application	{
	    NSLog(@"applicationDidBecomeActive?");
	}
	
	-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		NSLog(@"APP LAUNCHED?");
		return YES;
	}
	
	-(BOOL)showDialog:(NSString *)title message:(NSString *)message
	{
		
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
														    message:message
														   delegate:self
												  cancelButtonTitle:@"Close"
												  otherButtonTitles:nil, nil];
		
		[alertView show];
		
		return YES;
	}
	
	-(BOOL)configure
	{
		NMEAppDelegate *app = [[UIApplication sharedApplication] delegate];
		
		/*self.gameThrive = */[[GameThrive alloc] initWithLaunchOptions:/*app.launchOptions*/ nil handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
			
			NSLog(@"APP LOG ADDITIONALDATA: %@", additionalData);
			
			NSString * dataStr = @"{\"title\":\"Title 2\"}";
			if (additionalData)
			{
				NSError *error;
				NSData *jsonData = [NSJSONSerialization dataWithJSONObject:additionalData
																   options:0//(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
																	 error:&error];
				
				if (! jsonData) {
					NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
					dataStr = @"{\"title\":\"Title 1\"}";
				} else {
					dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
				}
			}
			
			notificationOpened( [message UTF8String], [dataStr UTF8String], isActive );
		}];

		return YES;
	}
	
	+ (GameThriveLib *)instance{
		static GameThriveLib *instance;
		
		@synchronized(self){
			if (!instance)
				instance = [[GameThriveLib alloc] init];

			return instance;
		}
	}

@end

namespace gamethrive 
{
	void Configure()
	{
		NSLog(@"CONFIGURE CALLED");
		
		//[[GameThriveLib instance] configure];
	}
	
	void ShowDialog( const char* title, const char* message )
	{
		[[GameThriveLib instance] showDialog: [[NSString alloc] initWithUTF8String:title] message:[[NSString alloc] initWithUTF8String:message]];
	}
}
