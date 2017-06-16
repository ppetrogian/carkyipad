//
//  TransferLaterViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 11/06/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "TransferLaterViewController.h"
#import "CalendarRange.h"
#import "InitViewController.h"
#import "CarRentalStepsViewController.h"
#import "AppDelegate.h"
#import "ButtonUtils.h"
#import "CarCalendarViewCell.h"

@interface TransferLaterViewController () <InitViewController, FSCalendarDataSource, FSCalendarDelegate>
@property (strong, nonatomic) NSCalendar *gregorian;
@property (nonatomic, weak) CarRentalStepsViewController *parentRentalController;
@end

@implementation TransferLaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentRentalController = (CarRentalStepsViewController *)self.stepsController;
    // Do any additional setup after loading the view.
    [self initControls];
}

-(void)initControls {
    [self.calendar registerClass:[CarCalendarViewCell class] forCellReuseIdentifier:@"cell"];
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.swipeToChooseGesture.enabled = NO;
    self.calendar.allowsMultipleSelection = NO;
    self.calendar.appearance.eventSelectionColor = [UIColor whiteColor];
    self.calendar.appearance.separators = FSCalendarSeparatorInterRows | FSCalendarSeparatorBelowWeekdays;
    self.calendar.pagingEnabled = YES;
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previousMonth_Clicked:(UIButton*)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (IBAction)nextMonth_Clicked:(UIButton*)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

- (IBAction)goBack_Clicked:(UIButton*)sender {
    [self.parentRentalController showPreviousStep];
}

- (IBAction)goNext_Clicked:(UIButton *)sender {
    AppDelegate *app = [AppDelegate instance];
    [self.nextButton disableButton];
    [app showProgressNotificationWithText:nil inView:self.view];
    self.parentRentalController.results[kResultsPickupNotes] = self.notesTextField.text;
    [self.parentRentalController showNextStep];
    [app hideProgressNotification];
    [self.nextButton enableButton];
}

-(FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    CarCalendarViewCell* carCell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:position];
    carCell.selectionType = SelectionTypeLeftBorder;
    carCell.selectionLayer.hidden = YES;
    carCell.circleLayer.hidden = NO;
    return carCell;
}

-(void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    CarCalendarViewCell *carCell = (CarCalendarViewCell*)cell;
    if ([self.gregorian isDate:date inSameDayAsDate:self.calendar.selectedDate]) {
        carCell.selectionType = SelectionTypeLeftBorder;
        carCell.selectionLayer.hidden = YES;
        carCell.circleLayer.hidden = NO;
    } else {
        carCell.selectionType = SelectionTypeNone;
        carCell.selectionLayer.hidden = YES;
        carCell.circleLayer.hidden = YES;
    }
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSDate *today = [self.gregorian dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0];
    BOOL okPast = [date compare:today] != NSOrderedAscending;
    if (!okPast) {
        [self.parentRentalController showAlertViewWithMessage:@"You cannot select a past date" andTitle:@"Validation"];
        return okPast;
    }
    return okPast;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self.notesTextField resignFirstResponder];
    [self.nextButton becomeFirstResponder];
    CalendarRange *range = [[CalendarRange alloc] init];
    range.startDay = [self.gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    range.startDay.calendar = self.gregorian;
    self.parentRentalController.results[kResultsDayRange] = range;
    [self setDateComponentFromSelectedTime];
    [self configureVisibleCells];
    [self.nextButton enableButton];
}

- (IBAction)datePicker_ValueChanged:(UIDatePicker *)sender {
    
}


- (void)configureVisibleCells {
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell *obj, NSUInteger idx, BOOL *stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

// perform did select time picker to update the selected date variable
-(void)setDateComponentFromSelectedTime {
    CalendarRange *range = self.stepsController.results[kResultsDayRange];
    // set date component (start or end) the time
    NSDateComponents *d = range.startDay;
    d.hour = [self.gregorian component:NSCalendarUnitHour fromDate:self.timePicker.date];
    d.minute = [self.gregorian component:NSCalendarUnitMinute fromDate:self.timePicker.date];
    self.stepsController.results[kResultsDayRange] = range;
}

- (IBAction)timePicker_ValueChanged:(UIDatePicker *)sender {
     [self setDateComponentFromSelectedTime];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
