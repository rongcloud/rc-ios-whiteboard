//
//  RCTextField.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/16.
//

#import "RCTextField.h"

@implementation RCTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([UIMenuController sharedMenuController]) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
