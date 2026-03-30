#import "RMAppDelegate.h"
#import "RMRootViewController.h"
#import "RMSettingsViewController.h"
#import "UIBezierPath+house.h"
#import "UIBezierPath+gear.h"

@implementation RMAppDelegate
+ (UIImage *)makeImageFrom:(UIBezierPath *)path withColor:(UIColor *)color {
	// Human Interface Guidelines on tab bar image sizes: 25x25 on 1x scale factor, maximum 48x32
	// Find out ratio of width/height to 48 and 32 respectively, pick the minimum(?)
	CGFloat wRatio = 48/path.bounds.size.width;
	CGFloat hRatio = 32/path.bounds.size.height;
	CGFloat scaleRatio = MIN(wRatio, hRatio);
	[path applyTransform:CGAffineTransformMakeScale(scaleRatio, scaleRatio)];
	UIGraphicsBeginImageContextWithOptions(path.bounds.size, NO, 0.0); //size of the image, opaque, and scale (set to screen default with 0)
	CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -path.bounds.origin.x, -path.bounds.origin.y);
	[color set];
	[path fill];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[RMSettingsViewController registerDefaults];
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

	RMRootViewController *mainController = [[RMRootViewController alloc] init];
	UIImage *mainControllerImage = [RMAppDelegate makeImageFrom:[UIBezierPath symbolHouse] withColor:[UIColor systemGrayColor]];
	UIImage *mainControllerSelectedImage = [RMAppDelegate makeImageFrom:[UIBezierPath symbolHouse] withColor:[UIColor systemBlueColor]];
	mainController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
								  image:mainControllerImage
							  selectedImage:mainControllerSelectedImage];

	UIViewController *settingsController = [[UINavigationController alloc] initWithRootViewController:[[RMSettingsViewController alloc] initWithStyle:UITableViewStylePlain]];
	UIImage *settingsControllerImage = [RMAppDelegate makeImageFrom:[UIBezierPath symbolGear] withColor:[UIColor systemGrayColor]];
	UIImage *settingsControllerSelectedImage = [RMAppDelegate makeImageFrom:[UIBezierPath symbolGear] withColor:[UIColor systemBlueColor]];
	settingsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
								  image:settingsControllerImage
							  selectedImage:settingsControllerSelectedImage];

	UITabBarController *tabBar = [[UITabBarController alloc] init];
	[tabBar setViewControllers:@[mainController, settingsController]];
	_rootViewController = tabBar;
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
	return YES;
}

@end
