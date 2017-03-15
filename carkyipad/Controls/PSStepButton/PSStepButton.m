//
//  PSStepButton.m
//  DrawingPlayground
//
//  Created by Brian Michel on 11/11/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import "PSStepButton.h"

const CGFloat kPSStepButtonBoldLineWidth = 3.0;
const CGFloat kPSStepButtonNormalLineWidth = 2.0;

@implementation PSStepButton

@synthesize bold = _bold;

+ (PSStepButton *)button {
  return [PSStepButton buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    //stuff
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGColorRef strokeColor;
  CGColorRef fillColor;

  switch (self.state) {
    case UIControlStateHighlighted:
    case UIControlStateSelected:
      strokeColor = [self titleColorForState:UIControlStateNormal] ? [self titleColorForState:UIControlStateNormal].CGColor : [UIColor blackColor].CGColor;
      fillColor = [self titleColorForState:UIControlStateNormal] ? [self titleColorForState:UIControlStateNormal].CGColor : [UIColor blackColor].CGColor;
      break;
    case UIControlStateDisabled:
      strokeColor = [self titleColorForState:UIControlStateDisabled] ? [self titleColorForState:UIControlStateDisabled].CGColor : [UIColor blackColor].CGColor;
      fillColor = [self titleColorForState:UIControlStateDisabled] ? [self titleColorForState:UIControlStateDisabled].CGColor : [UIColor blackColor].CGColor;
      break;
    default:
      strokeColor = [self titleColorForState:UIControlStateNormal] ? [self titleColorForState:UIControlStateNormal].CGColor : [UIColor blackColor].CGColor;
      fillColor = [UIColor clearColor].CGColor;
      break;
  }
  
  CGContextSetFillColorWithColor(ctx, fillColor);
  CGContextSetStrokeColorWithColor(ctx, strokeColor);
  
  CGContextSaveGState(ctx);
    
  CGFloat lineWidth = self.bold ? kPSStepButtonBoldLineWidth : kPSStepButtonNormalLineWidth;
  
  CGContextSetLineWidth(ctx, lineWidth);
  
  // UIBezierPath *outlinePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, lineWidth, lineWidth) cornerRadius:self.bounds.size.height/2];
  CGMutablePathRef cgPath = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformIdentity;
  CGPoint points[3];
    CGFloat w = self.bounds.size.width; CGFloat h = self.bounds.size.height;
    points[0] = CGPointMake(w/2, 2); points[1] = CGPointMake(self.isLeft ? 10 : w-10, h/4); points[2] = CGPointMake(w/2, h/2);
  CGPathAddLines(cgPath, &transform, points, sizeof points / sizeof *points); //CGPathCloseSubpath(cgPath);
  CGContextAddPath(ctx, cgPath);

  CGContextStrokePath(ctx);
  
  CGContextRestoreGState(ctx);
  
//  if (self.highlighted) {
//    CGContextSaveGState(ctx);
//    UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, lineWidth * 2.5, lineWidth * 2.5) cornerRadius:self.bounds.size.height/2];
//    
//    CGContextAddPath(ctx, fillPath.CGPath);
//    CGContextFillPath(ctx);
//    
//    CGContextRestoreGState(ctx);
//  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  [self setNeedsDisplay];
}

#pragma mark - Setters / Getters
- (void)setBold:(BOOL)bold {
  _bold = bold;
  [self setNeedsDisplay];
}

- (BOOL)bold {
  return _bold;
}

@end
