//
//  CarExtraBaseTableViewCell.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarExtraBaseTableViewCell.h"

@interface CarExtraBaseTableViewCell()
@property (nonatomic,strong) CALayer* borderBottom;
@end

@implementation CarExtraBaseTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *myBackView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundColor = [UIColor clearColor];
    myBackView.backgroundColor = [UIColor clearColor];
    
    self.backgroundView = myBackView;
    self.backgroundView.layer.borderWidth = 2.0;
    self.backgroundView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
 
    self.borderBottom = [CALayer layer];
    self.borderBottom.borderColor = self.tintColor.CGColor;
    self.borderBottom.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 2);
    self.borderBottom.borderWidth = 2.0;
    [self.contentView.layer addSublayer:self.borderBottom];
    self.clipsToBounds = self.isLast ? NO : YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    // set selection color
    UIView *myBackView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView = myBackView;
    self.clipsToBounds = selected || self.isLast ? NO : YES;

    myBackView.backgroundColor = [UIColor clearColor];
    myBackView.layer.borderColor = selected ?  self.tintColor.CGColor : [UIColor groupTableViewBackgroundColor].CGColor;
    self.borderBottom.hidden = selected ? NO : YES;
    self.borderBottom.borderColor = self.tintColor.CGColor;
    myBackView.layer.borderWidth = 2.0;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect r;
    UIView *defaultAccessoryView = self.subviews.lastObject;
    r = defaultAccessoryView.frame;
    r.origin.x = self.bounds.size.width - 50;
    r.origin.y = - self.bounds.size.height/2 + 50;
    defaultAccessoryView.frame = r;
 
    CGRect frameBack = self.bounds;
    frameBack.size.height += 2;
    self.backgroundView.frame = frameBack;
    self.selectedBackgroundView.frame = frameBack;
}

@end
