//
//  CircleLineButton.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface CircleLineButton : UIButton

@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIColor *disableColor;
@property (assign, nonatomic) NSInteger cornerRadius;
@property (assign, nonatomic) NSInteger insetRadius;
@end
