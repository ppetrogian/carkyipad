//
//  PSInputBox.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSTextField.h"

@interface PSTextField ()
@property (nonatomic) CALayer *border;
@end

@implementation PSTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!_border) {
        _border = [CALayer layer];
    }
    CGFloat borderWidth = 1;
    self.borderStyle = UITextBorderStyleNone;
  
    self.border.borderColor = [UIColor lightGrayColor].CGColor; // [UIColor groupTableViewBackgroundColor].CGColor;
    self.border.frame = CGRectMake(0, rect.size.height - borderWidth, rect.size.width, rect.size.height);
    self.border.borderWidth = borderWidth;
    [self.layer addSublayer:self.border];
    self.layer.masksToBounds = YES;
}


@end
