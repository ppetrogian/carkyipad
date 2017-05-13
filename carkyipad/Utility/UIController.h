//
//  UIController.h
//  MediaProtector
//
//  Created by Avinash Kashyap on 10/31/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIController : UIView

+(UIController *)sharedInstance;
-(void) navigationItem:(UIBarButtonItem *)buttonItem addBarButtonItemWithStyle:(UIBarButtonSystemItem)style  withTarget:(UIViewController *)target withaction:(SEL)action;
-(UILabel *) initializeLabelWithFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment;
-(UITextField *) initializeTextFieldWithFrame:(CGRect)frame withPlaceholderText:(NSString *)placeHolder withAlignment:(NSTextAlignment)alignment;
-(UIButton *) initializeButtonWithFrame:(CGRect)frame withTitle:(NSString *)title withBackgroundColor:(UIColor *)color withbackgroundImageName:(NSString *)imageName;
-(void) addBorderWithWidth:(CGFloat)width withColor:(UIColor *)color withCornerRadious:(CGFloat)radious toView:(UIView *)view;
-(void) addLeftPaddingtoTextField:(UITextField *)textField withFrame:(CGRect)frame withBackgroundColor:(UIColor *)color withImage:(NSString *)imageName;
-(void) addRightPaddingtoTextField:(UITextField *)textField withFrame:(CGRect)frame withBackgroundColor:(UIColor *)color withImage:(NSString *)imageName;
-(void) addGrandientlayerToView:(UIView *)gradientView;
-(void) addShadowToView:(UIView *)view withOffset:(CGSize)offSet hadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity;
@end
