#include "BDPRootListController.h"

CGFloat coordinatesForX;
CGFloat coordinatesForY;
CGFloat iconSize;
CGFloat alpha;
UIView *paintView;
UIColor *chosenColor;

NSString *fullBatteryColor;
NSString *batteryCharging;
NSString *batteryChargingFull;
NSString *batteryDischarging;
NSString *lowbatterypercentage;
NSString *batteryLow;

static NSString *plistPath = @"/var/mobile/Library/Preferences/com.greg0109.batterydotprefs.plist";

@implementation BDPRootListController

-(void)loadNotificationIcon {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	int xcoordinates = prefs[@"xcoordinates"] ? [prefs[@"xcoordinates"] intValue] : 95;
	coordinatesForX = (float)xcoordinates;
	int ycoordinates = prefs[@"ycoordinates"] ? [prefs[@"ycoordinates"] intValue] : 95;
	coordinatesForY = (float)ycoordinates;
	int sizeicon = prefs[@"iconsize"] ? [prefs[@"iconsize"] intValue] : 5;
	iconSize = (float)sizeicon;
	int alphavalue = prefs[@"alpha"] ? [prefs[@"alpha"] intValue] : 100;
	alpha = (float)alphavalue/100;

	CGRect labelFrame = CGRectMake(coordinatesForX , coordinatesForY, iconSize, iconSize);
	
	UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
	for (UIView *view in [topWindow subviews]) {
		if (view.frame.origin.x == (int)xcoordinates && view.frame.origin.y == (int)ycoordinates) {
			view.hidden = YES;
			[view removeFromSuperview];
		}
	}
	paintView=[[UIView alloc]initWithFrame:labelFrame];
	[paintView setBackgroundColor:chosenColor];
	paintView.layer.cornerRadius = 0.5 * iconSize;
	paintView.layer.masksToBounds = true;
	paintView.alpha = alpha;

	[topWindow addSubview:paintView];
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {
	[super viewDidLoad];
	((UITableView *)[self.view.subviews objectAtIndex:0]).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Apply changes" style:UIBarButtonItemStylePlain target:self action:@selector(killall)];
  	self.navigationItem.rightBarButtonItem = button;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:plistPath atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		[self loadNotificationIcon];
	}
}

- (void)killall {
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Respring?" message:@"Are you sure you want to respring?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSTask *killallSpringBoard = [[NSTask alloc] init];
        [killallSpringBoard setLaunchPath:@"/usr/bin/killall"];
        [killallSpringBoard setArguments:@[@"-9", @"backboardd"]];
        [killallSpringBoard launch];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
