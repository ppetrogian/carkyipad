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

@interface DetailsStepViewController : StepViewController<DSLCalendarViewDelegate,FleetLocationControlDelegate, UIDropDownMenuDelegate>

@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet PSTimePicker *timePicker;
@property (strong, nonatomic) UIDropDownMenu *pickupMenu;
@property (strong, nonatomic) UIDropDownMenu *dropoffMenu;
@end
