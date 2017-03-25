//
//  PSFleetLocationControl.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 25/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface PSFleetLocationControl : UIStackView

@property (nonatomic, strong) IBInspectable NSString* locationNames;
@property (nonatomic, assign) IBInspectable CGFloat padding;
@property (nonatomic, assign) IBInspectable CGFloat fontSize;
@property (nonatomic,readonly) NSString *selectedName;
@end
