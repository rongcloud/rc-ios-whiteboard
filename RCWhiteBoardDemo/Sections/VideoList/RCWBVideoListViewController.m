//
//  RCWBVideoListViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/29.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBVideoListViewController.h"
#import "RCWBVideoListCell.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "RCWBVideoModel.h"
#import "RCWBCommonDefine.h"
#import <MJRefresh/MJRefresh.h>
#import "HTTPUtility.h"
#import "UIView+MBProgressHUD.h"
#import "RCWBUserCenter.h"
#import "RCWBPlayVideoViewController.h"

@interface RCWBVideoListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *videoList;

@property (nonatomic, assign) int offset;
@property (nonatomic, assign) int limit;
@property (nonatomic, assign) long rsTime;
@property (nonatomic, assign) long reTime;

@end

@implementation RCWBVideoListViewController {
    MBProgressHUD *progressHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"录像回放";
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView registerClass:[RCWBVideoListCell class] forCellReuseIdentifier:@"RCWBVideoListCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self addRefreshView];
    
    // 默认数据
    self.offset = 0;
    self.limit = 20;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    self.reTime = time;
    self.rsTime = time - 24*60*60;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

- (void)addRefreshView {
    __weak __typeof(self) weakSelf =self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)loadNewData {
    self.offset = 0;
    [self fetchData:self.offset limit:self.limit];
}

- (void)loadMoreData {
    self.offset += 1;
    [self fetchData:self.offset limit:self.limit];
}

- (void)fetchData:(int)offset limit:(NSInteger)limit {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(offset) forKey:@"offset"];
    [parameters setObject:@(limit) forKey:@"limit"];
    [parameters setObject:@(self.rsTime) forKey:@"rsTime"];
    [parameters setObject:@(self.reTime) forKey:@"reTime"];
    
    [HTTPUtility requestWithHTTPMethod:HTTPMethodGet URLString:@"/records" parameters:parameters response:^(HTTPResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (offset == 0) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        });
        if (result.code == 10000) {
            NSDictionary *dict = (NSDictionary *)result.content;
            NSArray *hubRecords = dict[@"hubRecords"];
            NSMutableArray *datas = [[NSMutableArray alloc] init];
            for (NSDictionary *record in hubRecords) {
                RCWBVideoModel *model = [self mapModel:record];
                [datas addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (offset == 0) {
                    self.tableView.mj_footer.hidden = NO;
                    self.videoList = [datas copy];
                } else {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.videoList];
                    [tempArray addObjectsFromArray:datas];
                    if (datas.count < limit) {
                        self.tableView.mj_footer.hidden = YES;
                    }
                    self.videoList = [tempArray copy];
                }
                [self.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view showMessage:@"请求失败"];
            });
        }
    }];
}

- (RCWBVideoModel *)mapModel:(NSDictionary *)dict {
    RCWBVideoModel *model = [[RCWBVideoModel alloc] init];
    model.hubId = dict[@"hubId"];
    model.hubName = dict[@"hubName"];
    model.Id = dict[@"id"];
    model.recordedTime = dict[@"recordedTime"];
    model.sessionId = dict[@"sessionId"];
    model.serverId = dict[@"serverId"];
    model.url = dict[@"url"];
    model.userId = dict[@"userId"];
    long long duration = [dict[@"duration"] longLongValue];
    model.duration = (int)ceil(duration / 1000.0);
    return model;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCWBVideoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RCWBVideoListCell"];
    if (!cell) {
        cell = [[RCWBVideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCWBVideoListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RCWBVideoModel *model = self.videoList[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCWBVideoModel *model = self.videoList[indexPath.row];
    
    RCWBRecordConfig *param = [[RCWBRecordConfig alloc] init];
    param.roomId = model.hubId;
    param.token = [RCWBUserCenter standardUserCenter].token;
    param.appKey = RCWBAPPKEY;
    param.userId = [RCWBUserCenter standardUserCenter].userId;
    param.userName = [RCWBUserCenter standardUserCenter].nickName;
    param.url = model.url;

    RCWBPlayVideoViewController *playVideoVC = [[RCWBPlayVideoViewController alloc] initWithRecordParam:param];
    playVideoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:playVideoVC animated:NO completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        RCWBVideoModel *model = self.videoList[indexPath.row];
        
        progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.contentColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [progressHUD showAnimated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"/records?recordIds=%@", model.Id];
        
        [HTTPUtility requestWithHTTPMethod:HTTPMethodDelete URLString:urlString parameters:nil response:^(HTTPResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->progressHUD hideAnimated:YES];
            });
            if (result.code == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.videoList];
                    [array removeObjectAtIndex:indexPath.row];
                    self.videoList = [array copy];
                    [self.view showMessage:@"删除成功"];
                    [self.tableView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view showMessage:@"删除失败"];
                });
            }
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - Getter && Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setSectionIndexColor:[UIColor clearColor]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 120;
    }
    return _tableView;
}
@end
