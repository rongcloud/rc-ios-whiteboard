//
//  RCWBRoomViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/2.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBRoomViewController.h"
#import "RCWBUserCenter.h"
#import "AppDelegate.h"
#import "UIView+MBProgressHUD.h"
#import <Photos/PHPhotoLibrary.h>

@interface RCWBRoomViewController ()<RCWBRoomStatusProtocol, RCWBRecordProtocol, RCWBPermissionProtocol>

/// 加入白板的参数
@property (nonatomic, strong) RCWBRoomConfig *roomParam;

/// 白板实例
@property (nonatomic, strong) RCWhiteBoard *whiteBoard;

/// 用于展示白板的 VIew
@property (nonatomic, strong) RCWBWebView *webView;

@end

@implementation RCWBRoomViewController

- (instancetype)initWithRoomparam:(RCWBRoomConfig *)roomParam {
    if (self = [super init]) {
        self.roomParam = roomParam;
    }
    return self;
}

// UI 布局
- (void)setupViews {
    [self prefersStatusBarHidden];
    self.webView = [[RCWBWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
}

// 初始化白板实例
- (void)initRCWBSDK {
    self.whiteBoard = [[RCWhiteBoard alloc] initWithWebView:self.webView];
    
    // 设置相关代理
    self.webView.roomStatusDelegate = self;
    self.webView.permisssionDelegate = self;
    self.webView.recordDelegate = self;
}

// 加入白板
- (void)joinWhiteBoard {
    [self.whiteBoard joinWithConfig:self.roomParam success:^() {
        NSLog(@"join room succes");
    } error:^(RCWBErrorCode code, NSString * _Nonnull desc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentAlertController:nil message:@"加入房间失败"];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self initRCWBSDK];
    [self joinWhiteBoard];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isLandscape = YES;
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

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - RCWBRoomStatusProtocol
- (void)onWBRoomQuit {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)onWBRoomException:(RCWBException *)exception {
    [self presentAlertController:nil message:exception.msg];
}

- (void)onWBCaptureEnd:(UIImage *)image {
    
    [self checkAlbumAuthorizationStatusWithGrand:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (image) {
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                } else {
                    [self.view showMessage:@"当前页面内容保存到系统相册失败"];
                }
            } else {
                [self.view showMessage:@"当前页面内容保存到系统相册失败"];
            }
        });
    }];
}

/** 校验是否有相册权限 */
- (void)checkAlbumAuthorizationStatusWithGrand:(void (^)(BOOL granted))permissionGranted {

    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
    // 已授权
    case PHAuthorizationStatusAuthorized: {
        permissionGranted(YES);
    } break;
    // 未询问用户是否授权
    case PHAuthorizationStatusNotDetermined: {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            permissionGranted(status == PHAuthorizationStatusAuthorized);
        }];
    } break;
    // 用户拒绝授权或权限受限
    case PHAuthorizationStatusRestricted:
    case PHAuthorizationStatusDenied: {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"没有访问权限，请前往“设置-隐私-照片”选项中，允许访问您的照片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            }];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        permissionGranted(NO);
    } break;
    default:
        permissionGranted(NO);
        break;
    }
}

#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self.view showMessage:@"当前页面内容保存到系统相册失败"];
    } else {
        [self.view showMessage:@"当前页面内容保存到系统相册成功"];
    }
}

#pragma mark - RCWBRecordProtocol
- (void)onWBRecordStart {
    
}

- (void)onWBRecordEnd:(NSString *)url {
    [self presentAlertController:nil message:@"录像已保存，请在录像列表中查看"];
}

#pragma mark - RCWBPermissionProtocol
- (void)onWBPermissionChange:(RCWBPermissionType)permissionType {
    
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
/// ***刚开始的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end
