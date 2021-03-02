#include "BDPRootListController.h"

static NSString *plistPath = @"/var/mobile/Library/Preferences/com.greg0109.batterydotprefs.plist";

@implementation BDPRootListController

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
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greg0109.batterydotprefs.hideIcon" object:nil userInfo:nil];
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greg0109.batterydotprefs.showIcon" object:nil userInfo:nil];
	}
}

- (void)killall {
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
