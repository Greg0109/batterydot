#line 1 "Tweak.x"
#import <UIKit/UIKit.h>

@interface _UIStatusBar
@end

@interface UIStatusBarWindow : UIWindow
-(void)loadNotificationIcon;
@end

@interface SpringBoard
-(void)loadNotificationIcon;
@end

@interface SBApplication
@property (nonatomic,readonly) NSString * bundleIdentifier;                                                                                     
@property (nonatomic,readonly) NSString * iconIdentifier;
@property (nonatomic,readonly) NSString * displayName;
@end


@interface CSCoverSheetViewController
-(void)viewDidLoad;
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
CGFloat alpha;
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

static void loadNotificationIcon() {
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
		if (view.frame.origin.x == (int)xcoordinates && view.frame.origin.y == (int)ycoordinates && view.frame.size.width == (int)sizeicon && view.frame.size.height == (int)sizeicon) {
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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SpringBoard; @class SBUIController; 
static void (*_logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, SBApplication *); static void _logos_method$_ungrouped$SpringBoard$frontDisplayDidChange$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, SBApplication *); static void (*_logos_orig$_ungrouped$SBUIController$updateBatteryState$)(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBUIController$updateBatteryState$(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST, SEL, id); 

#line 120 "Tweak.x"

static void _logos_method$_ungrouped$SpringBoard$frontDisplayDidChange$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, SBApplication * arg1) {
	_logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$(self, _cmd, arg1);
	if (![[NSString stringWithFormat:@"%@",arg1] containsString:@"SBPowerDownViewController"] && ![[NSString stringWithFormat:@"%@", arg1] containsString:@"Overlay"]) {
		if (arg1.bundleIdentifier && ![arg1.bundleIdentifier isEqualToString:@"com.apple.springboard"] && ![arg1.bundleIdentifier isEqualToString:(NSString*)[NSNull null]]) {
			loadNotificationIcon();
		}
	}
}



static void _logos_method$_ungrouped$SBUIController$updateBatteryState$(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
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
	loadNotificationIcon();
	_logos_orig$_ungrouped$SBUIController$updateBatteryState$(self, _cmd, arg1);
}


static __attribute__((constructor)) void _logosLocalCtor_c3ccdc8d(int __unused argc, char __unused **argv, char __unused **envp) {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	chosenColor = [UIColor greenColor];
	fullBatteryColor = prefs[@"fullBattery"] && !([prefs[@"fullBattery"] isEqualToString:@""]) ? [prefs[@"fullBattery"] stringValue] : @"#255";
	batteryCharging = prefs[@"batteryCharging"] && !([prefs[@"batteryCharging"] isEqualToString:@""]) ? [prefs[@"batteryCharging"] stringValue] : @"#255";
	batteryChargingFull = prefs[@"batteryChargingFull"] && !([prefs[@"batteryChargingFull"] isEqualToString:@""]) ? [prefs[@"batteryChargingFull"] stringValue] : @"#255";
	batteryDischarging = prefs[@"batteryDischarging"] && !([prefs[@"batteryDischarging"] isEqualToString:@""]) ? [prefs[@"batteryDischarging"] stringValue] : @"#255";
	lowbatterypercentage = prefs[@"lowbatterypercentage"] && !([prefs[@"lowbatterypercentage"] isEqualToString:@""]) ? [prefs[@"lowbatterypercentage"] stringValue] : @"20";
	batteryLow = prefs[@"batteryLow"] && !([prefs[@"batteryLow"] isEqualToString:@""]) ? [prefs[@"batteryLow"] stringValue] : @"#255";
	int xcoordinates = prefs[@"xcoordinates"] ? [prefs[@"xcoordinates"] intValue] : 95;
	coordinatesForX = (float)xcoordinates;
	int ycoordinates = prefs[@"ycoordinates"] ? [prefs[@"ycoordinates"] intValue] : 95;
	coordinatesForY = (float)ycoordinates;
	int sizeicon = prefs[@"iconsize"] ? [prefs[@"iconsize"] intValue] : 5;
	iconSize = (float)sizeicon;
	int alphavalue = prefs[@"alpha"] ? [prefs[@"alpha"] intValue] : 100;
	alpha = (float)alphavalue/100;
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(frontDisplayDidChange:), (IMP)&_logos_method$_ungrouped$SpringBoard$frontDisplayDidChange$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$);}Class _logos_class$_ungrouped$SBUIController = objc_getClass("SBUIController"); { MSHookMessageEx(_logos_class$_ungrouped$SBUIController, @selector(updateBatteryState:), (IMP)&_logos_method$_ungrouped$SBUIController$updateBatteryState$, (IMP*)&_logos_orig$_ungrouped$SBUIController$updateBatteryState$);}} }
#line 173 "Tweak.x"
