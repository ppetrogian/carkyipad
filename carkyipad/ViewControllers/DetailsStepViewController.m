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

NSString *const kResultsDays = @"Days";
NSString *const kResultsDayRange = @"DayRange";
NSString *const kResultsPickupFleetLocationId = @"PickupFleetLocationId";
NSString *const kResultsDropoffFleetLocationId = @"DropoffFleetLocationId";
NSString *const kResultsPickupLocationId = @"PickupLocationId";
NSString *const kResultsDropoffLocationId = @"DropoffLocationId";

@interface DetailsStepViewController ()
{
    UITextField *selectedTextField;
}
@property (weak, nonatomic) IBOutlet PSInputBox *pickupLocationInputBox;
@property (weak, nonatomic) IBOutlet PSInputBox *dropoffLocationInputBox;
@property (weak, nonatomic) IBOutlet PSInputBox *pickupDateInputBox;
@property (weak, nonatomic) IBOutlet PSInputBox *dropoffDateInputBox;
@property (weak, nonatomic) IBOutlet PSFleetLocationControl *fleetLocationControl;
@property (nonatomic,assign) NSInteger selectedFleetLocationId;

@end

@implementation DetailsStepViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    // set calendar delegate
    self.calendarView.delegate = self;
    self.fleetLocationControl.delegate = self;
    self.pickupMenu = [[UIDropDownMenu alloc] initWithIdentifier:@"pickupMenu"];
    self.dropoffMenu = [[UIDropDownMenu alloc] initWithIdentifier:@"dropoffMenu"];
    self.pickupMenu.ScaleToFitParent = NO;
    self.pickupMenu.delegate = self;
    self.dropoffMenu.ScaleToFitParent = NO;
    self.dropoffMenu.delegate = self;
    [self setLocationDropMenus:[NSMutableArray array] withTexts:[NSMutableArray array]];
    CarRentalStepsViewController *parentVc = (CarRentalStepsViewController *)self.stepsController;
    parentVc.totalView.hidden = YES;
}

- (IBAction)tapView:(id)sender {
   //  [[self view] endEditing:YES];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.addressListTableView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupInit{
    UIController *controller = [UIController sharedInstance];
    [controller addLeftPaddingtoTextField:self.pickupTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"arrow_pickup"];
    [controller addLeftPaddingtoTextField:self.dropoffTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"arrow_drop"];
    [controller addLeftPaddingtoTextField:self.pickupDateTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"calendar_icon"];
    [controller addLeftPaddingtoTextField:self.dropOffDateTxtFld withFrame:CGRectMake(0, 0, 50, 45) withBackgroundColor:[UIColor clearColor] withImage:@"calendar_icon"];
}
#pragma mark - UITableView Delegate and Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %zd", indexPath.row+1];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (textField.tag == 102) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}
-(void) highLightTextField:(UITextField *)textField{
    [self deHighLightTextField];
    textField.backgroundColor = [UIColor whiteColor];
    [[UIController sharedInstance] addBorderWithWidth:1.0 withColor:KSelectedFieldBorderColor withCornerRadious:0 toView:textField];
    selectedTextField = textField;
}
-(void) deHighLightTextField{
    if (selectedTextField != nil) {
        selectedTextField.backgroundColor = selectedTextField.tag==102?KDateTxtFldBackgroundColor:KPlaceTxtFldBackgroundColor;
        [[UIController sharedInstance] addBorderWithWidth:1.0 withColor:[UIColor clearColor] withCornerRadious:0 toView:selectedTextField];
    }
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
        self.pickupDateInputBox.textField.attributedText = [NSAttributedString  rz_attributedStringWithStringsAndAttributes: [NSString stringWithFormat: @"%ld ",(long)range.startDay.day],bigAttrs, [NSString stringWithFormat: @"%@ %@",nameofDay1, nameOfMonth1],smAttrs, nil];
        // format end day
        NSString *nameOfMonth2 = [formatter.standaloneMonthSymbols objectAtIndex:range.endDay.month-1];
        NSString *nameofDay2 = [formatter.shortWeekdaySymbols objectAtIndex:range.endDay.weekday-1];
        self.dropoffDateInputBox.textField.attributedText = [NSAttributedString  rz_attributedStringWithStringsAndAttributes: [NSString stringWithFormat: @"%ld ",(long)range.endDay.day],bigAttrs, [NSString stringWithFormat: @"%@ %@",nameofDay2, nameOfMonth2],smAttrs, nil];
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

#pragma mark - Fleet location changed
- (void)setLocationDropMenus:(NSMutableArray *)valueArray withTexts:(NSMutableArray *)titleArray {
    self.pickupMenu.titleArray = titleArray;
    self.pickupMenu.valueArray = valueArray;
    self.dropoffMenu.titleArray = titleArray;
    self.dropoffMenu.valueArray = valueArray;
    [self.pickupMenu makeMenu:self.pickupLocationInputBox.textField targetView:self.view];
    [self.dropoffMenu makeMenu:self.dropoffLocationInputBox.textField targetView:self.view];
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
    [self setLocationDropMenus:valueArray withTexts:titleArray];
}

#pragma mark - menu selection changed
- (void) DropDownMenuDidChange:(NSString *)identifier withValue:(NSNumber *)value andText:(NSString *)text {
    NSMutableDictionary *results = self.stepsController.results;
    if([identifier isEqualToString:@"pickupMenu"]) {
        self.pickupLocationInputBox.textField.text = text;
        results[kResultsPickupLocationId] = value;
        results[kResultsPickupFleetLocationId] = @(_selectedFleetLocationId);
    } else {
        self.dropoffLocationInputBox.textField.text = text;
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

@end
