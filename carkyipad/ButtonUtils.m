//
//  ButtonUtils.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 28/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "ButtonUtils.h"

@implementation UIButton (ButtonUtils)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)disableButton {
    self.backgroundColor = [UIColor lightGrayColor];
    self.enabled = NO;
}

-(void)enableButton {
    self.backgroundColor = [UIColor blackColor];
    self.enabled = YES;
}
@end
