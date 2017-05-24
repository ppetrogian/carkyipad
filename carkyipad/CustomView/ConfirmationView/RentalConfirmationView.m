//
//  RentalConfirmationVieew.m
//  carkyipad
//
//  Created by Avinash Kashyap on 11/05/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "RentalConfirmationView.h"
#import "UIController.h"

@implementation RentalConfirmationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) awakeFromNib{
    [super awakeFromNib];
    [self defaultSetup];
}
-(void) defaultSetup{
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"confirm_HeaderBack"]];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [[UIController sharedInstance] addShadowToView:self.containerView withOffset:CGSizeMake(-2, 2) hadowRadius:2 shadowOpacity:0.2];
    [[UIController sharedInstance] addShadowToView:self.backView withOffset:CGSizeMake(2, 2) hadowRadius:2 shadowOpacity:0.2];
}

@end
