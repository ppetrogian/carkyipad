//
//  TransferLaterViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 11/06/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
#import "FSCalendar.h"
#import "PSInsetTextField.h"

@interface TransferLaterViewController : StepViewController
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet PSInsetTextField *notesTextField;


@end
