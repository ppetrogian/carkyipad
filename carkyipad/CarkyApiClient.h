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
@class MBProgressHUD;

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
#pragma mark - Api calls
//POST /api/Account/RegisterPartner  (register enos partner gia ta test)

//POST /token  (auth)  gia to login otan anoigi h efarmogh
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password withTokenBlock:(BlockBoolean)block;

//GET /api/Web/GetFleetLocationsFull  fleet locations ana poli
-(void)GetFleetLocationsFull:(BlockArray)block;

//GET api/Web/GetAvailableCars   car categories
-(void)GetAvailableCars:(NSInteger)fleetLocationId withBlock:(BlockArray)block;

//GET api/Helper/GetAllCarCategories   car categories
-(void)GetAllCarCategories:(BlockArray)block;

//GET api/Helper/GetAllCarTypes   car  types
-(void)GetAllCarTypes:(BlockArray)block;

//GET /api/Helper/GetCarExtras  extras per car categories
-(void)GetCarExtras:(BlockArray)block;

// api/Helper/GetAllCarInsurances
-(void)GetAllCarInsurances:(BlockArray)block;


@end
