//
//  DetailsStepViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
#import "SelectDropoffLocationViewController.h"
#import <FSCalendar/FSCalendar.h>
#import "CarCalendarViewCell.h"

#define KDateTxtFldBackgroundColor [UIColor colorWithRed:(CGFloat)237/255 green:(CGFloat)237/255 blue:(CGFloat)237/255 alpha:1.0]
#define KPlaceTxtFldBackgroundColor [UIColor colorWithRed:(CGFloat)249/255 green:(CGFloat)249/255 blue:(CGFloat)249/255 alpha:1.0]
#define KSelectedFieldBorderColor [UIColor colorWithRed:(CGFloat)89/255 green:(CGFloat)205/255 blue:(CGFloat)205/255 alpha:1.0]

@interface DetailsStepViewController : SelectDropoffLocationViewController
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (nonatomic, weak) IBOutlet UIView *headerBackView;
@property (nonatomic, weak) IBOutlet UITextField *pickupTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *dropoffTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *pickupDateTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *dropOffDateTxtFld;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
//----
@property (nonatomic, weak) IBOutlet UIView *dateTimeBackView;
@property (nonatomic, weak) IBOutlet UIPickerView *hoursPickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *minutePickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *formatPickerView;
@property (nonatomic, strong) IBOutletCollection(UIPickerView) NSArray *pickerViews;

@property (weak, nonatomic) IBOutlet UIButton *hourUp;
@property (weak, nonatomic) IBOutlet UIButton *minUp;
@property (weak, nonatomic) IBOutlet UIButton *apUp;
@property (weak, nonatomic) IBOutlet UIButton *minDown;
@property (weak, nonatomic) IBOutlet UIButton *hourDown;
@property (weak, nonatomic) IBOutlet UIButton *apDown;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

-(IBAction)cancelButtonAction:(UIButton *)sender;
-(IBAction) nextButtonAction:(UIButton *)sender;
-(IBAction)backButtonAction:(UIButton *)sender;
@end
