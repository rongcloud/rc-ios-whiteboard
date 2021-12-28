//
//  UIView+MBProgressHUD.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/27.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RCWBCommonDefine.h"

@implementation UIView (MBProgressHUD)

- (void)showMessage:(NSString *)message {
    [self showMessage:message showTime:1];
}

- (void)showMessage:(NSString *)message showTime:(int)showTime {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = HEXCOLOR(0x4C4C4C);
    hud.contentColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:16];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, showTime * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self animated:YES];
    });
}

@end
