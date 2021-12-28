//
//  RCWBWebViewController.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/4.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBWebViewController.h"
#import <Masonry/Masonry.h>

@interface RCWBWebViewController ()

@property (nonatomic, copy) NSURL *url;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation RCWBWebViewController

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册条款";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

@end
