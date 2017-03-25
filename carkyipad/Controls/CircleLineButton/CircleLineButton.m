//
//  CircleLineButton.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//
#import "CircleLineButton.h"

@interface CircleLineButton ()
@property (nonatomic) CGRect originalBounds;
@property (nonatomic) CGRect originalRect;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end

@implementation CircleLineButton


- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = self.cornerRadius - (self.state == UIControlStateDisabled ? 7 : 0);
    self.clipsToBounds = YES;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.layer.backgroundColor = self.state == UIControlStateDisabled ? self.disableColor.CGColor : self.strokeColor.CGColor;
    if (self.originalBounds.size.width == 0) {
        self.circleLayer = [CAShapeLayer layer];
        self.originalBounds = self.layer.bounds;
        self.originalRect = rect;
        [[self layer] addSublayer:self.circleLayer];
    }
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.strokeColor = self.state == UIControlStateDisabled ? [UIColor grayColor].CGColor : [UIColor whiteColor].CGColor;
    [self.circleLayer setLineWidth:2.0f];
    NSInteger inset = self.insetRadius + (self.state == UIControlStateDisabled ? 3 : 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.originalRect, inset, inset)];
    self.circleLayer.path = path.CGPath;
 
    self.layer.bounds = self.state == UIControlStateDisabled ? CGRectInset(self.originalBounds, inset, inset) : self.originalBounds;
    self.layer.masksToBounds = YES;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

+ (CircleLineButton *)buttonWithType:(UIButtonType)type
{
    return [super buttonWithType:UIButtonTypeRoundedRect];
}
@end
