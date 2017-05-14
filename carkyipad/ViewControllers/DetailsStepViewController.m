//
//  DetailsStepViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "DetailsStepViewController.h"
#import "PSTextField.h"
#import "PSInputBox.h"
#import "UIDropDownMenu.h"
#import "NSAttributedString+RZExtensions.h"
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"
#import "AppDelegate.h"
#import "ShadowViewWithText.h"
#import "UIController.h"
#import <Stripe/Stripe.h>

NSString *const kResultsDays = @"Days";
NSString *const kResultsDayRange = @"DayRange";
NSString *const kResultsDropoffFleetLocationId = @"DropoffFleetLocationId";
NSString *const kResultsPickupLocationId = @"PickupLocationId";
NSString *const kResultsDropoffLocationId = @"DropoffLocationId";

@interface DetailsStepViewController ()<DSLCalendarViewDelegate, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,assign) NSInteger selectedFleetLocationId;
@property (nonatomic, readonly, weak) CarRentalStepsViewController *parentController;
@property (nonatomic, strong) UITextField *highlightedFld;
@end

@implementation DetailsStepViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    // set calendar delegate
    self.calendarView.delegate = self;
    //[self setLocationDropMenus:[NSMutableArray array] withTexts:[NSMutableArray array]];
    _parentController = (CarRentalStepsViewController *)self.stepsController;
    
    [self setupInit];
    TabletMode tm = (TabletMode)[AppDelegate instance].clientConfiguration.tabletMode;
    if (tm == TabletModeTransfer) {
        self.backButton.hidden = YES;
    }
    for (UIPickerView *p in self.pickerViews) {
        p.delegate = self;
    }
}

- (IBAction)tapView:(id)sender {
   //  [[self view] endEditing:YES];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.locationsTableView.hidden = YES;
    [self deHighLightTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupInit {
    UIController *controller = [UIController sharedInstance];
    [controller addShadowToView:self.headerBackView withOffset:CGSizeMake(0, 5) hadowRadius:3 shadowOpacity:0.3];
    [controller addLeftPaddingtoTextField:self.pickupTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"arrow_pickup"];
    [controller addLeftPaddingtoTextField:self.dropoffTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"arrow_drop"];
    [controller addLeftPaddingtoTextField:self.pickupDateTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"calendar_icon"];
    [controller addLeftPaddingtoTextField:self.dropOffDateTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"calendar_icon"];
    [controller addBorderWithWidth:0.0 withColor:[UIColor clearColor] withCornerRadious:2 toView:self.nextButton];
    [self initPickupLocation];
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
-(void) textFieldDidBeginEditing:(UITextField *)textField{
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

-(void) highLightTextField:(UITextField *)textField{
    [self deHighLightTextField];
    textField.backgroundColor = [UIColor whiteColor];
    [[UIController sharedInstance] addBorderWithWidth:1.0 withColor:KSelectedFieldBorderColor withCornerRadious:0 toView:textField];
    if (textField.tag == 101) {
        self.activeFld = textField;
    }
    else if (textField.tag == 102) {
        self.activeDateFld = textField;
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
         return [NSString stringWithFormat:@"%zd",row];
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

#pragma mark - UIPickerViewDelegate methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.stepsController.results[kResultsDayRange]) {
        DSLCalendarRange *range = self.stepsController.results[kResultsDayRange];
        NSDateComponents *d = self.activeDateFld == self.pickupDateTxtFld ? range.startDay : range.endDay;
        if (pickerView.tag == 0) {
            d.hour = row + 1;
        }
        else if(pickerView.tag == 1) {
            d.minute = row;
        }
        else {
            d.hour += row * 12;
        }
        self.stepsController.results[kResultsDayRange] = range;
        [self showSelectedDateRange:range];
    }
}

#pragma mark - DSLCalendarViewDelegate methods
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    
    if (range != nil) {
        // change the range if dropoff was selected
        if ([range.endDay.date compare:[NSDate date]] == NSOrderedDescending) {
            DSLCalendarRange *prevRange = self.stepsController.results[kResultsDayRange];
            if(prevRange == nil) prevRange = range;
            // if we selected a single day for drop-off make it range
            if (self.activeDateFld == self.dropOffDateTxtFld && [range.startDay.date compare:range.endDay.date] == NSOrderedSame
                   && [prevRange.startDay.date compare:range.endDay.date] == NSOrderedAscending ) {
                range = [[DSLCalendarRange alloc] initWithStartDay:prevRange.startDay endDay:range.endDay];
                calendarView.selectedRange = range;
            } else if([range.endDay.date compare:[NSDate date]] == NSOrderedAscending) {
                [self.parentController showAlertViewWithMessage:NSLocalizedString(@"A past date cannot be selected", nil) andTitle:@"Error"];
                return;
            }
        }
        [self.stepsController.results setObject:range forKey:kResultsDayRange];
        [self showSelectedDateRange:range];
    }
    else {
        NSLog( @"No selection" );
    }
}

-(void)showSelectedDateRange:(DSLCalendarRange *)range {
    // if we need attributed use rz_attributedStringWithStringsAndAttributes
    [self showSelectedDate:range.startDay inField:self.pickupDateTxtFld];
    [self showSelectedDate:range.endDay inField:self.dropOffDateTxtFld];
}

-(void)showSelectedDate:(NSDateComponents *)day inField:(UITextField *)textField {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd MMMM, h:mm a"];
    NSString *stringFromDate = [dateFormatter stringFromDate:day.date];
    textField.text = stringFromDate;
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    // Don't allow selections before today
    NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
    NSDateComponents *startDate = range.startDay;
    NSDateComponents *endDate = range.endDay;
    
    if ([AppDelegate day:startDate isBeforeDay:today] || [AppDelegate day:endDate isBeforeDay:today]) {
        return nil;
    }
    else {
        if ([AppDelegate day:startDate isBeforeDay:today]) {
            startDate = [today copy];
        }
        if ([AppDelegate day:endDate isBeforeDay:today]) {
            endDate = [today copy];
        }
        return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (IBAction)locationField_EditingChanged:(UITextField *)sender {
    self.activeFld = sender;
    [self fetchPlacesForActiveField];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSMutableDictionary *results = self.stepsController.results;
    if(self.activeFld == self.pickupTxtFld) {
        self.pickupTxtFld.text = self.currentLocation.name;
        self.pickupTxtFld.selectedTextRange = [self.pickupTxtFld textRangeFromPosition:self.pickupTxtFld.beginningOfDocument toPosition:self.pickupTxtFld.beginningOfDocument];
        results[kResultsPickupLocationId] = @(self.currentLocation.identifier);
    } else {
        self.dropoffTxtFld.text = self.currentLocation.name;
        self.dropoffTxtFld.selectedTextRange = [self.dropoffTxtFld textRangeFromPosition:self.dropoffTxtFld.beginningOfDocument toPosition:self.dropoffTxtFld.beginningOfDocument];
        results[kResultsDropoffLocationId] = @(self.currentLocation.identifier);
    }
}

- (IBAction)locationField_EditingEnd:(UITextField *)sender {

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
    if (self.stepDelegate && [self.stepDelegate respondsToSelector:@selector(didSelectedNext:)]) {
        [self.stepDelegate didSelectedNext:sender];
    }
}
-(IBAction)backButtonAction:(UIButton *)sender{
    if (self.stepDelegate && [self.stepDelegate respondsToSelector:@selector(didSelectedBack:)]) {
        [self.stepDelegate didSelectedBack:sender];
    }
}
@end
