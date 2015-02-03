#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GameThrive/GameThrive.h"

extern "C" void notificationOpened( const char* message, const char* additionalData, bool isActive );

@interface GameThriveLib:NSObject
{
	@property (strong, nonatomic) GameThrive *gameThrive;
	+ (GameThriveLib *)instance;
}
@end

@interface NMEAppDelegate : NSObject <UIApplicationDelegate>
	
@end

@implementation NMEAppDelegate (GameThriveLib)
	
@end

@implementation GameThriveLib

	-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		self.gameThrive = [[GameThrive alloc] initWithLaunchOptions:launchOptions handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
			
			NSLog(@"APP LOG ADDITIONALDATA: %@", additionalData);
			
			NSString * dataStr = @"";
			if (additionalData) 
			{
				dataStr = [NSString stringWithFormat:@"%@", additionalData];
			}
			
			notificationOpened( [message UTF8String], [dataStr UTF8String], isActive );
		}];
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
	
	- (id)init {
		self = [super init];
		if (self) {
			if (!instance)
				instance = self;
		}
		return self;
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
		
	}
	
	void ShowDialog( const char* title, const char* message )
	{
		[[GameThriveLib instance] showDialog: [[NSString alloc] initWithUTF8String:title] message:[[NSString alloc] initWithUTF8String:message]];
	}
}
