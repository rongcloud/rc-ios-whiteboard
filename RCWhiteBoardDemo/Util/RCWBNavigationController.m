//
//  RCWBNavigationController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/9/2.
//

#import "RCWBNavigationController.h"

@interface RCWBNavigationController ()

@end

@implementation RCWBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
