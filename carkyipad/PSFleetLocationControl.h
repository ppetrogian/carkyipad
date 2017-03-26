//
//  PSFleetLocationControl.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 25/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//
// not used

#import <UIKit/UIKit.h>
@class PSLocationButton;

@protocol FleetLocationControlDelegate <NSObject>
@optional
- (void) fleetLocationChanged:(id)sender withValue:(NSString *)value;
@end

@interface PSFleetLocationControl : UIStackView

@property (nonatomic,readonly) NSString *selectedName;
@property (nonatomic, strong) IBOutletCollection(PSLocationButton) NSArray *locationButtons;
@property (nonatomic,weak) id<FleetLocationControlDelegate> delegate;
@end
