//
//  PGGuideViewController.m
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/16.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "PGGuideViewController.h"
#import <LEGO-SDK/LGOWKWebView.h>
#import <LEGO-SDK/LGOWebView.h>
@interface PGGuideViewController ()<UIBarPositioningDelegate, WKNavigationDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scollView;

@property (nonatomic, strong) UIView *embeddedWebView;

@property (nonatomic, strong) UIView *extendableWebView;
@end

@implementation PGGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Guide";
    for (UIView *aView in self.navigationController.navigationBar.subviews) {
        for (UIView *bView in aView.subviews) {
            if ([bView isKindOfClass:[UIImageView class]] &&
                bView.bounds.size.width == self.navigationController.navigationBar.frame.size.width &&
                bView.bounds.size.height < 2) {
                bView.hidden = YES;
            }
        }
    }
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)embeddedWebView {
    if (! _embeddedWebView) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kGudieEmbeddedURLString]];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            LGOWKWebView *wkWebView = [[LGOWKWebView alloc] init];
            [wkWebView loadRequest:request];
            _embeddedWebView = wkWebView;
        } else {
            LGOWebView *webView = [[LGOWebView alloc] init];
            webView.scalesPageToFit = YES;
            [webView loadRequest:request];
            _embeddedWebView = webView;
        }
    }
    return _embeddedWebView;
}

- (UIView *)extendableWebView {
    if (! _extendableWebView) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kGuideExtendableURLString]];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            LGOWKWebView *wkWebView = [[LGOWKWebView alloc] init];
            [wkWebView loadRequest:request];
            _extendableWebView = wkWebView;
        } else {
            LGOWebView *webView = [[LGOWebView alloc] init];
            webView.scalesPageToFit = YES;
            [webView loadRequest:request];
            _extendableWebView = webView;
        }
    }
    return _extendableWebView;
}

- (void)setupView {
    NSURL *URL = [NSURL URLWithString:kGuideIntroductionURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        LGOWKWebView.afterCreate = ^(LGOWKWebView *webView) {
            webView.navigationDelegate = self;
        };
        //        [((LGOWKWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
        [((LGOWKWebView *)self.webView) loadRequest:request];
    } else {
        LGOWebView.afterCreate = ^(LGOWebView *webView) {
            webView.delegate = self;
        };
        //        [((LGOWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
        [((LGOWKWebView *)self.webView) loadRequest:request];
    }
    
    self.scollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, 0);
    
}

- (void)viewDidLayoutSubviews {
    
    self.webView.frame = CGRectMake(0, 1, self.scollView.bounds.size.width, self.scollView.bounds.size.height - 1);
    [self.scollView addSubview:self.webView];
    
    self.embeddedWebView.frame = CGRectMake(self.scollView.bounds.size.width, 1, self.scollView.bounds.size.width, self.scollView.bounds.size.height - 1);
    [self.scollView addSubview:self.embeddedWebView];
    
    self.extendableWebView.frame = CGRectMake(self.scollView.bounds.size.width * 2, 1, self.scollView.bounds.size.width, self.scollView.bounds.size.height - 1);
    [self.scollView addSubview:self.extendableWebView];

}

#pragma mark UIBarPositioningDelegate
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark Action
- (IBAction)segmentedAction:(UISegmentedControl *)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        [self.scollView setContentOffset:CGPointMake(sender.selectedSegmentIndex * self.scollView.bounds.size.width, 0) animated:NO];
    }
}

#pragma mark WKWebview delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([webView.URL.absoluteString isEqualToString:kGudieEmbeddedURLString] || [webView.URL.absoluteString isEqualToString:kGuideExtendableURLString]) {
        [webView evaluateJavaScript:@"$('.book').hasClass('with-summary')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if ([result isKindOfClass:[NSNumber class]]) {
                NSNumber *numberResult = (NSNumber *)result;
                if (numberResult.boolValue) {
                    [webView evaluateJavaScript:@"$('.js-toolbar-action').eq(0).click()" completionHandler:nil];
                }
            }
        }];
    }
}

#pragma mark UIWebview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString isEqualToString:kGudieEmbeddedURLString] || [webView.request.URL.absoluteString isEqualToString:kGuideExtendableURLString]) {
        id result = [webView stringByEvaluatingJavaScriptFromString:@"$('.book').hasClass('with-summary')"];
        if ([result isKindOfClass:[NSNumber class]]) {
            NSNumber *numberResult = (NSNumber *)result;
            if (numberResult.boolValue) {
                [webView stringByEvaluatingJavaScriptFromString:@"$('.js-toolbar-action').eq(0).click()"];
            }
        }
    }
}
@end
