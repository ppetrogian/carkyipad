//
//  TransferBookingResponse.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/4/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferBookingResponse : NSObject
@property (nonatomic, strong) NSString *bookingId;
@property (nonatomic, strong) NSString *errorDescription;
@end
