//
//  PGLabViewController.m
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/14.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "PGLabViewController.h"
#import "PGLGOViewController.h"
#import "PGAPIViewController.h"
#import <LEGO-SDK/LGOWKWebView.h>
#import <LEGO-SDK/LGOWebView.h>
#import "PGHomepageURLSettingViewController.h"
#import "PGLabTableHeaderView.h"
#import "PGAboutViewController.h"
@interface PGLabViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, PGLabTableHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PGLabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Lab";
    [self setupWebView];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark TableView delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            {
                return 3;
            }
            break;
            
        default: return 2;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"LabCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *titles = @[@[@"", @"扫描二维码", @"清除WebView缓存"], @[@"首页设置", @"关于LEGO SDK"]];
    NSArray *images = @[@[@"icon_n输入URL", @"icon_n扫描二维码", @"icon_n清除"], @[@"icon_n设置", @"icon_n关于"]];
    if (indexPath.section == 0 && indexPath.row == 0) {
        PGLabTableHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"PGLabTableHeaderView" owner:nil options:nil] lastObject];
        view.tag = 101;
        view.delegate = self;
        [cell.contentView addSubview:view];
    } else {
        cell.textLabel.text = titles[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 0 && indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.imageView.image = [UIImage imageNamed:images[indexPath.section][indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            {
                switch (indexPath.row) {
                    case 2:
                    {
                        //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置主页地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        //                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                        //                [alertView show];

                        
                        
                        [[NSURLCache sharedURLCache] removeAllCachedResponses];
                        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                            [((LGOWKWebView *)self.webView) evaluateJavaScript:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '清除成功，重启生效',timeout: 1.5,masked: false,}).call(null);" completionHandler:nil];
                        } else {
                            [((LGOWebView *)self.webView) stringByEvaluatingJavaScriptFromString:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '清除成功，重启生效',timeout: 1.5,masked: false,}).call(null);"];
                        }
                        
                    }
                        break;
                    case 0:
                    {
                        
                    }
                        break;
                    case 1:
                    {
                        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                            [((LGOWKWebView *)self.webView) evaluateJavaScript:@"JSMessage.newMessage('Plugin.CodeScan',{'opt':'Scan','closeAfter':true}).call(function(meta,res){JSMessage.newMessage('UI.NavigationController', {opt: 'push',                                                                                                           path: res.result,}).call(null)})" completionHandler:nil];
                        } else {
                            [((LGOWebView *)self.webView) stringByEvaluatingJavaScriptFromString:@"JSMessage.newMessage('Plugin.CodeScan',{'opt':'Scan','closeAfter':true}).call(function(meta,res){JSMessage.newMessage('UI.NavigationController', {opt: 'push',                                                                                                           path: res.result,}).call(null)})"];
                        }
                    }
                        break;
                }
            }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                        PGHomepageURLSettingViewController *settingVC = [[PGHomepageURLSettingViewController alloc] initWithNibName:@"PGHomepageURLSettingViewController" bundle:nil];
                        settingVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:settingVC animated:YES];
                }
                    break;
                case 1:
                {
                    PGAboutViewController *aboutVC = [[PGAboutViewController alloc] initWithNibName:@"PGAboutViewController" bundle:nil];
                    aboutVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
            }
        }
            break;
    }
    
}

#pragma mark UIAlertView delegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex != alertView.cancelButtonIndex) {
//        UITextField *urlTextField = [alertView textFieldAtIndex:0];
//        if (urlTextField.text) {
//            [[NSUserDefaults standardUserDefaults] setObject:urlTextField.text  forKey:kHomePageURLStringKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[self pgapiViewController] reload];
//        }
//    }
//}

#pragma mark Action


#pragma mark Utils
//- (PGAPIViewController *)pgapiViewController {
//    for (UIViewController *obj in self.tabBarController.viewControllers) {
//        if ([obj isKindOfClass:[UINavigationController class]]) {
//            UIViewController *tempVC = ((UINavigationController *)obj).viewControllers.lastObject;
//            if ([tempVC isKindOfClass:[PGAPIViewController class]]) {
//                return (PGAPIViewController *)tempVC;
//            }
//        }
//    }
//    return nil;
//}

- (void)setupWebView {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [((LGOWKWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
    } else {
        [((LGOWebView *)self.webView) loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
    }
    self.webView.hidden = YES;
}

#pragma mark PGLabHeaderView delegate
- (void)loadURLButtonAction:(id)sender {
    PGLabTableHeaderView *tableHeaderView = [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView viewWithTag:101];
    if ([tableHeaderView isKindOfClass:[PGLabTableHeaderView class]]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kURLRegexString];
        if (![predicate evaluateWithObject:tableHeaderView.urlTextField.text]) {
            NSURL *URL = [NSURL URLWithString:tableHeaderView.urlTextField.text];
            if (! URL.scheme) {
                
            }
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                [((LGOWKWebView *)self.webView) evaluateJavaScript:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '请输入合法的URL',timeout: 2.5,masked: false,}).call(null);" completionHandler:nil];
            } else {
                [((LGOWebView *)self.webView) stringByEvaluatingJavaScriptFromString:@"JSMessage.newMessage('UI.Toast', {opt: 'show',style: 'text',title: '请输入合法的URL',timeout: 2.5,masked: false,}).call(null);"];
            }
            return;
        }
        PGLGOViewController *vc = [PGLGOViewController new];
        vc.url = [NSURL URLWithString:tableHeaderView.urlTextField.text];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
