//
//  RCWBLoginViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/27.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBLoginViewController.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HTTPUtility.h"
#import "UIView+MBProgressHUD.h"
#import "RCWBCommonDefine.h"
#import "RCWBMainViewController.h"
#import "RCWBUserCenter.h"
#import "RCWBWebViewController.h"
#import "RCTextField.h"

@interface RCWBLoginViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) RCTextField *phoneTextField;

@property (nonatomic, strong) UILabel *codeLabel;

@property (nonatomic, strong) RCTextField *codeTextField;

@property (nonatomic, strong) UIButton *getCodeButton;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *boxButton;

@property (nonatomic, strong) UIButton *termsButton;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation RCWBLoginViewController {
    MBProgressHUD *progressHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.codeLabel];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.getCodeButton];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.boxButton];
    [self.view addSubview:self.termsButton];
    [self.view addSubview:self.versionLabel];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.offset(80);
        make.top.equalTo(self.view).offset(24);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(14);
        make.centerX.equalTo(self.view);
        make.height.offset(28);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(9);
        make.left.equalTo(self.view).offset(16);
        make.height.offset(22);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(16);
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(9);
        make.height.offset(47);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(20);
        make.left.height.equalTo(self.phoneLabel);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(8);
        make.left.height.equalTo(self.phoneTextField);
        make.right.equalTo(self.getCodeButton.mas_left).offset(-12);
    }];
    
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-16);
        make.top.bottom.equalTo(self.codeTextField);
        make.width.offset(107);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(16);
        make.top.equalTo(self.codeTextField.mas_bottom).offset(20);
        make.height.equalTo(self.getCodeButton);
    }];
    
    [self.boxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_centerX).offset(-4);
    }];
    
    [self.termsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.boxButton);
        make.left.equalTo(self.view.mas_centerX).offset(-4);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.termsButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.left.right.equalTo(self.view).inset(20);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-17);
        } else {
            make.bottom.equalTo(self.view).offset(-17);
        }
        make.left.right.equalTo(self.view).inset(20);
        make.height.offset(17);
    }];
    
    [self setLeftView:self.phoneTextField];
    [self setLeftView:self.codeTextField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - Target Action
- (void)didTapView {
    if (self.codeTextField.isFirstResponder) {
        [self.codeTextField resignFirstResponder];
    }
    
    if (self.phoneTextField.isFirstResponder) {
        [self.phoneTextField resignFirstResponder];
    }
}

- (void)sendVerificationCode {
    
    // 校验手机号
    if (!self.phoneTextField.text.length) {
        [self.view showMessage:@"请输入手机号"];
        return;
    }
    
    if (self.phoneTextField.text.length < 11) {
        [self.view showMessage:@"请输入有效的手机号"];
        return;
    }
    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.contentColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [progressHUD showAnimated:YES];
    
    NSDictionary *parameters = @{@"region": @"86", @"phone": self.phoneTextField.text};
    [HTTPUtility requestWithHTTPMethod:HTTPMethodPost URLString:@"/user/send_code" parameters:parameters response:^(HTTPResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->progressHUD hideAnimated:YES];
            if (result.code == 200) {
                NSLog(@"request send_code susscess");
                [self.view showMessage:@"验证码已发送"];
                [self countDown:60];
            } else if (result.code == 5000) {
                [self.view showMessage:@"验证码发送频繁，请稍后再试"];
            } else {
                [self.view showMessage:@"发送失败，请重试"];
                NSLog(@"request send_code error");
            }
        });
    }];
}

- (void)login {
    // 校验手机号
    if (!self.phoneTextField.text.length) {
        [self.view showMessage:@"请输入有效的手机号"];
        return;
    }
    
    // 校验验证码
    if (!self.codeTextField.text.length) {
        [self.view showMessage:@"请输入验证码"];
        return;
    }
    
    if (!self.boxButton.isSelected) {
        [self.view showMessage:@"请先阅读并同意注册条款"];
        return;
    }

    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.contentColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [progressHUD showAnimated:YES];
    NSDictionary *parameters = @{@"region": @"86", @"phone": self.phoneTextField.text, @"code": self.codeTextField.text};
    [HTTPUtility requestWithHTTPMethod:HTTPMethodPost URLString:@"/user/verify_code_register" parameters:parameters response:^(HTTPResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->progressHUD hideAnimated:YES];
            if (result.code == 200) {
                NSLog(@"request verify_code_register susscess");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.timer){
                        dispatch_source_cancel(self.timer);
                        self.timer = nil;
                    }
                    [self.view showMessage:@"登录成功"];
                    NSDictionary *dict = [(NSDictionary *)result.content objectForKey:@"result"];
                    [RCWBUserCenter standardUserCenter].phoneNumber = self.phoneTextField.text;
                    [RCWBUserCenter standardUserCenter].nickName = dict[@"nickName"];
                    [RCWBUserCenter standardUserCenter].userId = dict[@"id"];
                    [RCWBUserCenter standardUserCenter].token = dict[@"token"];
                    
                    RCWBMainViewController *mainVC = [[RCWBMainViewController alloc] init];
                    UINavigationController *rootNavi = [[UINavigationController alloc] initWithRootViewController:mainVC];
                    [UIApplication sharedApplication].delegate.window.rootViewController = rootNavi;
                });
            } else if (result.code == 1000 || result.code == 2000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view showMessage:@"验证码错误"];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view showMessage:@"验证码错误"];
                });
            }
        });
    }];
}

- (void)agreeTerms {
    self.boxButton.selected = !self.boxButton.selected;
}

- (void)pushToWebView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement_zh" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        RCWBWebViewController *webViewVC = [[RCWBWebViewController alloc] initWithUrl:url];
        [self.navigationController pushViewController:webViewVC animated:YES];
    });
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.tag == 1000) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
//        if (!self.timer) {
//            if (textField.text.length == 11) {
//                self.getCodeButton.enabled = YES;
//                self.getCodeButton.backgroundColor = HEXCOLOR(0x1E85FF);
//            } else {
//                self.getCodeButton.enabled = NO;
//                self.getCodeButton.backgroundColor = HEXCOLOR(0xCBCCCE);
//            }
//        }
    } else if (textField.tag == 1001) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
    
    if (self.phoneTextField.text.length == 11 && self.codeTextField.text.length > 0) {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = HEXCOLOR(0x1E85FF);
    } else {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = HEXCOLOR(0xCBCCCE);
    }
    
}

#pragma mark - Private Method
- (void)countDown:(int)seconds {
    self.getCodeButton.enabled = NO;
    self.getCodeButton.backgroundColor = [UIColor whiteColor];
    self.getCodeButton.layer.borderWidth = 1;
    [self.getCodeButton setTitleColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.55] forState:UIControlStateNormal];
    __block NSInteger second = seconds;
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                self.getCodeButton.layer.borderWidth = 0;
                self.getCodeButton.enabled = YES;
                self.getCodeButton.backgroundColor = HEXCOLOR(0x1E85FF);
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
                [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                dispatch_cancel(self.timer);
                self.timer = nil;
            } else {
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)second] forState:UIControlStateNormal];
                second--;
            }
        });
    });
    dispatch_resume(self.timer);
}

- (void)setLeftView:(UITextField *)textField {
    CGRect frame = textField.frame;
    frame.size.width = 14;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
}

#pragma mark - Setter && Getter
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"login-logo"];
    }
    return _logoImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"融云白板";
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = HEXCOLOR(0x333333);
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = @"账号";
        _phoneLabel.font = [UIFont systemFontOfSize:16];
        _phoneLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.85];
    }
    return _phoneLabel;
}

- (RCTextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[RCTextField alloc] init];
        _phoneTextField.backgroundColor = [HEXCOLOR(0x999999) colorWithAlphaComponent:0.06];
        _phoneTextField.tag = 1000;
        [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneTextField.userInteractionEnabled = YES;
        _phoneTextField.adjustsFontSizeToFitWidth = YES;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName : [HEXCOLOR(0x000000) colorWithAlphaComponent:0.25], NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _phoneTextField.layer.borderWidth = 1;
        _phoneTextField.layer.borderColor = [[HEXCOLOR(0xE4E4E4) colorWithAlphaComponent:0.6] CGColor];
        _phoneTextField.layer.cornerRadius = 5;
        _phoneTextField.text = [RCWBUserCenter standardUserCenter].phoneNumber;
    }
    return _phoneTextField;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.text = @"验证码";
        _codeLabel.font = [UIFont systemFontOfSize:16];
        _codeLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.85];
    }
    return _codeLabel;
}

- (RCTextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[RCTextField alloc] init];
        _codeTextField.backgroundColor = [HEXCOLOR(0x999999) colorWithAlphaComponent:0.06];
        _codeTextField.tag = 1001;
        _codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName : [HEXCOLOR(0x000000) colorWithAlphaComponent:0.25], NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _codeTextField.textColor = [UIColor blackColor];
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.layer.borderWidth = 1;
        _codeTextField.layer.borderColor = [[HEXCOLOR(0xE4E4E4) colorWithAlphaComponent:0.6] CGColor];
        _codeTextField.layer.cornerRadius = 5;
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _codeTextField;
}

- (UIButton *)getCodeButton {
    if (!_getCodeButton) {
        _getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeButton.enabled = YES;
        _getCodeButton.backgroundColor = HEXCOLOR(0x1E85FF);
        _getCodeButton.layer.cornerRadius = 5;
        _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_getCodeButton addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getCodeButton.layer.borderWidth = 0;
        _getCodeButton.layer.borderColor = [HEXCOLOR(0xE4E4E4) colorWithAlphaComponent:0.6].CGColor;
    }
    return _getCodeButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = HEXCOLOR(0xCBCCCE);
        _loginButton.enabled = NO;
        _loginButton.layer.cornerRadius = 5;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UIButton *)boxButton {
    if (!_boxButton) {
        _boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _boxButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_boxButton addTarget:self action:@selector(agreeTerms) forControlEvents:UIControlEventTouchUpInside];
        [_boxButton setImage:[UIImage imageNamed:@"login-terms"] forState:UIControlStateNormal];
        [_boxButton setImage:[UIImage imageNamed:@"login-terms-selected"] forState:UIControlStateSelected];
        [_boxButton setTitle:@" 同意" forState:UIControlStateNormal];
        [_boxButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:UIControlStateNormal];
    }
    return _boxButton;
}

- (UIButton *)termsButton {
    if (!_termsButton) {
        _termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _termsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_termsButton addTarget:self action:@selector(pushToWebView) forControlEvents:UIControlEventTouchUpInside];
        [_termsButton setTitle:@"《注册条款》" forState:UIControlStateNormal];
        [_termsButton setTitleColor:[HEXCOLOR(0x1E85FF) colorWithAlphaComponent:1] forState:UIControlStateNormal];
    }
    return _termsButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        _tipLabel.text = @"新登录用户即注册开通融云开发者账号";
    }
    return _tipLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont systemFontOfSize:12];
        _versionLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.45];
        _versionLabel.text = @"融云白板 v1.0.0";
    }
    return _versionLabel;
}

@end
