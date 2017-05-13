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
NSString *const kResultsPickupFleetLocationId = @"PickupFleetLocationId";
NSString *const kResultsDropoffFleetLocationId = @"DropoffFleetLocationId";
NSString *const kResultsPickupLocationId = @"PickupLocationId";
NSString *const kResultsDropoffLocationId = @"DropoffLocationId";

@interface DetailsStepViewController ()<DSLCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,assign) NSInteger selectedFleetLocationId;
@property (nonatomic, readonly, weak) CarRentalStepsViewController *parentController;
@end

@implementation DetailsStepViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    // set calendar delegate
    self.calendarView.delegate = self;
    //[self setLocationDropMenus:[NSMutableArray array] withTexts:[NSMutableArray array]];
    _parentController = (CarRentalStepsViewController *)self.stepsController;
    
    [self setupInit];
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
}

#pragma mark - UITextField Delegate
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    [self highLightTextField:textField];
}
-(void) textFieldDidEndEditing:(UITextField *)textField{
    [self deHighLightTextField];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    [self highLightTextField:textField];
    if (textField.tag == 101) {
        [self fetchPlacesForActiveField];
        [self displayLocationsPicker:YES];
    }
    if (textField.tag == 102) {
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
    self.activeFld = textField;
}
-(void) deHighLightTextField{
    if (self.activeFld != nil) {
        self.activeFld.backgroundColor = self.activeFld.tag == 102 ? KDateTxtFldBackgroundColor:KPlaceTxtFldBackgroundColor;
        [[UIController sharedInstance] addBorderWithWidth:1.0 withColor:[UIColor clearColor] withCornerRadious:0 toView:self.activeFld];
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
#pragma mark - DSLCalendarViewDelegate methods
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSDictionary *bigAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
        NSDictionary *smAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"MMMM"];
        NSString *nameOfMonth1 = [formatter.standaloneMonthSymbols objectAtIndex:range.startDay.month-1];
        NSString *nameofDay1 = [formatter.shortWeekdaySymbols objectAtIndex:range.startDay.weekday-1];
        self.pickupDateTxtFld.attributedText = [NSAttributedString  rz_attributedStringWithStringsAndAttributes: [NSString stringWithFormat: @"%ld ",(long)range.startDay.day],bigAttrs, [NSString stringWithFormat: @"%@ %@",nameofDay1, nameOfMonth1],smAttrs, nil];
        // format end day
        NSString *nameOfMonth2 = [formatter.standaloneMonthSymbols objectAtIndex:range.endDay.month-1];
        NSString *nameofDay2 = [formatter.shortWeekdaySymbols objectAtIndex:range.endDay.weekday-1];
        self.dropOffDateTxtFld.attributedText = [NSAttributedString  rz_attributedStringWithStringsAndAttributes: [NSString stringWithFormat: @"%ld ",(long)range.endDay.day],bigAttrs, [NSString stringWithFormat: @"%@ %@",nameofDay2, nameOfMonth2],smAttrs, nil];
        [self.stepsController.results setObject:range forKey:kResultsDayRange];
    }
    else {
        NSLog( @"No selection" );
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (/* DISABLES CODE */ (NO)) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

- (IBAction)locationField_ValueChanged:(UITextField *)sender {
    self.activeFld = sender;
    [self fetchPlacesForActiveField];
}

- (void) fleetLocationChanged:(id)sender withValue:(NSString *)value {
    AppDelegate* app = (AppDelegate* )[UIApplication sharedApplication].delegate;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", value];
    NSArray *filteredArray = [app.fleetLocations filteredArrayUsingPredicate:predicate];
    FleetLocations *fl = filteredArray.firstObject;
    _selectedFleetLocationId = fl.identifier;
    // set values and titles for menu
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:fl.locations.count];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:fl.locations.count];
    if (filteredArray.count == 0) {
        [valueArray addObject:@(-1)];
        [titleArray addObject:NSLocalizedString(@"No location found", nil)];
    } else {
        [fl.locations enumerateObjectsUsingBlock:^(Location *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [valueArray addObject:@(obj.identifier)];
            [titleArray addObject:obj.name];
        }];
    }
}

#pragma mark - menu selection changed
- (void) DropDownMenuDidChange:(NSString *)identifier withValue:(NSNumber *)value andText:(NSString *)text {
    NSMutableDictionary *results = self.stepsController.results;
    if([identifier isEqualToString:@"pickupMenu"]) {
        self.pickupTxtFld.text = text;
        results[kResultsPickupLocationId] = value;
        results[kResultsPickupFleetLocationId] = @(_selectedFleetLocationId);
    } else {
        self.dropoffTxtFld.text = text;
        results[kResultsDropoffLocationId] = value;
        results[kResultsDropoffFleetLocationId] = @(_selectedFleetLocationId);
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
    self.locationsTableView.hidden = YES;
    self.dateTimeBackView.hidden = YES;
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
