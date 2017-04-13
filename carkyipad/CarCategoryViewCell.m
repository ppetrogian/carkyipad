//
//  CarCategoryViewCell.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 13/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarCategoryViewCell.h"

@implementation CarCategoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)minusClick:(UIButton *)sender {
   // [self addOrSubtractCar:sender];
}
- (IBAction)plusClick:(UIButton *)sender {
    //[self addOrSubtractCar:sender];
}

-(void)addOrSubtractCar:(UIButton *)sender {
    UIView *parentView = sender.superview;
    UILabel *numLabel = [parentView viewWithTag:6];
    NSInteger numberValue = numLabel.text.integerValue;
    numberValue = sender.tag == 7 ? numberValue + 1 : numberValue - 1;
    numLabel.text = [NSString stringWithFormat:@"%ld",numberValue];
}

@end
