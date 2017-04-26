//
//  PaymentCardEditorField.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/4/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stripe.h"

@interface PaymentCardEditorField : STPPaymentCardTextField
- (void)replaceField:(NSString *)memberName withValue:(NSString *)value;
@end
