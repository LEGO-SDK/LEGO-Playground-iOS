//
//  ViewController.m
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/13.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "PGAPIViewController.h"
#import <LEGO-SDK/LGOWKWebView.h>
#import <LEGO-SDK/LGOWebView.h>
@interface PGAPIViewController ()

@end

@implementation PGAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"API";
    [self setupWebView];
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}
- (void)setupWebView {
    NSString *homePageURLString = [[NSUserDefaults standardUserDefaults] objectForKey:kHomePageURLStringKey];
    if (! homePageURLString) {
        homePageURLString = kDefaultHomePageURLString;
    }
    NSURL *URL = [NSURL URLWithString:homePageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        //        [((LGOWKWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
        [((LGOWKWebView *)self.webView) loadRequest:request];
    } else {
        //        [((LGOWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
        [((LGOWKWebView *)self.webView) loadRequest:request];
    }
}

- (void)reload {
    [self setupWebView];
}

- (IBAction)githubItemAction:(id)sender {
    LGOBaseViewController *githubViewController = [LGOBaseViewController new];
    githubViewController.url = [NSURL URLWithString:@"https://github.com/LEGO-SDK"];
    githubViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:githubViewController animated:YES];
}
@end
