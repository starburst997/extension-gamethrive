#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GameThrive/GameThrive.h"

extern "C" void notificationOpened( const char* message, const char* additionalData, bool isActive );

@interface GameThriveLib:NSObject

	+ (GameThriveLib *) instance;
	+ (NSDictionary *) launchOptions;
	+ (void) setLaunchOptions:(NSDictionary *)value;

	@property (strong, nonatomic) GameThrive *gameThrive;

@end

@interface NMEAppDelegate : NSObject <UIApplicationDelegate>

	

@end

@interface NMEAppDelegate (GameThriveLib)



@end

@implementation NMEAppDelegate (GameThriveLib)
	
	// Can't get didFinishLaunchingWithOptions, this will do...
	-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		NSLog(@"App will launched ...");
		
		GameThriveLib.launchOptions = launchOptions;

		return YES;
	}
	
@end

@implementation GameThriveLib

	@synthesize gameThrive;

	// Keep LaunchOptions
	static NSDictionary * launchOptions = nil;

	+ (NSDictionary *) launchOptions { return launchOptions; }
	+ (void) setLaunchOptions:(NSDictionary *)value { launchOptions = value; }

	// Show a native dialog
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

	// Start GameThrive
	-(BOOL)configure
	{
		NSLog(@"LAUNCH %@", GameThriveLib.launchOptions);
		
		self.gameThrive = [[GameThrive alloc] initWithLaunchOptions:GameThriveLib.launchOptions handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
			
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

	// Singleton
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
		
		[[GameThriveLib instance] configure];
	}
	
	void ShowDialog( const char* title, const char* message )
	{
		[[GameThriveLib instance] showDialog: [[NSString alloc] initWithUTF8String:title] message:[[NSString alloc] initWithUTF8String:message]];
	}
}
