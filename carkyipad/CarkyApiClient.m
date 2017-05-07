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

#define Base_URL @"http://carky-app.azurewebsites.net"

@implementation CarkyApiClient
static CarkyApiClient *_sharedService = nil;

+ (instancetype)sharedService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        // create and init instance
        _sharedService = [[CarkyApiClient alloc] initWithDefaultConfiguration];
        //Callback for reachability status change
        _sharedService.isOffline = NO;
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

-(instancetype)initWithDefaultConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"User-Agent": @"Carky iPAD iOS 1.0", @"Accept": @"application/json, text/plain, text/html", @"Accept-Charset": @"UTF-8", @"Accept-Encoding": @"gzip"}];
    self = [[CarkyApiClient alloc] initWithBaseURL:[NSURL URLWithString:Base_URL] sessionConfiguration:config];
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
            NSLog(@"Access token: %@", self.apiKey);
            block(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
        block(NO);
    }];
}


-(void)GetFleetLocationsFull:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Web/GetFleetLocationsFull" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        [self.hud hideAnimated:YES];
        NSMutableArray *flockArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            flockArray[idx] = [FleetLocations modelObjectWithDictionary:obj];
        }];
        block(flockArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

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

-(void)GetCarExtras:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Helper/GetCarExtras" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
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

-(void)GetAllCarInsurances:(BlockArray)block {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Helper/GetAllCarInsurances" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSMutableArray *carInsArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            carInsArray[idx] = [CarInsurance modelObjectWithDictionary:obj];
        }];
        block(carInsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

#pragma Web api Taxi Api calls

-(void)GetWellKnownLocations:(NSInteger)fleetLocationId withBlock:(BlockArray)block {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Web/GetWellKnownLocations" parameters:@{@"fleetLocationId": @(fleetLocationId)} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
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
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self GET:@"api/Partner/GetTransferServiceAvailableCars" parameters:@{@"fleetLocationId": @(fleetLocationId)} progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        [self.hud hideAnimated:YES];
        NSMutableArray *carsArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            carsArray[idx] = [CarCategory modelObjectWithDictionary:obj];
        }];
        block(carsArray);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

-(void)GetStripePublishableApiKey:(BlockString)block {
    // todo: allow json fragments or accept plain http
    [self setAuthorizationHeader];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self GET:@"api/StripePayment/GetPublishableApiKey" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str = (NSString *)responseObject;
        block(str);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
    }];
}

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

-(void)RegisterClient:(RegisterClientRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self POST:@"api/Partner/RegisterClient" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        RegisterClientResponse *response = [RegisterClientResponse modelObjectWithDictionary:responseObject];
        block([NSArray arrayWithObject:response]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSString *errorMsg = [errorStr substringWithRange:NSMakeRange(12, errorStr.length-14)];
        NSLog(@"Error Detail: %@", errorMsg);
        self.blockErrorDefault(error);
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        block([NSArray arrayWithObject:errorMsg]);
    }];
}

-(void)CreateTransferBookingRequest:(TransferBookingRequest *)request withBlock:(BlockArray)block {
    [self setAuthorizationHeader];
    TransferBookingResponse *responseObj = [TransferBookingResponse new];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self POST:@"api/Partner/CreateTransferBookingRequest" parameters:request.dictionaryRepresentation progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        responseObj.bookingId = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        block([NSArray arrayWithObject:responseObj]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        self.blockErrorDefault(error);
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        responseObj.errorDescription = errorStr;
        block([NSArray arrayWithObject:responseObj]);
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

@end
