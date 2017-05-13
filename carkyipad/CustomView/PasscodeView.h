//
//  PasscodeView.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 11/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasscodeViewDelegate <NSObject>

-(void) didSelectedResendCode;
-(void) didSelectedSubmitCode:(NSString *)code;
@end

@interface CustomPasscodeLabel : UILabel

@end


@interface PasscodeView : UIView<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UITextView *inputView;
@property (nonatomic, weak) IBOutlet UILabel *textMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel *firstLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdLabel;
@property (nonatomic, weak) IBOutlet UILabel *fourthLabel;
@property (nonatomic, weak) IBOutlet UILabel *fiveLabel;
@property (nonatomic, weak) IBOutlet UILabel *sixLabel;
@property (nonatomic, weak) IBOutlet UIButton *resendButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) id <PasscodeViewDelegate> delegate;
-(void) setPassCodeBackgroundColor:(UIColor *)color;
-(void) displayKeyboard;
-(void) hideKeyboard;
-(IBAction)resendButtonAction:(UIButton *)sender;
-(IBAction)submitButtonAction:(UIButton *)sender;
@end
