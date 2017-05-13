//
//  PasscodeView.m
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 11/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import "PasscodeView.h"
#import "UIController.h"
@implementation PasscodeView

-(instancetype) init{
    self = [super init];
    if (self) {
        [self setupInit];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInit];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}
-(void) awakeFromNib{
    [super awakeFromNib];
    [self setupInit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setupInit{
    UIController *sharedController = [UIController sharedInstance];
    [sharedController addBorderWithWidth:1.0 withColor:[UIColor darkGrayColor] withCornerRadious:10 toView:self.resendButton];
    [sharedController addBorderWithWidth:0.0 withColor:[UIColor clearColor] withCornerRadious:1 toView:self.submitButton];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
}
-(void) setPassCodeBackgroundColor:(UIColor *)color{
    self.backgroundColor = color;
}
#pragma mark -
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self updateText:string];
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void) updateText:(NSString *)text{
    for(int i = 0; i < 6; i++){
        CustomPasscodeLabel *lbl = [self.backView viewWithTag:100+i];
        if (i>=text.length) {
            lbl.text = @"";
            continue;
        }
        NSString *character = [text substringWithRange:NSMakeRange(i, 1)];
        lbl.text = character;
    }
    self.submitButton.backgroundColor = text.length<6?[UIColor lightGrayColor]:[UIColor blackColor];
    self.submitButton.enabled = text.length<6?NO:YES;
}
-(void) textViewDidChange:(UITextView *)textView{
    [self updateText:textView.text];
}
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length>1) {
        return NO;
    }
    if (range.location==6 && range.length == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - 
-(void) displayKeyboard{
    [self.inputView becomeFirstResponder];
}
-(void) hideKeyboard{
    [self.inputView resignFirstResponder];
}
-(IBAction)resendButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedResendCode)]) {
        [self.delegate didSelectedResendCode];
    }
}
-(IBAction)submitButtonAction:(UIButton *)sender{
    if (self.inputView.text.length<6) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSubmitCode:)]) {
            [self.delegate didSelectedSubmitCode:self.inputView.text];
        }
    }];
    
}
@end

@implementation CustomPasscodeLabel

-(void) drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor darkGrayColor] setStroke];
    [path moveToPoint:CGPointMake(0, rect.size.height-2)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height-2)];
    path.lineWidth = 2;
    [path stroke];
    [super drawRect:rect];
}
@end
