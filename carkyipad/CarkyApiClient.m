//
//  CarkyApiClient.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 7/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarkyApiClient.h"
#import "DataModels.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#define TRANSFER_TIMEOUT 180

@implementation CarkyApiClient
static CarkyApiClient *_sharedService = nil;

+ (instancetype)sharedService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        //Callback for reachability status change
        _sharedService.isOffline = NO;
        NSString *baseUrl;
        switch ([AppDelegate instance].environment) {
            case 0: baseUrl = @"https://carky-api-dev.azurewebsites.net"; break;
            case 1: baseUrl = @"https://carky-api-test.azurewebsites.net"; break;
            case 2: baseUrl = @"https://carky-api-stage.azurewebsites.net";break;
            case 3: baseUrl = @"https://carky-api.azurewebsites.net";break;
            default: break;
        }
        // create and init instance
        _sharedService = [[CarkyApiClient alloc] initWithDefaultConfiguration:baseUrl];
        [_sharedService.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
                _sharedService.isOffline = YES;
            }
            else  {
                _sharedService.isOffline = NO;
            }
        }];
        [_sharedService.reachabilityManager startMonitoring];
    });
    _sharedService.blockErrorDefault = ^(NSError *error) {
        [_sharedService.hud hideAnimated:YES];
        NSLog(@"%@",error.localizedDescription);
    };
    _sharedService.blockProgressDefault = ^(NSProgress *progress) {
    };
    return _sharedService;
}

-(instancetype)initWithDefaultConfiguration:(NSString *)baseUrl {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"User-Agent": @"Carky iPAD iOS 1.0", @"Accept": @"application/json", @"Accept-Charset": @"UTF-8", @"Accept-Encoding": @"gzip"}];
    self = [[CarkyApiClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] sessionConfiguration:config];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    return self;
}

-(void)setAuthorizationHeader {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *bearerToken = [[NSString alloc]initWithFormat:@"Bearer %@", self.apiKey];
    [self.requestSerializer setValue:bearerToken forHTTPHeaderField:@"Authorization"];
}

#pragma mark API CALLS
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password withTokenBlock:(BlockBoolean)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];

   [self POST:@"token" parameters:@{@"grant_type":@"password",@"username":username, @"password":password} progress:self.blockProgressDefault success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject objectForKey:@"error"]) {
            self.lastMessage = responseObject[@"error_description"];
            block(NO);
        } else {
            self.apiKey = responseObject[@"access_token"];
            //NSLog(@"Access token: %@", self.apiKey);
            block(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
        block(NO);
    }];
}

// unused
-(void)GetAvailableCars:(NSInteger)fleetLocationId withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Web/GetAvailableCars" parameters:@{@"fleetLocationId": @(fleetLocationId)} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        [self.hud hideAnimated:YES];
        NSMutableArray *availableCarsArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            availableCarsArray[idx] = [AvailableCars modelObjectWithDictionary:obj];
        }];
        block(availableCarsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

// unused
-(void)GetAllCarCategories:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Helper/GetAllCarCategories" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *catArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            catArray[idx] = [CarCategory modelObjectWithDictionary:obj];
        }];
        block(catArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

// unused
-(void)GetAllCarTypes:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Helper/GetAllCarTypes" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *catArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            catArray[idx] = [CarType modelObjectWithDictionary:obj];
        }];
        block(catArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

// unused
-(void)GetCarExtrasForTransfer:(NSDate *)pickupDate withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDateFormatter *dfDate = [NSDateFormatter new]; dfDate.dateFormat = @"yyyy-MM-dd";
    NSDateFormatter *dfTime = [NSDateFormatter new]; dfTime.dateFormat = @"HH:mm";
    
    [self GET:@"api/Helper/GetCarExtrasForTransfer" parameters:@{@"pickupDateTime.date":[dfDate stringFromDate:pickupDate], @"pickupDateTime.time":[dfTime stringFromDate:pickupDate]}  progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *carExtrasArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            carExtrasArray[idx] = [CarExtra modelObjectWithDictionary:obj];
        }];
        block(carExtrasArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

-(void)GetCarExtrasForRental:(NSDate *)pickupDate andDropoffDate:(NSDate *)dropoffDate withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDateFormatter *dfDate = [NSDateFormatter new]; dfDate.dateFormat = @"yyyy-MM-dd";
    NSDateFormatter *dfTime = [NSDateFormatter new]; dfTime.dateFormat = @"HH:mm";

    [self GET:@"api/Helper/GetCarExtrasForRental" parameters:@{@"pickupDateTime.date":[dfDate stringFromDate:pickupDate], @"pickupDateTime.time":[dfTime stringFromDate:pickupDate], @"dropoffDateTime.date":[dfDate stringFromDate:dropoffDate], @"dropoffDateTime.time":[dfTime stringFromDate:dropoffDate]}  progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *carExtrasArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            carExtrasArray[idx] = [CarExtra modelObjectWithDictionary:obj];
        }];
        block(carExtrasArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
        [self ShowMessageOnError:error WithBlock:block];
    }];
}

-(void)GetAllCarInsurancesForType:(NSInteger)carTypeId andPickupDate:(NSDate *)pickupDate andDropoffDate:(NSDate *)dropoffDate withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDateFormatter *dfDate = [NSDateFormatter new]; dfDate.dateFormat = @"yyyy-MM-dd";
    NSDateFormatter *dfTime = [NSDateFormatter new]; dfTime.dateFormat = @"HH:mm";

    [self GET:@"api/Helper/GetAllCarInsurances" parameters:@{@"carCategoryId":@(carTypeId), @"pickupDateTime.date":[dfDate stringFromDate:pickupDate], @"pickupDateTime.time":[dfTime stringFromDate:pickupDate], @"dropoffDateTime.date":[dfDate stringFromDate:dropoffDate], @"dropoffDateTime.time":[dfTime stringFromDate:dropoffDate]}  progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *carInsArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            carInsArray[idx] = [CarInsurance modelObjectWithDictionary:obj];
        }];
        block(carInsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self ShowMessageOnError:error WithBlock:block];
    }];
}

#pragma Web api Taxi Api calls

-(void)GetWellKnownLocations:(NSInteger)fleetLocationId withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Web/GetWellKnownLocations" parameters:@{@"fleetLocationId": @(fleetLocationId)} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:NSData.class]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSArray *array = (NSArray *)responseObject;
        [self.hud hideAnimated:YES];
        NSMutableArray *locationsArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            locationsArray[idx] = [Location modelObjectWithDictionary:obj];
        }];
        block(locationsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

-(void)GetTransferServiceWebAvailableCars:(NSInteger)fleetLocationId withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Web/GetTransferServiceAvailableCars" parameters:@{@"fleetLocationId": @(fleetLocationId)} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        [self.hud hideAnimated:YES];
        NSMutableArray *carsArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            carsArray[idx] = [Cars modelObjectWithDictionary:obj];
        }];
        block(carsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

-(void)GetTransferServicePartnerAvailableCars:(NSInteger)fleetLocationId withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [self GET:@"api/Partner/GetTransferServiceAvailableCars" parameters:@{@"fleetLocationId": @(fleetLocationId)} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.hud hideAnimated:YES];
        if ([responseObject isKindOfClass:NSData.class]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([responseObject isKindOfClass:NSArray.class]) {
            NSArray *array = (NSArray *)responseObject;
            [self.hud hideAnimated:YES];
            NSMutableArray *carsArray = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                carsArray[idx] = [CarCategory modelObjectWithDictionary:obj];
            }];
            block(carsArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

-(void)GetRentServiceAvailableCarsForLocation:(NSInteger)fleetLocationId andPickupDate:(NSDate *)pickupDate andDropoffDate:(NSDate *)dropoffDate withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSDateFormatter *dfDate = [NSDateFormatter new]; dfDate.dateFormat = @"yyyy-MM-dd";
    NSDateFormatter *dfTime = [NSDateFormatter new]; dfTime.dateFormat = @"HH:mm";
    [self GET:@"api/Web/GetRentServiceAvailableCars" parameters:@{@"fleetLocationId": @(fleetLocationId), @"pickupDateTime.date":[dfDate stringFromDate:pickupDate], @"pickupDateTime.time":[dfTime stringFromDate:pickupDate], @"dropoffDateTime.date":[dfDate stringFromDate:dropoffDate], @"dropoffDateTime.time":[dfTime stringFromDate:dropoffDate]} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:NSData.class]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([responseObject isKindOfClass:NSArray.class]) {
            NSArray *array = (NSArray *)responseObject;
            [self.hud hideAnimated:YES];
            NSMutableArray *availableCarsArray = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                availableCarsArray[idx] = [AvailableCars modelObjectWithDictionary:obj];
            }];
            block(availableCarsArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

-(void)GetStripePublishableApiKey:(BlockString)block {
    // todo: allow json fragments or accept plain http
    [self setAuthorizationHeader];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self GET:@"api/StripePayment/GetPublishableApiKey" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        block(str);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

// deprecated / unused
-(void)GetCarkyBookingId:(NSString *)transferBookingId withBlock:(BlockString)block {
    // todo: allow json fragments or accept plain http
    [self setAuthorizationHeader];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self GET:@"api/Partner/GetCarkyBookingId" parameters:@{@"transferBookingId":transferBookingId} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString* bookingId = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        block(bookingId);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
        block(nil);
    }];
}

-(void)GetCarkyBookingStatusForUser:(NSString *)userId andBooking:(NSString *)bookingId withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Client/GetCarkyBookingStatus" parameters:@{@"bookingId":bookingId, @"userId": userId} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        Content *respObj = [Content modelObjectWithDictionary:responseObject];
        block([NSArray arrayWithObject:respObj]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
        block([NSArray array]);
    }];
}

// Find nearest carky driver positions
//CarkyCategoryId 1=Executive  2=Luxury  3=Suv
-(void)FindNearestCarkyDriverPositions:(CarkyDriverPositionsRequest *)request withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setAuthorizationHeader];
    [self POST:@"api/Client/FindNearestCarkyDriverPositions" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *driversArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            driversArray[idx] = [CarkyDriverPositionsResponse modelObjectWithDictionary:obj];
        }];
        block(driversArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        self.blockErrorDefault(error);
        block([NSArray array]);
    }];
}

-(void)ShowMessageOnError:(NSError *)error WithBlock:(BlockArray)block {
    NSLog(@"Error: %@", error.localizedDescription);
    NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    NSString *errorMsg = @"Server error";
    if(errorStr.length > 14)
        errorMsg = [errorStr substringWithRange:NSMakeRange(12, errorStr.length-14)];
    NSLog(@"Error Detail: %@", errorMsg);
    self.blockErrorDefault(error);
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    block([NSArray arrayWithObject:errorMsg]);
}

-(void)RegisterClient:(RegisterClientRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:@"api/Partner/RegisterClient" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        RegisterClientResponse *response = [RegisterClientResponse modelObjectWithDictionary:responseObject];
        block([NSArray arrayWithObject:response]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self ShowMessageOnError:error WithBlock:block];
    }];
}

// deprecated
-(void)CreateTransferBookingRequest:(TransferBookingRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    TransferBookingResponse *responseObj = [TransferBookingResponse new];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self POST:@"api/Partner/CreateTransferBookingRequest" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        responseObj.bookingId = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        block([NSArray arrayWithObject:responseObj]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSString *errorMsg = [errorStr substringWithRange:NSMakeRange(12, errorStr.length-14)];
        self.blockErrorDefault(error);
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        responseObj.errorDescription = errorStr;
        block([NSArray arrayWithObject:errorMsg]);
    }];
}

-(void)CreateTransferBooking:(TransferBookingRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    TransferBookingResponse *responseObj = [TransferBookingResponse new];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.requestSerializer setTimeoutInterval:TRANSFER_TIMEOUT]; // 3 minutes timout

    [self POST:@"api/Partner/CreateTransferBooking" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        responseObj.bookingId = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        block([NSArray arrayWithObject:responseObj]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSString *errorMsg = errorStr.length > 12 ? [errorStr substringWithRange:NSMakeRange(12, errorStr.length-14)] : @"Server error";
        self.blockErrorDefault(error);
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        responseObj.errorDescription = errorMsg;
        responseObj.bookingId = @"0";
        block([NSArray arrayWithObject:responseObj]);
    }];
}

-(void)RentalChargesForIpad:(RentalBookingRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:@"api/Partner/RentalChargesForIpad" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        ChargesForIPadResponse *responseObj = [ChargesForIPadResponse modelObjectWithDictionary:responseObject];
        block([NSArray arrayWithObject:responseObj]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self ShowMessageOnError:error WithBlock:block];
    }];
}

//POST /api/Partner/CreateRentalBookingRequestForIpad
-(void)CreateRentalBookingRequestForIpad:(RentalBookingRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:@"api/Partner/CreateRentalBookingRequestForIpad" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        RentalBookingResponse *resultObj = [RentalBookingResponse modelObjectWithDictionary:responseObject];
        block([NSArray arrayWithObject:resultObj]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSString *errorMsg = [errorStr substringWithRange:NSMakeRange(12, errorStr.length-14)];
        self.blockErrorDefault(error);
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        block([NSArray arrayWithObject:errorMsg]);
    }];
}
    
    
-(void)CreateTransferBookingRequestPayPalPayment:(TransferBookingRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:@"api/Partner/CreateTransferBookingRequestPayPalPayment" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        CreateTransferBookingRequestPayPalPaymentResponse *responseObj = [CreateTransferBookingRequestPayPalPaymentResponse modelObjectWithDictionary:responseObject];
        block([NSArray arrayWithObject:responseObj]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self ShowMessageOnError:error WithBlock:block];
    }];
}

-(void)GetClientConfiguration: (BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setAuthorizationHeader];
    [self GET:@"api/Partner/GetClientConfiguration" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        ClientConfigurationResponse* temp = [ClientConfigurationResponse modelObjectWithDictionary:responseObject];
        block([NSArray arrayWithObject:temp]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        self.blockErrorDefault(error);
        block([NSArray array]);
    }];
}

-(void)GetTransferServicePricesForZone:(NSInteger)dropoffZoneId orLatLng:(LatLng *)ll withBlock:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setAuthorizationHeader];
    NSDictionary *params = ll ? @{@"model.dropoffLocation.lat": @(ll.lat), @"model.dropoffLocation.lng": @(ll.lng)} : @{@"model.dropoffZoneId": @(dropoffZoneId)};
    [self GET:@"api/Partner/GetTransferServicePrices" parameters:params  progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *carPricesArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            carPricesArray[idx] = [CarPrice modelObjectWithDictionary:obj];
        }];
        block(carPricesArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        self.blockErrorDefault(error);
        block([NSArray array]);
    }];
}

-(void)ConfirmPhoneNumberWithCode:(NSString *)code forUser:(NSString *)userId withBlock:(BlockBoolean)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"api/Account/ConfirmPhoneNumber?code=%@&userId=%@", code, [AppDelegate urlencode:userId]];

    [self POST:url parameters:nil  progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        block(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        self.blockErrorDefault(error);
        block(NO);
    }];
}

-(void)SendPhoneNumberConfirmationForUser:(NSString *)userId withBlock:(BlockString)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"api/Account/SendPhoneNumberConfirmation?userId=%@", [AppDelegate urlencode:userId]];
    [self POST:url parameters:nil  progress:self.blockProgressDefault success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString* code = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        code = [code substringWithRange:NSMakeRange(1, code.length-2)];
        block(code);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        self.blockErrorDefault(error);
        block(nil);
    }];
}

-(void)FetchTerms:(NSString *)culture withBlock:(BlockString)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:@"api/Account/FetchTerms" parameters:@{@"Culture": culture} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        [self.hud hideAnimated:YES];
        block(dict[@"Text"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

-(void)ValidateLocation:(LatLng *)ll forLocation:(NSInteger)fleetLocationId withBlock:(BlockBoolean)block {
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params =  @{@"model.latLng.lat": @(ll.lat), @"model.latLng.lng": @(ll.lng),@"model.fleetLocationId": @(fleetLocationId)};
    [self GET:@"api/Web/ValidateLocation" parameters:params  progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
         NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        BOOL isTrue = [str isEqualToString:@"true"];
        block(isTrue);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        self.blockErrorDefault(error);
        block(NO);
    }];
}

@end
