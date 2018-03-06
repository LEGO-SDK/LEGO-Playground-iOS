//
//  PGLabTableHeaderView.m
//  LEGO-SDK-Playground
//
//  Created by Keep Jacky on 2017/11/14.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "PGLabTableHeaderView.h"

@implementation PGLabTableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.urlTextField.borderStyle = UITextBorderStyleLine;
    self.urlTextField.borderStyle = UITextBorderStyleNone;
}

- (IBAction)loadURLButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loadURLButtonAction:)]) {
        [self.delegate loadURLButtonAction:sender];
    }
}
@end

@interface PGTextField : UITextField
@end
@implementation PGTextField
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 2, 1);
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 2, 1);
}
@end
