//
//  PGHomepageURLSettingViewController.m
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/14.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "PGHomepageURLSettingViewController.h"
#import "PGAPIViewController.h"
#import <LEGO-SDK/LGOWKWebView.h>
#import <LEGO-SDK/LGOWebView.h>
@interface PGHomepageURLSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *homePageURLTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *homepageURLLabel;
@property (strong, nonatomic) IBOutlet UILabel *resetDefaultLabel;
@property (strong, nonatomic) IBOutlet UISwitch *resetDefaultSwitch;
@end

@implementation PGHomepageURLSettingViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.title = @"首页设置";
    self.automaticallyAdjustsScrollViewInsets = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotificationAction:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)setButtonAction:(id)sender {
//    if (self.homePageURLTextField.text) {
//        [[NSUserDefaults standardUserDefaults] setObject:self.homePageURLTextField.text  forKey:kHomePageURLStringKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [[self pgapiViewController] reload];
//
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//            [((LGOWKWebView *)self.webView) evaluateJavaScript:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '设置成功',timeout: 1.5,masked: false,}).call(null);" completionHandler:nil];
//        } else {
//            [((LGOWebView *)self.webView) stringByEvaluatingJavaScriptFromString:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '设置成功',timeout: 1.5,masked: false,}).call(null);"];
//        }
//    }
//}

- (IBAction)defaultButtonAction:(id)sender {
    }

- (PGAPIViewController *)pgapiViewController {
    for (UIViewController *obj in self.tabBarController.viewControllers) {
        if ([obj isKindOfClass:[UINavigationController class]]) {
            UIViewController *tempVC = ((UINavigationController *)obj).viewControllers.lastObject;
            if ([tempVC isKindOfClass:[PGAPIViewController class]]) {
                return (PGAPIViewController *)tempVC;
            }
        }
    }
    return nil;
}

- (void)setupView {
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [((LGOWKWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
    } else {
        [((LGOWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
    }
    self.webView.hidden = YES;
    
    NSString *homePageURLString = [[NSUserDefaults standardUserDefaults] objectForKey:kHomePageURLStringKey];
    if (! homePageURLString) {
        homePageURLString = kDefaultHomePageURLString;
    }
    self.webView.hidden = YES;
    self.homePageURLTextField.text = homePageURLString ?: @"";
    
    if ([self.homePageURLTextField.text isEqualToString:kDefaultHomePageURLString]) {
        self.resetDefaultSwitch.on = YES;
    } else {
        self.resetDefaultSwitch.on = NO;
    }
}

#pragma mark table etc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.homepageURLLabel.frame = CGRectMake(10, 0, self.homepageURLLabel.bounds.size.width, self.homepageURLLabel.bounds.size.height);
        [cell.contentView addSubview:self.homepageURLLabel];
        
        self.homePageURLTextField.frame = CGRectMake(10 + self.homepageURLLabel.bounds.size.width + 10, 0, cell.bounds.size.width - 10 - self.homepageURLLabel.bounds.size.width - 10, self.homePageURLTextField.bounds.size.height);
        [cell.contentView addSubview:self.homePageURLTextField];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        self.resetDefaultLabel.frame = CGRectMake(10, 0, self.resetDefaultLabel.bounds.size.width, self.resetDefaultLabel.bounds.size.height);
        [cell.contentView addSubview:self.resetDefaultLabel];
        
        self.resetDefaultSwitch.frame = CGRectMake(cell.bounds.size.width - 10, cell.bounds.size.height / 2.0 - self.resetDefaultSwitch.bounds.size.height / 2.0, self.resetDefaultSwitch.bounds.size.width, self.resetDefaultSwitch.bounds.size.height);
        [cell.contentView addSubview:self.resetDefaultSwitch];
    }
    return cell;
}

#pragma mark UITextfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[UITextField class]]) {
        if ([textField.text isEqualToString:kDefaultHomePageURLString]) {
            self.resetDefaultSwitch.on = YES;
        } else {
            self.resetDefaultSwitch.on = NO;
        }
        [self saveHomepageURLWithURLString:textField.text];
    }
}

- (void)textFieldDidChangeNotificationAction:(NSNotification *)notification {
    if ([notification isKindOfClass:[NSNotification class]]) {
        if ([notification.object isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)notification.object;
            if ([textField.text isEqualToString:kDefaultHomePageURLString]) {
                [self.resetDefaultSwitch setOn:YES animated:YES];
            } else {
                [self.resetDefaultSwitch setOn:NO animated:YES];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveHomepageURLWithURLString:textField.text];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark Action

- (IBAction)resetSwitchAction:(UISwitch *)sender {
    if ([sender isKindOfClass:[UISwitch class]]) {
        if (sender.isOn) {
            self.homePageURLTextField.text = kDefaultHomePageURLString;
        }
    }
}

- (void)saveHomepageURLWithURLString:(NSString *)URLString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kURLRegexString];
    if (![predicate evaluateWithObject:URLString]) {
        NSURL *URL = [NSURL URLWithString:URLString];
        if (! URL.scheme) {
            
        }
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            [((LGOWKWebView *)self.webView) evaluateJavaScript:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '设置失败，请输入合法的URL',timeout: 2.5,masked: false,}).call(null);" completionHandler:nil];
        } else {
            [((LGOWebView *)self.webView) stringByEvaluatingJavaScriptFromString:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '设置失败，请输入合法的URL',timeout: 2.5,masked: false,}).call(null);"];
        }
        return;
    }
    self.homePageURLTextField.text = URLString;
    [[NSUserDefaults standardUserDefaults] setObject:URLString  forKey:kHomePageURLStringKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[self pgapiViewController] reload];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [((LGOWKWebView *)self.webView) evaluateJavaScript:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '设置成功',timeout: 1.5,masked: false,}).call(null);" completionHandler:nil];
    } else {
        [((LGOWebView *)self.webView) stringByEvaluatingJavaScriptFromString:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '设置成功',timeout: 1.5,masked: false,}).call(null);"];
    }
}
@end
