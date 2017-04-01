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
    [config setHTTPAdditionalHeaders:@{@"User-Agent": @"Carky iPAD iOS 1.0", @"Accept": @"application/json", @"Accept-Charset": @"UTF-8", @"Accept-Encoding": @"gzip"}];
    self = [[CarkyApiClient alloc] initWithBaseURL:[NSURL URLWithString:Base_URL] sessionConfiguration:config];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    return self;
}

-(void)setAuthorizationHeader {
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@", self.apiKey];
    [self.requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
}

#pragma mark API CALLS
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password withTokenBlock:(BlockBoolean)block {
    [self POST:@"token" parameters:@{@"grant_type":@"password",@"username":username, @"password":password} progress:self.blockProgressDefault success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject objectForKey:@"error"]) {
            self.lastMessage = responseObject[@"error_description"];
            block(NO);
        } else {
            self.apiKey = responseObject[@"access_token"];
            block(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.blockErrorDefault(error);
        block(NO);
    }];
}


-(void)GetFleetLocationsFull:(BlockArray)block {
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

-(void)GetExtrasPerCarType:(BlockArray)block {
    [self GET:@"api/Helper/GetExtrasPerCarType" parameters:nil progress:self.blockProgressDefault  success:^(NSURLSessionDataTask *task, id responseObject) {
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

@end
