//
//  CarkyApiClient.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 7/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
@class MBProgressHUD,CarkyDriverPositionsRequest,TransferBookingRequest,RegisterClientRequest,LatLng;

typedef void(^BlockArray)(NSArray *array);
typedef void(^BlockString)(NSString *string);
typedef void(^BlockBoolean)(BOOL b);
typedef void(^BlockError)(NSError *error);
typedef void(^BlockProgress)(NSProgress *progress);

@interface CarkyApiClient : AFHTTPSessionManager
//Shared Service
+ (CarkyApiClient *)sharedService;
-(instancetype)initWithDefaultConfiguration;
-(void)setAuthorizationHeader;
@property (nonatomic) NSString *apiKey;
@property (nonatomic) BOOL isOffline;
@property (nonatomic, strong) BlockError blockErrorDefault;
@property (nonatomic, strong) BlockProgress blockProgressDefault;
@property (nonatomic,strong) NSString *lastMessage;
@property (nonatomic,strong) MBProgressHUD *hud;
#pragma mark - Rent Api calls
//POST /api/Account/RegisterPartner  (register enos partner gia ta test)

//POST /token  (auth)  gia to login otan anoigi h efarmogh
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password withTokenBlock:(BlockBoolean)block;


//GET api/Web/GetAvailableCars   car categories
-(void)GetAvailableCars:(NSInteger)fleetLocationId withBlock:(BlockArray)block;

-(void)GetTransferServiceWebAvailableCars:(NSInteger)fleetLocationId withBlock:(BlockArray)block;

-(void)GetTransferServicePartnerAvailableCars:(NSInteger)fleetLocationId withBlock:(BlockArray)block;

//GET api/Helper/GetAllCarCategories car categories
-(void)GetAllCarCategories:(BlockArray)block;

//GET api/Helper/GetAllCarTypes   car  types
-(void)GetAllCarTypes:(BlockArray)block;

//GET /api/Helper/GetCarExtras  extras per car categories
-(void)GetCarExtras:(BlockArray)block;

// api/Helper/GetAllCarInsurances
-(void)GetAllCarInsurances:(BlockArray)block;

#pragma mark - Taxi Api calls
-(void)GetWellKnownLocations:(NSInteger)fleetLocationId withBlock:(BlockArray)block;

-(void)RegisterClient:(RegisterClientRequest *)request withBlock:(BlockArray)block;
    
-(void)CreateTransferBookingRequestPayPalPayment:(TransferBookingRequest *)request withBlock:(BlockArray)block;

-(void)CreateTransferBookingRequest:(TransferBookingRequest *)request withBlock:(BlockArray)block;

-(void)GetStripePublishableApiKey:(BlockString)block;

-(void)FindNearestCarkyDriverPositions:(CarkyDriverPositionsRequest *)request withBlock:(BlockArray)block;

-(void)GetClientConfiguration:(BlockArray)block;

-(void)GetTransferServicePricesForZone:(NSInteger)dropoffZoneId orLatLng:(LatLng *)ll withBlock:(BlockArray)block;

-(void)ConfirmPhoneNumberWithCode:(NSString *)code forUser:(NSString *)userId withBlock:(BlockBoolean)block;

-(void)SendPhoneNumberConfirmationForUser:(NSString *)userId withBlock:(BlockString)block;

-(void)GetCarkyBookingId:(NSString *)transferBookingId withBlock:(BlockString)block;

-(void)GetCarkyBookingStatusForUser:(NSString *)userId andBooking:(NSString *)bookingId withBlock:(BlockArray)block;

-(void)FetchTerms:(NSString *)culture withBlock:(BlockString)block;

@end
