//
//  SharedData.h
//  OnGraviti
//
//  Created by Pravin Mahajan on 27/07/16.
//  Copyright © 2016 Exceptionaire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedInstance : NSObject

+(SharedInstance *)sharedInstance;
@property (strong,nonatomic) NSMutableDictionary *selCountryCodeDict;
@property (assign,nonatomic) BOOL isCountryCodeSelectedFromPopUp;
@property (strong,nonatomic) NSString *selCountryCode;
@property (strong,nonatomic) NSString *selCountryName;
@property (strong,nonatomic) NSString *selCountryId;
@property (strong,nonatomic) NSMutableArray *ArrGoogleContacts;
@property (strong,nonatomic) NSString *currentLocationPlaceAddress;
@property (strong,nonatomic) NSString *currentLocationPlaceName;
@property (strong,nonatomic) NSMutableArray *arrPlaces;
@property (strong,nonatomic) NSMutableDictionary *selectedPlaceDict;
@end