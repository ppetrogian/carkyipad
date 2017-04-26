//
//  PaymentCardEditorField.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/4/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PaymentCardEditorField.h"
#import "Stripe.h"

@implementation PaymentCardEditorField

// @"numberField",@"expirationField"
- (void)replaceField:(NSString *)memberName withValue:(NSString *)value {
    UITextField *field = [self valueForKey:memberName];
    //if ([(id<UITextFieldDelegate>)self textField:field shouldChangeCharactersInRange:NSMakeRange(0, field.text.length) replacementString:value]) {
        [field setText:value];
    //}
}
@end
