//
//  PSLocationButton.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSLocationButton.h"

@interface PSLocationButton ()

@end

@implementation PSLocationButton

- (void)setLabelBelowImage {
    // Drawing code
    // the space between the image and text
      CGFloat spacing = 10.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake( 0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake( - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = (CGFloat)fabs(titleSize.height - imageSize.height) / 2.0f;
    self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

-(void)setSelected:(BOOL)selected {
    [super setSelected: selected];
    [self setTitle:self.location forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //NSBundle *bundle = [NSBundle bundleForClass:self.class];
    //UIImage *im = [UIImage imageNamed:[NSString stringWithFormat:@"loc_%@", self.location] inBundle:bundle compatibleWithTraitCollection:self.traitCollection];

    self.adjustsImageWhenHighlighted = NO;
    self.highlighted = NO;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    //[button centerVerticallyWithPadding:-10.0];
    // Set the accessibility label
    self.accessibilityLabel = self.location;
}

-(CGSize)intrinsicContentSize {
  CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    return CGSizeMake(100.0, 64 + 10 + titleSize.height);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self setLabelBelowImage];
    [self setSelected:self.selected];
}

-(void) prepareForInterfaceBuilder {
    [self setLabelBelowImage];
    [self setSelected:self.selected];
}


@end
