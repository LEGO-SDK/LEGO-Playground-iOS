//
//  PGTabbarController.m
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/14.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "PGTabbarController.h"

@implementation PGTabbarController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:17/255.0 green:137/255.0 blue:249/255.0 alpha:1]} forState:UIControlStateSelected];
    NSArray *titles = @[@"API", @"Guide", @"Lab"];
    NSArray *images = @[@"tab_icon_API_n", @"tab_icon_GUIDE_n", @"tab_icon_LAB_n"];
    NSArray *selectImages = @[@"tab_icon_API_sel", @"tab_icon_GUIDE_sel", @"tab_icon_LAB_sel"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < titles.count) {
            obj.title = titles[idx];
            obj.image = [UIImage imageNamed:images[idx]];
            obj.selectedImage = [UIImage imageNamed:selectImages[idx]];
        }
    }];
}
@end
