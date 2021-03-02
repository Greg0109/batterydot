#line 1 "Tweak.x"
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

@class UIStatusBarWindow; @class SBUIController; 
static void _logos_method$_ungrouped$UIStatusBarWindow$loadNotificationIcon(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$UIStatusBarWindow$setStatusBar$)(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$UIStatusBarWindow$setStatusBar$(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBUIController$updateBatteryState$)(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBUIController$updateBatteryState$(_LOGOS_SELF_TYPE_NORMAL SBUIController* _LOGOS_SELF_CONST, SEL, id); 

#line 75 "Tweak.x"

__attribute__((used)) static UIView * _logos_method$_ungrouped$UIStatusBarWindow$view(UIStatusBarWindow * __unused self, SEL __unused _cmd) { return (UIView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$UIStatusBarWindow$view); }; __attribute__((used)) static void _logos_method$_ungrouped$UIStatusBarWindow$setView(UIStatusBarWindow * __unused self, SEL __unused _cmd, UIView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$UIStatusBarWindow$view, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }


static void _logos_method$_ungrouped$UIStatusBarWindow$loadNotificationIcon(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
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

static void _logos_method$_ungrouped$UIStatusBarWindow$setStatusBar$(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
	_logos_orig$_ungrouped$UIStatusBarWindow$setStatusBar$(self, _cmd, arg1);
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.greg0109.batterydotprefs.showIcon" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		[self loadNotificationIcon];
	}];
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
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greg0109.batterydotprefs.hideIcon" object:nil userInfo:nil]; 
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greg0109.batterydotprefs.showIcon" object:nil userInfo:nil];
	_logos_orig$_ungrouped$SBUIController$updateBatteryState$(self, _cmd, arg1);
}


static __attribute__((constructor)) void _logosLocalCtor_acffbcf9(int __unused argc, char __unused **argv, char __unused **envp) {
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
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIStatusBarWindow = objc_getClass("UIStatusBarWindow"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UIStatusBarWindow, @selector(loadNotificationIcon), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$loadNotificationIcon, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$UIStatusBarWindow, @selector(setStatusBar:), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$setStatusBar$, (IMP*)&_logos_orig$_ungrouped$UIStatusBarWindow$setStatusBar$);}{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIView *)); class_addMethod(_logos_class$_ungrouped$UIStatusBarWindow, @selector(view), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$view, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIView *)); class_addMethod(_logos_class$_ungrouped$UIStatusBarWindow, @selector(setView:), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$setView, _typeEncoding); } Class _logos_class$_ungrouped$SBUIController = objc_getClass("SBUIController"); { MSHookMessageEx(_logos_class$_ungrouped$SBUIController, @selector(updateBatteryState:), (IMP)&_logos_method$_ungrouped$SBUIController$updateBatteryState$, (IMP*)&_logos_orig$_ungrouped$SBUIController$updateBatteryState$);}} }
#line 157 "Tweak.x"
