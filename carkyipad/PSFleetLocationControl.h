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

@interface PSFleetLocationControl : UIStackView

@property (nonatomic,readonly) NSString *selectedName;
@property (nonatomic, strong) IBOutletCollection(PSLocationButton) NSArray *locationButtons;
@end
