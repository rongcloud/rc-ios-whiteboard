//
//  RCWBMainViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/28.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBMainViewController.h"
#import "RCWBMainCell.h"
#import <Masonry/Masonry.h>
#import "RCWBCommonDefine.h"
#import "RCWBSettingViewController.h"
#import "RCWBVideoListViewController.h"
#import "RCWBJoinRoomViewController.h"

@interface RCWBMainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RCWBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    UIImage *image = [UIImage imageNamed:@"main-bg"];
    self.view.layer.contents = (id)image.CGImage;
    
    [self.tableView registerClass:[RCWBMainCell class] forCellReuseIdentifier:@"RCWBMainCell"];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tableView];
    
    CGFloat statusBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight += statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight += UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(34 + statusBarHeight);
        make.centerX.equalTo(self.view);
        make.height.offset(24);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(32);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = HEXCOLOR(0x1E85FF);
}

#pragma mark - Target Action
- (void)didTapLeftNaviBar {
    NSLog(@"didTapLeftNaviBar");
    RCWBSettingViewController *vc = [[RCWBSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapRightNaviBar {
    RCWBVideoListViewController *vc = [[RCWBVideoListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCWBMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RCWBMainCell"];
    if (!cell) {
        cell = [[RCWBMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCWBMainCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell setTitle:@"演示者加入" image:[UIImage imageNamed:@"main-write"]];
    } else {
        [cell setTitle:@"观看者加入" image:[UIImage imageNamed:@"main-read"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCWBJoinRoomViewController *joinRoomVC = [[RCWBJoinRoomViewController alloc] init];
    if (indexPath.row == 0) {
        joinRoomVC.roleType = RCWBRoleType_PRESENTER;
    } else {
        joinRoomVC.roleType = RCWBRoleType_VIEWER;
    }
    [self.navigationController pushViewController:joinRoomVC animated:YES];
}

#pragma mark - Private Method
- (void)setNavi {
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"main-setting"]
                                                                style:(UIBarButtonItemStylePlain)
                                                               target:self
                                                               action:@selector(didTapLeftNaviBar)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"main-video-list"]
                                                                style:(UIBarButtonItemStylePlain)
                                                               target:self
                                                               action:@selector(didTapRightNaviBar)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}


#pragma mark - Getter && Setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"欢迎加入融云白板";
        _titleLabel.font = [UIFont systemFontOfSize:24];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 124;
        _tableView.scrollEnabled = NO;
        [_tableView setSectionIndexColor:[UIColor clearColor]];
    }
    return _tableView;
}

@end
