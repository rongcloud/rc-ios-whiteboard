//
//  RCWBSettingViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/30.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBSettingViewController.h"
#import <Masonry/Masonry.h>
#import "RCWBCommonDefine.h"
#import "RCWBUserCenter.h"
#import "RCWBSetNameViewController.h"
#import "RCWBLoginViewController.h"
#import <GCDWebServer/GCDWebUploader.h>

@interface RCWBSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *logoutButton;

// Debug 相关
@property (nonatomic, strong) NSDate *firstClickDate;
@property (nonatomic, assign) NSUInteger clickTimes;
@property (nonatomic, strong) GCDWebUploader *webUploader;

@end

@implementation RCWBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = HEXCOLOR(0xEDEDED);
    self.firstClickDate = nil;
    self.clickTimes = 0;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logoutButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(89);
    }];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.offset(47);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefresh) name:@"NeedRefresh" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.webUploader.running) {
        [self.webUploader stop];
        self.webUploader = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NeedRefresh" object:nil];
}

#pragma mark - Target Action
- (void)logout {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self cleanUser];
        
        RCWBLoginViewController *loginVC = [[RCWBLoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.view.window.rootViewController = navi;
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)cleanUser {
    [RCWBUserCenter standardUserCenter].nickName = @"";
    [RCWBUserCenter standardUserCenter].token = @"";
    [RCWBUserCenter standardUserCenter].userId = @"";
//    [RCWBUserCenter standardUserCenter].wbClient = nil;
}

- (void)needRefresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)startHttpServer {
    NSString *homePath = NSHomeDirectory();
    self.webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:homePath];
    if ([self.webUploader start]) {
        NSString *host = self.webUploader.serverURL.absoluteString;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:host message:@"请在电脑浏览器打开上面的地址" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:nil];
            });
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        NSLog(@"web uploader host:%@ port:%@", host, @(self.webUploader.port));
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"账号";
        cell.detailTextLabel.text = [RCWBUserCenter standardUserCenter].phoneNumber;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = [RCWBUserCenter standardUserCenter].nickName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.45];
    cell.detailTextLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.85];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.clickTimes == 0) {
            self.firstClickDate = [[NSDate alloc] init];
            self.clickTimes = 1;
        } else if ([self.firstClickDate timeIntervalSinceNow] > -3) {
            self.clickTimes++;
            if (self.clickTimes >= 5) {
                [self startHttpServer];
            }
        } else {
            self.clickTimes = 0;
            self.firstClickDate = nil;
        }
        
    }
    if (indexPath.row == 1) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:nil];
        RCWBSetNameViewController *setNameVC = [[RCWBSetNameViewController alloc] init];
        [self.navigationController pushViewController:setNameVC animated:YES];
    }
}

#pragma mark - Getter && Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.scrollEnabled = NO;
        [_tableView setSectionIndexColor:[UIColor clearColor]];
    }
    return _tableView;
}

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.backgroundColor = [UIColor whiteColor];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:HEXCOLOR(0x1E85FF) forState:UIControlStateNormal];
    }
    return _logoutButton;
}

@end
