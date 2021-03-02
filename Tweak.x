#import <UIKit/UIKit.h>

@interface _UIStatusBar
@end

@interface UIStatusBarWindow : UIWindow
@property(nonatomic, strong) UILabel *label;
-(void)loadNotificationIcon;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end

@interface SBUIController
-(BOOL)isBatteryCharging;
-(BOOL)isConnectedToExternalChargingSource;
-(void)updateBatteryState:(id)arg1;
-(int)batteryCapacityAsPercentage;
@end


static NSString *plistPath = @"/var/mobile/Library/Preferences/com.greg0109.batterydotprefs.plist";

CGFloat coordinatesForX;
CGFloat coordinatesForY;
CGFloat iconSize;
UIView *paintView;
UIColor *chosenColor;

NSString *fullBatteryColor;
NSString *batteryCharging;
NSString *batteryChargingFull;
NSString *batteryDischarging;
NSString *lowbatterypercentage;
NSString *batteryLow;

static UIColor *colorWithHexString(NSString *hexCode) {
  NSString *noHashString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
  NSScanner *scanner = [NSScanner scannerWithString:noHashString];
  [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]];
	unsigned hex;
  if (![scanner scanHexInt:&hex]) return nil;
  int a;
  int r;
  int g;
  int b;
  switch (noHashString.length) {
      case 3:
          a = 255;
          r = (hex >> 8) * 17;
          g = ((hex >> 4) & 0xF) * 17;
          b = ((hex >> 0) & 0xF) * 17;
          break;case 6:
          a = 255;
          r = (hex >> 16);
          g = (hex >> 8) & 0xFF;
          b = (hex) & 0xFF;
          break;case 8:
          a = (hex >> 24);
          r = (hex >> 16) & 0xFF;
          g = (hex >> 8) & 0xFF;
          b = (hex) & 0xFF;
          break;default:
          a = 255.0;
          r = 255.0;
          b = 255.0;
          g = 255.0;
          break;
      }
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a / 255];
}

%hook UIStatusBarWindow
%property(nonatomic, strong) UIView *view;

%new
-(void)loadNotificationIcon {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	int xcoordinates = prefs[@"xcoordinates"] ? [prefs[@"xcoordinates"] intValue] : 95;
	coordinatesForX = (float)xcoordinates;
	int ycoordinates = prefs[@"ycoordinates"] ? [prefs[@"ycoordinates"] intValue] : 95;
	coordinatesForY = (float)ycoordinates;
	int sizeicon = prefs[@"iconsize"] ? [prefs[@"iconsize"] intValue] : 5;
	iconSize = (float)sizeicon;

	CGFloat screenwidth = [[UIScreen mainScreen] bounds].size.width;
	coordinatesForX = (coordinatesForX*screenwidth)/100;
	CGFloat screenheight = [[UIScreen mainScreen] bounds].size.height;
	coordinatesForY = (coordinatesForY*screenheight)/100;

	CGRect labelFrame = CGRectMake(coordinatesForX , coordinatesForY, iconSize, iconSize);

	paintView=[[UIView alloc]initWithFrame:labelFrame];
    [paintView setBackgroundColor:chosenColor];
	paintView.layer.cornerRadius = 0.5 * iconSize;
	paintView.layer.masksToBounds = true;

	[self addSubview:paintView];
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.greg0109.batterydotprefs.hideIcon" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		paintView.hidden = YES;
		[paintView removeFromSuperview];
	}];
}

-(void)setStatusBar:(id)arg1{
	%orig;
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.greg0109.batterydotprefs.showIcon" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		[self loadNotificationIcon];
	}];
}
%end

%hook SBUIController
-(void)updateBatteryState:(id)arg1 {
	int batteryPercentage = [self batteryCapacityAsPercentage];
	if (self.isConnectedToExternalChargingSource) {
		if (batteryPercentage == 100) {
			chosenColor = colorWithHexString(batteryChargingFull);
		} else {
			chosenColor = colorWithHexString(batteryCharging);
		}
	} else if (!self.isBatteryCharging) {
		if (batteryPercentage == 100) {
			chosenColor = colorWithHexString(fullBatteryColor);
		} else if (batteryPercentage <= [lowbatterypercentage intValue]) {
			chosenColor = colorWithHexString(batteryLow);
		} else {
			chosenColor = colorWithHexString(batteryDischarging);
		}
	}
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greg0109.batterydotprefs.hideIcon" object:nil userInfo:nil]; 
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greg0109.batterydotprefs.showIcon" object:nil userInfo:nil];
	%orig;
}
%end

%ctor {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	chosenColor = [UIColor greenColor];
	fullBatteryColor = prefs[@"fullBattery"] && !([prefs[@"fullBattery"] isEqualToString:@""]) ? [prefs[@"fullBattery"] stringValue] : @"#E22300";
	batteryCharging = prefs[@"batteryCharging"] && !([prefs[@"batteryCharging"] isEqualToString:@""]) ? [prefs[@"batteryCharging"] stringValue] : @"#E22300";
	batteryChargingFull = prefs[@"batteryChargingFull"] && !([prefs[@"batteryChargingFull"] isEqualToString:@""]) ? [prefs[@"batteryChargingFull"] stringValue] : @"#E22300";
	batteryDischarging = prefs[@"batteryDischarging"] && !([prefs[@"batteryDischarging"] isEqualToString:@""]) ? [prefs[@"batteryDischarging"] stringValue] : @"#E22300";
	lowbatterypercentage = prefs[@"lowbatterypercentage"] && !([prefs[@"lowbatterypercentage"] isEqualToString:@""]) ? [prefs[@"lowbatterypercentage"] stringValue] : @"20";
	batteryLow = prefs[@"batteryLow"] && !([prefs[@"batteryLow"] isEqualToString:@""]) ? [prefs[@"batteryLow"] stringValue] : @"#E22300";
	int xcoordinates = prefs[@"xcoordinates"] ? [prefs[@"xcoordinates"] intValue] : 95;
	coordinatesForX = (float)xcoordinates;
	int ycoordinates = prefs[@"ycoordinates"] ? [prefs[@"ycoordinates"] intValue] : 95;
	coordinatesForY = (float)ycoordinates;
	int sizeicon = prefs[@"iconsize"] ? [prefs[@"iconsize"] intValue] : 5;
	iconSize = (float)sizeicon;
}