#import "RMAppDelegate.h"
#import "RMRootViewController.h"

@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#if 0
	_rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RMRootViewController alloc] init]];
#else
	_rootViewController = [[RMRootViewController alloc] init];
#endif
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
	return YES;
}

@end
