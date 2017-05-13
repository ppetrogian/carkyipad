//
//  UIController.m
//  MediaProtector
//
//  Created by Avinash Kashyap on 10/31/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "UIController.h"
static UIController *sharedInstance;
@implementation UIController

+(UIController *)sharedInstance{
    @synchronized (self) {
        if (!sharedInstance) {
            sharedInstance = [[UIController alloc] init];
        }
    }
    return sharedInstance;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) navigationItem:(UIBarButtonItem *)buttonItem addBarButtonItemWithStyle:(UIBarButtonSystemItem)style  withTarget:(UIViewController *)target withaction:(nullable SEL)action{
    buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:style target:target action:action];
}
-(UILabel *) initializeLableWithFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.textAlignment = alignment;
    lable.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    return lable;
}
-(UITextField *) initializeTextFieldWithFrame:(CGRect)frame withPlaceholderText:(NSString *)placeHolder withAlignment:(NSTextAlignment)alignment{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    textField.placeholder = placeHolder;
    textField.textAlignment = alignment;
    return textField;
}

-(UIButton *) initialzeButtonWithFrmae:(CGRect)frame withTitle:(NSString *)title withBackgroundColor:(UIColor *)color withbackgroundImageName:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    if (color != nil) {
        button.backgroundColor = color;
    }
    if (imageName.length>1) {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (title.length>1) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    //button.backgroundColor = [UIColor]
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    //[button setTitleColor:[UIColor colorWithRed:40/255 green:(CGFloat)152/255 blue:(CGFloat)196/255 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}
#pragma mark -
-(void) addBorderWithWidth:(CGFloat)width withColor:(UIColor *)color withCornerRadious:(CGFloat)radious toView:(UIView *)view{
    if (width>0) {
        view.layer.borderColor = color.CGColor;
        view.layer.borderWidth = width;
    }
    if (radious != 0) {
        view.layer.cornerRadius = radious;
        view.clipsToBounds = YES;
    }
}
-(void) addLeftPaddingtoTextField:(UITextField *)textField withFrame:(CGRect)frame withBackgroundColor:(UIColor *)color withImage:(NSString *)imageName{
    
    if (imageName == nil) {
        UIView *paddingView = [[UIView alloc] initWithFrame:frame];
        paddingView.backgroundColor = color;
        textField.leftView = paddingView;
    }
    else{
        //NSLog(@"Add UIImage View");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeCenter;
        textField.leftView = imageView;
    }
    textField.leftViewMode = UITextFieldViewModeAlways;
}
-(void) addRightPaddingtoTextField:(UITextField *)textField withFrame:(CGRect)frame withBackgroundColor:(UIColor *)color withImage:(NSString *)imageName{
    if (imageName == nil) {
        NSLog(@"Add uiview");
    }
    else{
        //NSLog(@"Add UIImage View");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        textField.rightView = imageView;
    }
    textField.rightViewMode = UITextFieldViewModeAlways;
}
#pragma mark -
#pragma mark Add Gradient layer
-(void) addGrandientlayerToView:(UIView *)gradientView{
    CAGradientLayer *firstLeftLayer = [CAGradientLayer layer];
    
    CGColorRef outerColor = [[UIColor colorWithWhite:0.97 alpha:1.0] CGColor];
    CGColorRef innerColor = [[UIColor colorWithWhite:0.72 alpha:0.0] CGColor];
    
    firstLeftLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,(__bridge id)innerColor,(__bridge id)innerColor,(__bridge id)outerColor, nil];
    firstLeftLayer.name = @"BlurGradientLayer";
    firstLeftLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.200],[NSNumber numberWithFloat:0.710],[NSNumber numberWithFloat:1.0], nil];
    
    [firstLeftLayer setStartPoint:CGPointMake(0, 0.6)];
    [firstLeftLayer setEndPoint:CGPointMake(1, 0.6)];
    firstLeftLayer.bounds = CGRectMake(gradientView.frame.origin.x, gradientView.frame.origin.y, gradientView.frame.size.width, 1);
    firstLeftLayer.anchorPoint = CGPointZero;
    [gradientView.layer addSublayer:firstLeftLayer];
}
#pragma mark -
-(void) addShadowToView:(UIView *)view withOffset:(CGSize)offSet hadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = offSet;
    view.layer.shadowRadius = radius;//1.5;
    view.layer.shadowOpacity = opacity;//0.12;
}
@end
