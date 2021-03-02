#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "NSTask.h"

@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end

@interface BDPRootListController : PSListController
@end
