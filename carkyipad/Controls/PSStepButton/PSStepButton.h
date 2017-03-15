//
//  PSStepButton.h
//  DrawingPlayground
//
//  Created by Brian Michel on 11/11/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface PSStepButton : UIButton

//Sets a thicker outline
@property (assign) IBInspectable BOOL bold;

@property (assign) IBInspectable BOOL isLeft;
+ (PSStepButton *)button;
@end
