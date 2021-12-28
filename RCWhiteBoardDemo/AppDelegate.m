//
//  AppDelegate.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/6.
//

#import "AppDelegate.h"
#import <RCWhiteBoardLib/RCWhiteBoard.h>
#import "RCWBLoginViewController.h"
#import "RCWBMainViewController.h"
#import "RCWBUserCenter.h"
#import "RCWBNavigationController.h"
#import <Bugly/Bugly.h>

#define LOG_EXPIRE_TIME -7 * 24 * 60 * 60

@interface AppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier backIden;
@property (nonatomic, strong) NSTimer *stayAliveTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    // 日志重定向
//    if (![[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"]) {
//        [self redirectNSlogToDocumentFolder];
//    }
    
    [Bugly startWithAppId:@"1c70edeff4"];
    
    [self loginAndEnterMainPage];
    
    // 设置永不息屏
    [self setIdleTimerDisabled];
    
    if (@available(iOS 13.0,*)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    return YES;
}

- (void)loginAndEnterMainPage {
    if ([RCWBUserCenter standardUserCenter].token.length > 0 && [RCWBUserCenter standardUserCenter].userId.length > 0) {
        RCWBMainViewController *mainVC = [[RCWBMainViewController alloc] init];
        RCWBNavigationController *nav = [[RCWBNavigationController alloc] initWithRootViewController:mainVC];
        self.window.rootViewController = nav;
    } else {
        RCWBLoginViewController *vc = [[RCWBLoginViewController alloc] init];
        RCWBNavigationController *nav = [[RCWBNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
}


#pragma mark - 申请后台任务
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self beginTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endBack];
}


- (void)beginTask {
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBack];
    }];
}

- (void)endBack {
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

/** 允许转向 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    if (self.isLandscape) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

//重定向 log 到本地文件
//在 info.plist 中打开 Application supports iTunes file sharing
- (void)redirectNSlogToDocumentFolder {
    NSLog(@"Log重定向到本地，如果您需要控制台Log，注释掉重定向逻辑即可。");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];

    [self removeExpireLogFiles:documentDirectory];

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];

    NSString *fileName = [NSString stringWithFormat:@"rcwithboard%@.log", formattedDate];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];

    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (void)removeExpireLogFiles:(NSString *)logPath {
    //删除超过时间的log文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:logPath error:nil]];
    NSDate *currentDate = [NSDate date];
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:LOG_EXPIRE_TIME];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *fileComp = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |
                          NSCalendarUnitMinute | NSCalendarUnitSecond;
    fileComp = [calendar components:unitFlags fromDate:currentDate];
    for (NSString *fileName in fileList) {
        // rcMMddHHmmss.log length is 16
        if (fileName.length != 16) {
            continue;
        }
        if (![[fileName substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"rc"]) {
            continue;
        }
        int month = [[fileName substringWithRange:NSMakeRange(2, 2)] intValue];
        int date = [[fileName substringWithRange:NSMakeRange(4, 2)] intValue];
        if (month > 0) {
            [fileComp setMonth:month];
        } else {
            continue;
        }
        if (date > 0) {
            [fileComp setDay:date];
        } else {
            continue;
        }
        NSDate *fileDate = [calendar dateFromComponents:fileComp];

        if ([fileDate compare:currentDate] == NSOrderedDescending ||
            [fileDate compare:expireDate] == NSOrderedAscending) {
            [fileManager removeItemAtPath:[logPath stringByAppendingPathComponent:fileName] error:nil];
        }
    }
}

- (void)setIdleTimerDisabled {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.stayAliveTimer = [NSTimer scheduledTimerWithTimeInterval:29.0
                                                           target:self
                                                         selector:@selector(callEveryTwentySeconds)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)callEveryTwentySeconds {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

@end
