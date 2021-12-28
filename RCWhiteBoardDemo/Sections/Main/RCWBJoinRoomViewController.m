//
//  RCWBJoinRoomViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/29.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBJoinRoomViewController.h"
#import <Masonry/Masonry.h>
#import "RCWBCommonDefine.h"
#import "RCWBUserCenter.h"
#import "RCWBRoomViewController.h"
#import "UIView+MBProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RCTextField.h"
#import "AppDelegate.h"

@interface RCWBJoinRoomViewController ()

@property (nonatomic, strong) UILabel *roleLable;

@property (nonatomic, strong) RCTextField *roomIdTextField;

@property (nonatomic, strong) UIButton *joinButton;

@end

@implementation RCWBJoinRoomViewController {
    MBProgressHUD *progressHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入房间";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.roleLable];
    [self.view addSubview:self.roomIdTextField];
    [self.view addSubview:self.joinButton];
    
    [self.roleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view).inset(10);
        make.height.offset(20);
    }];
    
    [self.roomIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roleLable.mas_bottom).offset(10);
        make.left.right.equalTo(self.view).inset(10);
        make.height.offset(40);
    }];
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomIdTextField.mas_bottom).offset(50);
        make.left.right.equalTo(self.view).inset(10);
        make.height.offset(40);
    }];
    
    [self setLeftView:self.roomIdTextField];
    
    if (self.roleType == RCWBRoleType_PRESENTER) {
        self.roleLable.text = @"您是演示者";
    } else {
        self.roleLable.text = @"您是观看者";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.isLandscape = NO;
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

#pragma mark - Target Action
- (void)join {
    RCWBRoomConfig *param = [[RCWBRoomConfig alloc] init];
    param.roomId = self.roomIdTextField.text;
    param.token = [RCWBUserCenter standardUserCenter].token;
    param.appKey = RCWBAPPKEY;
    param.userId = [RCWBUserCenter standardUserCenter].userId;
    param.userName = [RCWBUserCenter standardUserCenter].nickName;
    param.roleType = self.roleType;
    param.minutes = 24*60;
    
    RCWBRoomViewController *roomVC = [[RCWBRoomViewController alloc] initWithRoomparam:param];
    roomVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:roomVC animated:NO completion:nil];
}

#pragma mark - Target Action
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.tag == 1002) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        
        if (textField.text.length == 6) {
            self.joinButton.enabled = YES;
            self.joinButton.backgroundColor = HEXCOLOR(0x1E85FF);
        } else {
            self.joinButton.enabled = NO;
            self.joinButton.backgroundColor = HEXCOLOR(0xCBCCCE);
        }
    }
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

#pragma mark - Private Method
- (void)setLeftView:(UITextField *)textField {
    CGRect frame = textField.frame;
    frame.size.width = 14;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
}

#pragma mark - Setter && Getter
- (UILabel *)roleLable {
    if (!_roleLable) {
        _roleLable = [[UILabel alloc] init];
        _roleLable.font = [UIFont systemFontOfSize:16];
        _roleLable.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.85];
    }
    return _roleLable;
}

- (RCTextField *)roomIdTextField {
    if (!_roomIdTextField) {
        _roomIdTextField = [[RCTextField alloc] init];
        _roomIdTextField.backgroundColor = [UIColor clearColor];
        _roomIdTextField.tag = 1002;
        [_roomIdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _roomIdTextField.userInteractionEnabled = YES;
        _roomIdTextField.adjustsFontSizeToFitWidth = YES;
        _roomIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _roomIdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _roomIdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入房间号" attributes:@{NSForegroundColorAttributeName : [HEXCOLOR(0x000000) colorWithAlphaComponent:0.25], NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _roomIdTextField.layer.borderWidth = 1;
        _roomIdTextField.layer.borderColor = [[HEXCOLOR(0xE4E4E4) colorWithAlphaComponent:0.6] CGColor];
        _roomIdTextField.layer.cornerRadius = 5;
    }
    return _roomIdTextField;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinButton.layer.cornerRadius = 4;
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _joinButton.enabled = NO;
        _joinButton.backgroundColor = HEXCOLOR(0xCBCCCE);
        [_joinButton addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
        [_joinButton setTitle:@"加入房间" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _joinButton;
}

@end
