//
//  PSStepButton.h
//  DrawingPlayground

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface PSStepButton : UIButton

//Sets a thicker outline
@property (assign) IBInspectable BOOL bold;

@property (assign) IBInspectable BOOL isLeft;
+ (PSStepButton *)button;
@end
