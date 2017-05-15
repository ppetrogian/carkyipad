//
//  StepViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 15/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarRentalModel;

extern NSString *const kResultsDays;
extern NSString *const kResultsTotalPrice;
extern NSString *const kResultsTotalPriceCar;
extern NSString *const kResultsTotalPriceExtras;
extern NSString *const kResultsTotalPriceInsurance;
extern NSString *const kResultsDayRange;
extern NSString *const kResultsDropoffFleetLocationId;
extern NSString *const kResultsPickupLocationName;
extern NSString *const kResultsDropoffLocationName;
extern NSString *const kResultsPickupLocationId;
extern NSString *const kResultsDropoffLocationId;
extern NSString *const kResultsPickupDate;
extern NSString *const kResultsDropoffDate;
extern NSString *const kResultsPickupTime;
extern NSString *const kResultsDropoffTime;
extern NSString *const kResultsExtras;
extern NSString *const kResultsCarTypeId;
extern NSString *const kResultsInsuranceId;

@protocol StepDelegate <NSObject>

-(void) didSelectedNext:(UIButton *)sender;
-(void) didSelectedBack:(UIButton *)sender;

@end

@interface StepViewController : UIViewController
- (void)showPrice:(NSInteger)price forKey:(NSString *)key;
@property (nonatomic, weak) id <StepDelegate> stepDelegate;
@end
