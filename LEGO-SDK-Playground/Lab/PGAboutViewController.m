//
//  PGAboutViewController.m
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/29.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "PGAboutViewController.h"
#import <LEGO-SDK/LGOWKWebView.h>
#import <LEGO-SDK/LGOWebView.h>
@interface PGAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@end

@implementation PGAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [((LGOWKWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
    } else {
        [((LGOWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
    }
    self.webView.hidden = YES;
    self.title = @"关于";
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] && [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]) {
        self.summaryLabel.text = [NSString stringWithFormat:@"LEGO SDK V%@(%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    }
}
@end
