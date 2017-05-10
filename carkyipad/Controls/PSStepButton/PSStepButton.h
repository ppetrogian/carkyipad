//
//  PSStepButton.h
//  DrawingPlayground

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface PSStepButton : UIButton

//Sets a thicker outline
@property (assign) BOOL bold;

@property (assign) BOOL isLeft;
+ (PSStepButton *)button;
@end
