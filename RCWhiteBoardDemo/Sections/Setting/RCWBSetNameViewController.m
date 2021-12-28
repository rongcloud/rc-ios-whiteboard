//
//  RCWBSetNameViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/3.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBSetNameViewController.h"
#import "RCWBCommonDefine.h"
#import <Masonry/Masonry.h>
#import "RCWBUserCenter.h"
#import "RCTextField.h"

@interface RCWBSetNameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) RCTextField *nameTextField;

@end

@implementation RCWBSetNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.nameTextField];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.right.equalTo(self.view);
        make.height.offset(45);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.right.equalTo(self.bgView).inset(19);
    }];
    
    [self setNavi];
    [self setLeftView:self.nameTextField];
    
    self.nameTextField.text = [RCWBUserCenter standardUserCenter].nickName;
}

- (void)setNavi {
    self.title = @"更改昵称";
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveButton setTitleColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.85] forState:UIControlStateNormal];
    [saveButton setTitleColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.35] forState:UIControlStateDisabled];
    
    [saveButton addTarget:self action:@selector(saveNickName) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)setLeftView:(UITextField *)textField {
    CGRect frame = textField.frame;
    frame.size.width = 35;
    frame.origin.x = 19;
    UILabel *leftView = [[UILabel alloc] initWithFrame:frame];
    leftView.text = @"昵称";
    leftView.font = [UIFont systemFontOfSize:14];
    leftView.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.45];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
}

#pragma mark - Target Action
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self validateName:string] || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = textField.text.length > 0;
    NSInteger kMaxLength = 8;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else {//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

- (void)saveNickName {
    [RCWBUserCenter standardUserCenter].nickName = self.nameTextField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefresh" object:@"" userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

// 只支持汉字、英文字母、数字
- (BOOL)validateName:(NSString *)string {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:string];
}

#pragma mark - Setter && Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (RCTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[RCTextField alloc] init];
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.tag = 1003;
        [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _nameTextField.delegate = self;
        _nameTextField.userInteractionEnabled = YES;
        _nameTextField.adjustsFontSizeToFitWidth = YES;
        _nameTextField.textAlignment = NSTextAlignmentRight;
        _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入昵称" attributes:@{NSForegroundColorAttributeName : [HEXCOLOR(0x000000) colorWithAlphaComponent:0.25], NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    }
    return _nameTextField;
}

@end
