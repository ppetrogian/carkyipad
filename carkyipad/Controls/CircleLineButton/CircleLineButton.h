//
//  CircleLineButton.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CircleLineButton : UIButton

@property (strong, nonatomic) IBInspectable UIColor *strokeColor;
@property (strong, nonatomic) IBInspectable UIColor *disableColor;
@property (assign, nonatomic) IBInspectable NSInteger cornerRadius;
@property (assign, nonatomic) IBInspectable NSInteger insetRadius;
@end
