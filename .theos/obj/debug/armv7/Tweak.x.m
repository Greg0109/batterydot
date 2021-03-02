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

static NSString *plistPath = @"/var/mobile/Library/Preferences/com.greg0109.batterydotprefs.plist";

CGFloat coordinatesForX;
CGFloat coordinatesForY;
UILabel *notificationLabel;
UIColor *chosenColor;

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

@class UIStatusBarWindow; 
static void _logos_method$_ungrouped$UIStatusBarWindow$loadNotificationIcon(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$UIStatusBarWindow$setStatusBar$)(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$UIStatusBarWindow$setStatusBar$(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST, SEL, id); 

#line 59 "Tweak.x"

__attribute__((used)) static UILabel * _logos_method$_ungrouped$UIStatusBarWindow$label(UIStatusBarWindow * __unused self, SEL __unused _cmd) { return (UILabel *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$UIStatusBarWindow$label); }; __attribute__((used)) static void _logos_method$_ungrouped$UIStatusBarWindow$setLabel(UIStatusBarWindow * __unused self, SEL __unused _cmd, UILabel * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$UIStatusBarWindow$label, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }


static void _logos_method$_ungrouped$UIStatusBarWindow$loadNotificationIcon(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	CGFloat screenwidth = [[UIScreen mainScreen] bounds].size.width;
	coordinatesForX = (coordinatesForX*screenwidth)/100;
	CGFloat screenheight = [[UIScreen mainScreen] bounds].size.height;
	coordinatesForY = (coordinatesForY*screenheight)/100;

	CGRect labelFrame = CGRectMake(coordinatesForX , coordinatesForY, 10, 10);

	notificationLabel = [[UILabel alloc] initWithFrame:labelFrame];
	notificationLabel.backgroundColor = chosenColor;
	notificationLabel.textAlignment = NSTextAlignmentCenter;
	[notificationLabel setFont:[UIFont systemFontOfSize:12]];
	notificationLabel.textColor = [UIColor clearColor];
	notificationLabel.numberOfLines = 0;
	notificationLabel.lineBreakMode = NSLineBreakByWordWrapping;
	notificationLabel.text = [NSString stringWithFormat:@" "];
	notificationLabel.layer.cornerRadius = 10;
	notificationLabel.layer.masksToBounds = TRUE;

	[self addSubview:notificationLabel];
	self.label = notificationLabel;
	self.label.alpha = 1;
}

static void _logos_method$_ungrouped$UIStatusBarWindow$setStatusBar$(_LOGOS_SELF_TYPE_NORMAL UIStatusBarWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
	_logos_orig$_ungrouped$UIStatusBarWindow$setStatusBar$(self, _cmd, arg1);
	[self loadNotificationIcon];
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.greg0109.batterydotprefs.showIcon" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
		NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
		int xcoordinates = prefs[@"xcoordinates"] ? [prefs[@"xcoordinates"] intValue] : 95;
		coordinatesForX = float(xcoordinates);
		int ycoordinates = prefs[@"ycoordinates"] ? [prefs[@"ycoordinates"] intValue] : 95;
		coordinatesForY = float(ycoordinates);

		CGFloat screenwidth = [[UIScreen mainScreen] bounds].size.width;
		coordinatesForX = (coordinatesForX*screenwidth)/100;
		CGFloat screenheight = [[UIScreen mainScreen] bounds].size.height;
		coordinatesForY = (coordinatesForY*screenheight)/100;

		CGRect labelFrame = CGRectMake(coordinatesForX , coordinatesForY, 10, 10);
		notificationLabel.frame = labelFrame;
	}];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.greg0109.batterydotprefs.showIcon" object:nil userInfo:nil];
}


static __attribute__((constructor)) void _logosLocalCtor_f67a23ac(int __unused argc, char __unused **argv, char __unused **envp) {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	NSString *colorString = prefs[@"color"] && !([prefs[@"color"] isEqualToString:@""]) ? [prefs[@"color"] stringValue] : @"#E22300";
	chosenColor = colorWithHexString(colorString);
	int xcoordinates = prefs[@"xcoordinates"] ? [prefs[@"xcoordinates"] intValue] : 95;
	coordinatesForX = float(xcoordinates);
	int ycoordinates = prefs[@"ycoordinates"] ? [prefs[@"ycoordinates"] intValue] : 95;
	coordinatesForY = float(ycoordinates);
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIStatusBarWindow = objc_getClass("UIStatusBarWindow"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UIStatusBarWindow, @selector(loadNotificationIcon), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$loadNotificationIcon, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$UIStatusBarWindow, @selector(setStatusBar:), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$setStatusBar$, (IMP*)&_logos_orig$_ungrouped$UIStatusBarWindow$setStatusBar$);}{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UILabel *)); class_addMethod(_logos_class$_ungrouped$UIStatusBarWindow, @selector(label), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$label, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UILabel *)); class_addMethod(_logos_class$_ungrouped$UIStatusBarWindow, @selector(setLabel:), (IMP)&_logos_method$_ungrouped$UIStatusBarWindow$setLabel, _typeEncoding); } } }
#line 121 "Tweak.x"
