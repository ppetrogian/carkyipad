//
//  DetailsStepViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "DetailsStepViewController.h"
#import "NSAttributedString+RZExtensions.h"
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"
#import "AppDelegate.h"
#import "ShadowViewWithText.h"
#import "UIController.h"
#import <Stripe/Stripe.h>
#import "CalendarRange.h"
#import "CarCalendarViewCell.h"
#import "RefreshableViewController.h"

NSString *const kResultsDays = @"Days";
NSString *const kResultsDayRange = @"DayRange";
NSString *const kResultsDropoffFleetLocationId = @"DropoffFleetLocationId";
NSString *const kResultsPickupLocationName = @"PickupLocationName";
NSString *const kResultsDropoffLocationName = @"DropoffLocationName";
NSString *const kResultsPickupLocationId = @"PickupLocationId";
NSString *const kResultsDropoffLocationId = @"DropoffLocationId";
NSString *const kResultsPickupDate = @"PickupDate";
NSString *const kResultsPickupNotes = @"PickupNotes";
NSString *const kResultsDropoffDate = @"DropoffDate";
NSString *const kResultsPickupTime = @"PickupTime";
NSString *const kResultsDropoffTime = @"DropoffTime";
NSString *const kResultsExtras = @"Extras";
NSString *const kResultsCarTypeId = @"CarTypeId";
NSString *const kResultsCarTypeIcon = @"CarTypeIcon";
NSString *const kResultsInsuranceId = @"InsuranceId";

@interface DetailsStepViewController ()<FSCalendarDataSource,FSCalendarDelegate, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    NSDate *_date1,*_date2;
}
@property (nonatomic,assign) NSInteger selectedFleetLocationId;
@property (nonatomic, weak) CarRentalStepsViewController *parentRentalController;
@property (nonatomic, strong) UITextField *highlightedFld;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (weak, nonatomic) IBOutlet UIButton *prevMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextMonth;
// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;
@end

@implementation DetailsStepViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initCalendar];
    //[self setLocationDropMenus:[NSMutableArray array] withTexts:[NSMutableArray array]];
    self.parentRentalController = (CarRentalStepsViewController *)self.stepsController;
    [self setupInit];

    for (UIPickerView *p in self.pickerViews) {
        p.dataSource = self;
        p.delegate = self;
    }
    [self.formatPickerView selectRow:1 inComponent:0 animated:NO];
    [self updateTimePickerForDefaultTime];
}

-(void)initCalendar {
    // set calendar
    [self.calendar registerClass:[CarCalendarViewCell class] forCellReuseIdentifier:@"cell"];
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;

    self.calendar.rowHeight = 30;
    self.calendar.appearance.eventSelectionColor = [UIColor whiteColor];
    self.calendar.appearance.separators = FSCalendarSeparatorInterRows | FSCalendarSeparatorBelowWeekdays;
    self.calendar.pagingEnabled = YES;
    self.calendar.allowsMultipleSelection = YES;
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    self.calendar.appearance.titleDefaultColor = [UIColor blackColor];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    self.calendar.swipeToChooseGesture.enabled = NO;
    //[self.calendar reloadData];
}

- (IBAction)tapView:(id)sender {
   //  [[self view] endEditing:YES];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.locationsTableView.hidden = YES;
    //[self deHighLightTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupInit {
    UIController *controller = [UIController sharedInstance];
    [controller addShadowToView:self.headerBackView withOffset:CGSizeMake(0, 2) shadowRadius:3 shadowOpacity:0.2];
    [controller addLeftPaddingtoTextField:self.pickupTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"arrow_pickup"];
    [controller addLeftPaddingtoTextField:self.dropoffTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"arrow_drop"];
    [controller addLeftPaddingtoTextField:self.pickupDateTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"calendar_icon"];
    [controller addLeftPaddingtoTextField:self.dropOffDateTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"calendar_icon"];
    [controller addBorderWithWidth:0.0 withColor:[UIColor clearColor] withCornerRadious:2 toView:self.nextButton];
    [self initControlValues];
}

-(void)initPickupLocation {
    self.dropoffTxtFld.text = NSLocalizedString(@"Same as pick up location", nil);
    NSMutableDictionary *results = self.stepsController.results;
    results[kResultsDropoffLocationId] = @(0);
}

-(void)initControlValues {
    self.dropoffTxtFld.text = @"";
    [self initPickupLocation];
    self.dropOffDateTxtFld.text = @"";
    self.pickupDateTxtFld.text = @"";
}

#pragma mark - UITextField Delegate
-(void) textFieldDidBeginEditing:(UITextField *)textField {
    [self highLightTextField:textField];
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    [self deHighLightTextField];
    if (textField == self.dropoffTxtFld && textField.text.length == 0) {
        [self initPickupLocation];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 101) {
        [self highLightTextField:textField];
        textField.text = @"";
        [self fetchPlacesForActiveField];
        [self displayLocationsPicker:YES];
    }
    else if (textField.tag == 102) {
        // date field
        [self.view endEditing:YES];
        [self highLightTextField:textField];
        [self displayLocationsPicker:NO];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField; {
    return [self textFieldShouldBeginEditing:textField];
}

-(void) highLightTextField:(UITextField *)textField{
    [self deHighLightTextField];
    textField.backgroundColor = [UIColor whiteColor];
    [[UIController sharedInstance] addBorderWithWidth:1.0 withColor:KSelectedFieldBorderColor withCornerRadious:0 toView:textField];
    if (textField.tag == 101) {
        self.activeFld = textField;
        [self updateTimePickerForSelectedDate];
    }
    else if (textField.tag == 102) {
        self.activeDateFld = textField;
        if (textField.text.length > 0) {
            [self updateTimePickerForSelectedDate];
        }
    }
}

-(void) deHighLightTextField{
    if (self.activeFld != nil) {
        self.activeFld.backgroundColor = self.activeFld.tag == 102 ? KDateTxtFldBackgroundColor:KPlaceTxtFldBackgroundColor;
        [[UIController sharedInstance] addBorderWithWidth:1.0 withColor:[UIColor clearColor] withCornerRadious:0 toView:self.activeFld];
    }
    if (self.activeDateFld != nil) {
        self.activeDateFld.backgroundColor = self.activeDateFld.tag == 102 ? KDateTxtFldBackgroundColor:KPlaceTxtFldBackgroundColor;
        [[UIController sharedInstance] addBorderWithWidth:1.0 withColor:[UIColor clearColor] withCornerRadious:0 toView:self.activeDateFld];
    }
}
#pragma mark - Display Date

-(void)displayLocationsPicker:(BOOL)bLoc {
    self.dateTimeBackView.hidden = bLoc;
    self.locationsTableView.hidden = !bLoc;
}


#pragma mark -  UIPicker Delegate and Datasource

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 70;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return 12;
    }
     if (pickerView.tag == 1){
        return 60;
    }
    return 2;
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return [NSString stringWithFormat:@"%zd",row+1];
    }
    else if (pickerView.tag == 1){
         return [NSString stringWithFormat:@"%02zd",row];
    }
    else if (pickerView.tag == 2 && row == 0) {
        return @"AM";
    }
    else if (pickerView.tag == 2 && row == 1) {
        return @"PM";
    }
    return @"";
}

- (IBAction)upArrow_TouchUp:(UIButton *)sender {
    UIPickerView *pickerView = self.pickerViews[sender.tag];
    NSInteger index = [pickerView selectedRowInComponent:0];
    if (index > 0) {
        [pickerView selectRow:index-1 inComponent:0 animated:YES];
        [self pickerView:pickerView didSelectRow:index-1 inComponent:0];
    }
}
- (IBAction)downArrow_TouchUp:(UIButton *)sender {
    UIPickerView *pickerView = self.pickerViews[sender.tag];
    NSInteger index = [pickerView selectedRowInComponent:0];
    if (index < [pickerView numberOfRowsInComponent:0] - 1) {
        [pickerView selectRow:index+1 inComponent:0 animated:YES];
        [self pickerView:pickerView didSelectRow:index+1 inComponent:0];
    }
}

- (IBAction)timePicker_ValueChanged:(UIDatePicker *)sender {
    CalendarRange *range = self.stepsController.results[kResultsDayRange];
    NSDateComponents *d = self.activeDateFld == self.pickupDateTxtFld ? range.startDay : range.endDay;
    d.hour = [self.gregorian component:NSCalendarUnitHour fromDate:sender.date];
    d.minute = [self.gregorian component:NSCalendarUnitMinute fromDate:sender.date];
    [self showSelectedDateRange:range forBothFields:NO];
}


#pragma mark - UIPickerViewDelegate methods
// set time component from picker views
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.stepsController.results[kResultsDayRange]) {
        CalendarRange *range = self.stepsController.results[kResultsDayRange];
        // set date component (start or end) the time
        NSDateComponents *d = self.activeDateFld == self.pickupDateTxtFld ? range.startDay : range.endDay;
        [self setTimeToComponents:d fromPicker:pickerView andRow:row];
        self.stepsController.results[kResultsDayRange] = range;
        [self showSelectedDateRange:range forBothFields:NO];
    }
}

-(void)setTimeToComponents:(NSDateComponents *)d fromPicker:(UIPickerView *)pickerView andRow:(NSInteger)row {
    if (pickerView.tag == 0) {
        d.hour = row + 1;
        // set the format am/pm
        [self pickerView:self.formatPickerView didSelectRow:[self.formatPickerView selectedRowInComponent:0] inComponent:0];
        return;
    }
    else if(pickerView.tag == 1) {
        d.minute = row;
    }
    else {
        if(d.hour < 12 && row == 1)
            d.hour += 12;
        else if(d.hour >= 12 && row == 0)
            d.hour -= 12;
    }
}

-(void)showSelectedDateRange:(CalendarRange *)range forBothFields:(BOOL)both {
    // if we need attributed use rz_attributedStringWithStringsAndAttributes
    if(both || self.activeDateFld == self.pickupDateTxtFld)
        [self showSelectedDate:range.startDay inField:self.pickupDateTxtFld];
    if(both || self.activeDateFld == self.dropOffDateTxtFld)
        [self showSelectedDate:range.endDay inField:self.dropOffDateTxtFld];
}

// perform did select time picker to update the selected date variable
-(void)setDateComponentFromSelectedTimeAndDisplay {
    if (self.timePicker) {
        CalendarRange *range = self.stepsController.results[kResultsDayRange];
        // set date component (start or end) the time
        NSDateComponents *d = self.activeDateFld == self.pickupDateTxtFld ? range.startDay : range.endDay;
        d.hour =  [self.gregorian component:NSCalendarUnitHour fromDate:self.timePicker.date];
        d.minute =  [self.gregorian component:NSCalendarUnitMinute fromDate:self.timePicker.date];
        self.stepsController.results[kResultsDayRange] = range;
        [self showSelectedDateRange:range forBothFields:NO];
    } else {
        [self.pickerViews enumerateObjectsUsingBlock:^(UIPickerView *p, NSUInteger idx, BOOL * _Nonnull stop) {
            [self pickerView:p didSelectRow:[p selectedRowInComponent:0] inComponent:0];
            if (idx == 1) {
                *stop = YES;
            }
        }];
    }
}

-(void)updateTimePickerForSelectedDate {
    CalendarRange *range = self.stepsController.results[kResultsDayRange];
    if (!range) {
        return;
    }
    NSDateComponents *d = self.activeDateFld == self.pickupDateTxtFld ? range.startDay : range.endDay;
    [self updateTimePickerForDate:d];
}

-(void)updateTimePickerForDate:(NSDateComponents *)d {
    if (self.timePicker && d != nil) {
        self.timePicker.date = d.date;
    } else {
        NSArray *indexes = @[@(d.hour>=12 ? d.hour-13 : d.hour-1), @(d.minute), @(d.hour >= 12 ? 1 : 0)];
        [self.pickerViews enumerateObjectsUsingBlock:^(UIPickerView *pv, NSUInteger idx, BOOL * _Nonnull stop) {
            [pv selectRow:((NSNumber *)indexes[idx]).integerValue inComponent:0 animated:NO];
        }];
    }
}

-(void)updateTimePickerForDefaultTime {
    if (self.timePicker) {
        NSInteger min = [self.gregorian component:NSCalendarUnitMinute fromDate:NSDate.date];
        self.timePicker.date = [NSDate.date dateByAddingTimeInterval: 60*(5 -(min % 5))];
    } else {
        NSDateComponents *components = [self.gregorian components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:NSDate.date];
        components.hour = components.hour < 24 ? (components.hour + 1) : 0;
        components.minute = 0;
        [self updateTimePickerForDate:components];
    }
}

-(void)showSelectedDate:(NSDateComponents *)day inField:(UITextField *)textField {
    if (day) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE dd MMMM, h:mm a"];
        NSString *stringFromDate = [dateFormatter stringFromDate:day.date];
        textField.text = stringFromDate;
    }
    else {
        textField.text = @"";
    }
}

- (IBAction)locationField_EditingChanged:(UITextField *)sender {
    self.activeFld = sender;
    [self fetchPlacesForActiveField];
    [self evaluateNextButtonEnabled];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSMutableDictionary *results = self.stepsController.results;
    if(self.activeFld == self.pickupTxtFld) {
        self.pickupTxtFld.text = self.currentLocation.name;
        self.pickupTxtFld.selectedTextRange = [self.pickupTxtFld textRangeFromPosition:self.pickupTxtFld.beginningOfDocument toPosition:self.pickupTxtFld.beginningOfDocument];
        results[kResultsPickupLocationId] = @(self.currentLocation.identifier);
        results[kResultsPickupLocationName] = self.currentLocation.name;
        self.parentRentalController.selectedPickupLocation = self.currentLocation;
    } else {
        self.dropoffTxtFld.text = self.currentLocation.name;
        self.dropoffTxtFld.selectedTextRange = [self.dropoffTxtFld textRangeFromPosition:self.dropoffTxtFld.beginningOfDocument toPosition:self.dropoffTxtFld.beginningOfDocument];
        results[kResultsDropoffLocationId] = @(self.currentLocation.identifier);
        results[kResultsDropoffLocationName] = self.currentLocation.name;
        self.parentRentalController.selectedDropoffLocation = self.currentLocation;
    }
    [self setEditing:NO];
    self.locationsTableView.hidden = YES;
    [self evaluateNextButtonEnabled];
    if (self.activeFld == self.pickupTxtFld) {
        [self highLightTextField:self.dropoffTxtFld];
    }
    else if(self.activeFld == self.dropoffTxtFld) {
        [self highLightTextField:self.pickupDateTxtFld];
        [self.pickupDateTxtFld becomeFirstResponder];
    }
}

- (IBAction)locationField_EditingEnd:(UITextField *)sender {

}

-(void)evaluateNextButtonEnabled {
    BOOL mustEnabled = NO;
    if (self.pickupTxtFld.text.length > 0 && self.dropoffTxtFld.text.length > 0 && self.pickupDateTxtFld.text.length > 0 && self.dropOffDateTxtFld.text.length > 0) {
        mustEnabled = YES;
    }
    if (!self.nextButton.isEnabled && mustEnabled) {
        self.nextButton.enabled = YES;
        self.nextButton.backgroundColor = [UIColor blackColor];
    }
    else if(self.nextButton.isEnabled && !mustEnabled) {
        self.nextButton.enabled = NO;
        self.nextButton.backgroundColor = [UIColor lightGrayColor];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Cancel Action
-(IBAction)cancelButtonAction:(UIButton *)sender{
    [self initControlValues];
}

-(IBAction) nextButtonAction:(UIButton *)sender{
    NSMutableDictionary *results = self.stepsController.results;
    //pickup
    NSArray<NSString*> *pickupDateParts = [self.pickupDateTxtFld.text componentsSeparatedByString:@","];
    results[kResultsPickupDate] = pickupDateParts[0];
    results[kResultsPickupTime] = pickupDateParts[1];
    // dropoff
    if (!results[kResultsDropoffLocationName]) {
        results[kResultsDropoffLocationName] = self.dropoffTxtFld.text;
    }
    NSArray<NSString*> *dropoffDateParts = [self.dropOffDateTxtFld.text componentsSeparatedByString:@","];
    results[kResultsDropoffDate] = dropoffDateParts[0];
    results[kResultsDropoffTime] = dropoffDateParts[1];
    [self prepareCarStep];
}

-(void)prepareCarStep {
    // set number of days
    CalendarRange *selectedRange = self.stepsController.results[kResultsDayRange];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: selectedRange.startDay.date toDate: selectedRange.endDay.date options: 0];
    self.stepsController.results[kResultsDays] = @(components.day);
    // load available cars
    AppDelegate *app = [AppDelegate instance];
    CarkyApiClient *api = [CarkyApiClient sharedService];
    CalendarRange *range = self.stepsController.results[kResultsDayRange];
    [app showProgressNotificationWithText:nil inView:self.view];
    id<RefreshableViewController> nextVc = self.parentRentalController.childViewControllers[1];
    [nextVc setNeedRefresh:YES];
    if (!selectedRange.startDay.date || !selectedRange.endDay.date) {
        return;
    }
    [api GetRentServiceAvailableCarsForLocation:app.clientConfiguration.areaOfServiceId andPickupDate:range.startDay.date andDropoffDate:range.endDay.date withBlock:^(NSArray *array) {
        [app hideProgressNotification];
        app.availableCars = array;
        if (array.count > 0) {
            [self.parentRentalController showNextStep];
        }
        else {
            [self.parentRentalController showAlertViewWithMessage:NSLocalizedString(@"No available cars found for the selected date range", nil)  andTitle:@"Error"];
        }
    }];
}

-(IBAction)backButtonAction:(UIButton *)sender{
    if (self.stepDelegate && [self.stepDelegate respondsToSelector:@selector(didSelectedBack:)]) {
        [self.stepDelegate didSelectedBack:sender];
    }
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

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    [self.view layoutIfNeeded];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date {
    return @[appearance.eventDefaultColor];
}


#pragma mark - FSCalendar Datasource
-(FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    CarCalendarViewCell* carCell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:position];
    return carCell;
}

-(void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

-(NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    return 0;
}

#pragma mark - private methods
- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    CarCalendarViewCell *carCell = (CarCalendarViewCell*)cell;
        
    SelectionType selectionType = SelectionTypeNone;
    if (self.date1 && self.date2) {
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] == NSOrderedDescending &&
                        [date compare:self.date2] == NSOrderedAscending;
        if (isMiddle) {
            selectionType = SelectionTypeMiddle;
            carCell.selectionLayer.hidden = NO;
            carCell.circleLayer.hidden = YES;
        }
        else if(self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1]) {
            selectionType = SelectionTypeLeftBorder;
            carCell.selectionLayer.hidden = NO;
            carCell.circleLayer.hidden = NO;
        }
        else if(self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2]) {
            selectionType = SelectionTypeRightBorder;
            carCell.selectionLayer.hidden = NO;
            carCell.circleLayer.hidden = NO;
        }
    }
    else if(self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1]) {
        selectionType = SelectionTypeLeftBorder;
        carCell.selectionLayer.hidden = YES;
    }
    
    if (selectionType == SelectionTypeNone) {
        carCell.selectionLayer.hidden = YES;
        carCell.circleLayer.hidden = YES;
    }
    carCell.selectionType = selectionType;
}

-(NSDate *)date1 {
    return _date1;
}

-(void)setDate1:(NSDate *)value {
    CalendarRange *range = [[CalendarRange alloc] init];
    range.startDay = [self.gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:value];
    range.startDay.calendar = self.gregorian;
    _date1 = value;
    self.stepsController.results[kResultsDayRange] = range;
    [self setDateComponentFromSelectedTimeAndDisplay];
    // highlight next field
    [self highLightTextField:self.dropOffDateTxtFld];
    [self.dropOffDateTxtFld becomeFirstResponder];
}

-(NSDate *)date2 {
    return _date2;
}

-(void)setDate2:(NSDate *)value {
    CalendarRange *range = self.stepsController.results[kResultsDayRange];
    if (value) {
        // prepare for end day
        [self highLightTextField:self.dropOffDateTxtFld];
        [self.dropOffDateTxtFld becomeFirstResponder];
        range.endDay = [self.gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:value];
        range.endDay.calendar = self.gregorian;
        self.stepsController.results[kResultsDayRange] = range;
        [self setDateComponentFromSelectedTimeAndDisplay];
    } else {
        range.endDay = nil;
        self.dropOffDateTxtFld.text = @"";
    }
    _date2 = value;
    [self evaluateNextButtonEnabled];
}

#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            self.date2 = date;
        }
    } else {
        if (self.activeDateFld == self.pickupDateTxtFld) {
            //[calendar deselectDate:self.date1];
            self.date1 = date;
            self.date2 = nil;
        } else {
            self.date2 = date;
        }
    }
    [self configureVisibleCells];
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSDate *today = [self.gregorian dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0];
    BOOL okPast = [date compare:today] != NSOrderedAscending;
    if (!okPast) {
        [self.parentRentalController showAlertViewWithMessage:@"You cannot select a past date" andTitle:@"Validation"];
        return okPast;
    }
    NSDate *date1dateOnly = [self.gregorian dateBySettingHour:0 minute:0 second:0 ofDate:self.date1 options:0];
    if (self.activeDateFld == self.dropOffDateTxtFld) {
        okPast = [date compare:date1dateOnly] == NSOrderedDescending;
        if (!okPast) {
            [self.parentRentalController showAlertViewWithMessage:@"The dropoff date cannot be equal to the pickup date" andTitle:@"Validation"];
        }
    }
    return okPast;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    BOOL okPast = [self calendar:calendar shouldSelectDate:date atMonthPosition:monthPosition];
    return okPast;
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if (self.activeDateFld == self.pickupDateTxtFld) {
        //[calendar deselectDate:self.date1];
        self.date1 = date;
        self.date2 = nil;
    } else {
        self.date2 = date;
    }
    [self configureVisibleCells];
}

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}


@end
