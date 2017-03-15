//
//  FlatPillButton.h
//  DrawingPlayground
//
//  Created by Brian Michel on 11/11/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface FlatPillButton : UIButton

//Sets a thicker outline
@property (assign) IBInspectable BOOL bold;

//For the lazy...
+ (FlatPillButton *)button;
@end
