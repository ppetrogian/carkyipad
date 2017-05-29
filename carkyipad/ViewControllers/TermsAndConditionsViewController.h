//
//  TermsAndConditionsViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 08/05/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndConditionsViewController : UIViewController
@property (strong, nonatomic) NSString *terms;
@property (weak, nonatomic) IBOutlet UITextView *termsView;
@end
