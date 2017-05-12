//
//  DetailsStepViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
#import "PSLocationButton.h"
#import "DSLCalendarView.h"
#import "PSTimePicker.h"
#import "PSFleetLocationControl.h"
#import "UIDropDownMenu.h"
@class UIDropDownMenu;

#define KDateTxtFldBackgroundColor [UIColor colorWithRed:(CGFloat)237/255 green:(CGFloat)237/255 blue:(CGFloat)237/255 alpha:1.0]
#define KPlaceTxtFldBackgroundColor [UIColor colorWithRed:(CGFloat)249/255 green:(CGFloat)249/255 blue:(CGFloat)249/255 alpha:1.0]
#define KSelectedFieldBorderColor [UIColor colorWithRed:(CGFloat)89/255 green:(CGFloat)205/255 blue:(CGFloat)205/255 alpha:1.0]

@interface DetailsStepViewController : StepViewController<DSLCalendarViewDelegate,FleetLocationControlDelegate, UIDropDownMenuDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) IBOutlet UIView *headerBackView;
@property (nonatomic, weak) IBOutlet UITextField *pickupTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *dropoffTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *pickupDateTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *dropOffDateTxtFld;
@property (nonatomic, weak) IBOutlet UITableView *addressListTableView;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) NSArray *addressListArray;
//----
@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;
@property (nonatomic, weak) IBOutlet UIView *dateTimeBackView;
@property (nonatomic, weak) IBOutlet UIPickerView *hoursPickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *mintuePickerView;
@property (nonatomic, weak) IBOutlet UIPickerView *formatPickerView;

@property (weak, nonatomic) IBOutlet PSTimePicker *timePicker;
@property (strong, nonatomic) UIDropDownMenu *pickupMenu;
@property (strong, nonatomic) UIDropDownMenu *dropoffMenu;

-(IBAction)cancelButtonAction:(UIButton *)sender;
-(IBAction) nextButtonAction:(UIButton *)sender;
-(IBAction)backButtonAction:(UIButton *)sender;
@end
