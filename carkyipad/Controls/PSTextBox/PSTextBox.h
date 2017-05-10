//
//  PSTextBox.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface PSTextBox : UIView

@property (nonatomic, strong) NSString *hintText;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, readwrite) IBOutlet UITextField *textField;
@end

