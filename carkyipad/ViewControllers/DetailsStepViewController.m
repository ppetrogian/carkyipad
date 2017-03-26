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
#import "AppDelegate.h"


@interface DetailsStepViewController ()
@property (weak, nonatomic) IBOutlet PSInputBox *pickupLocationInputBox;
@property (weak, nonatomic) IBOutlet PSInputBox *dropoffLocationInputBox;
@property (weak, nonatomic) IBOutlet PSInputBox *pickupDateInputBox;
@property (weak, nonatomic) IBOutlet PSInputBox *dropoffDateInputBox;
@property (weak, nonatomic) IBOutlet PSFleetLocationControl *fleetLocationControl;


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
    [self setLocationDropMenus:[NSMutableArray array]];
}

- (IBAction)tapView:(id)sender {
   //  [[self view] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)setLocationDropMenus:(NSMutableArray *)titleArray {
    self.pickupMenu.titleArray = titleArray;
    self.pickupMenu.valueArray = titleArray;
    self.dropoffMenu.titleArray = titleArray;
    self.dropoffMenu.valueArray = titleArray;
    [self.pickupMenu makeMenu:self.pickupLocationInputBox.textField targetView:self.view];
    [self.dropoffMenu makeMenu:self.dropoffLocationInputBox.textField targetView:self.view];
}

- (void) fleetLocationChanged:(id)sender withValue:(NSString *)value {
    AppDelegate* app = (AppDelegate* )[UIApplication sharedApplication].delegate;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", value];
    NSArray *filteredArray = [app.fleetLocations filteredArrayUsingPredicate:predicate];
    FleetLocations *fl = filteredArray.firstObject;
    NSMutableArray *titleArray = [NSMutableArray array];
    if (filteredArray.count == 0) {
        [titleArray addObject:NSLocalizedString(@"No location found", nil)];
    } else {
        [fl.locations enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleArray addObject:obj.name];
        }];
    }
    [self setLocationDropMenus:titleArray];
}

#pragma mark - menu selection changed
- (void) DropDownMenuDidChange:(NSString *)identifier :(NSString *)ReturnValue{
    if([identifier isEqualToString:@"pickupMenu"]) {
        
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
