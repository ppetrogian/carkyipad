//
//  PSInputBox.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  PSTextField;

//IB_DESIGNABLE
@interface PSInputBox : UIView

@property (nonatomic, strong) NSString *hintText;
@property (nonatomic, strong) UIImage *hintIcon;
@property (nonatomic,assign) BOOL hideBorder;
@property (nonatomic, readonly) PSTextField *textField;
@end
