//
//  RCWBPlayVideoViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/20.
//

#import "RCWBPlayVideoViewController.h"
#import "RCWBUserCenter.h"
#import "AppDelegate.h"
#import "UIView+MBProgressHUD.h"

@interface RCWBPlayVideoViewController ()<RCWBRoomStatusProtocol>

@property (nonatomic, strong) RCWBRecordConfig *recordParam;

@property (nonatomic, strong) RCWhiteBoard *whiteBoard;

@property (nonatomic, strong) RCWBWebView *webView;

@end

@implementation RCWBPlayVideoViewController

- (instancetype)initWithRecordParam:(RCWBRecordConfig *)recordParam {
    if (self = [super init]) {
        self.recordParam = recordParam;
    }
    return self;
}

- (void)setupViews {
    
    [self prefersStatusBarHidden];
    self.webView = [[RCWBWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
}

- (void)initRCWBSDK {
    // 初始化 SDK
    self.whiteBoard = [[RCWhiteBoard alloc] initWithWebView:self.webView];
    
    // 设置 webView 的代理
    self.webView.roomStatusDelegate = self;
}

- (void)joinWhiteBoard {
    [self.whiteBoard playWithConfig:self.recordParam success:^() {
        NSLog(@"play record success");
    } error:^(RCWBErrorCode code, NSString * _Nonnull desc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentAlertController:nil message:@"录像播放失败"];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self initRCWBSDK];
    [self joinWhiteBoard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isLandscape = YES;
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isLandscape = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

#pragma mark - RCWBRoomStatusProtocol
- (void)onWBRoomQuit {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)onWBRoomException:(RCWBException *)exception {
    [self presentAlertController:nil message:exception.msg];
}

#pragma mark - Target Action
- (void)presentAlertController:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
    }];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 控制方向
/// ***是否可以自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

/// ***刚开始的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end
