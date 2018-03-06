//
//  PGLabTableHeaderView.h
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/14.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGLabTableHeaderViewDelegate <NSObject>
@required
- (void)loadURLButtonAction:(id)sender;
@end

@interface PGLabTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) id <PGLabTableHeaderViewDelegate> delegate;
@end
