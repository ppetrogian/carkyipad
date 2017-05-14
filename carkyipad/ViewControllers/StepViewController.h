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
extern NSString *const kResultsPickupLocationId;
extern NSString *const kResultsDropoffLocationId;

@protocol StepDelegate <NSObject>

-(void) didSelectedNext:(UIButton *)sender;
-(void) didSelectedBack:(UIButton *)sender;

@end

@interface StepViewController : UIViewController
- (void)showPrice:(NSInteger)price forKey:(NSString *)key;
@property (nonatomic, weak) id <StepDelegate> stepDelegate;
@end
