//
//  carkyipadTests.m
//  carkyipadTests
//
//  Created by Filippos Sakellaropoulos on 6/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CarkyApiClient.h"
#import "DataModels.h"

@interface carkyipadTests : XCTestCase
@property (nonatomic,strong) CarkyApiClient *api;
@end

@implementation carkyipadTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.api = [CarkyApiClient sharedService];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginWithUsername {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all fleet locations"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api loginWithUsername:@"phisakel@gmail.com" andPassword:@"12345678" withTokenBlock:^(BOOL result) {
        XCTAssert(result == YES,"cannot login");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}


- (void)testGetAvailableCars {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all car categories"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetAvailableCars:1 withBlock:^(NSArray *array) {
        XCTAssert(array.count>0,"not found available cars");
        AvailableCars *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[AvailableCars class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}


- (void)testGetAllCarTypes {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all car types"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetAllCarTypes:^(NSArray *array) {
        XCTAssert(array.count>0,"not found car types");
        CarType *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[CarType class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testGetWellKnownLocations {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch well known locations for Mykonos"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetWellKnownLocations:2 withBlock:^(NSArray *array) {
        XCTAssert(array.count>0,"not found available locations");
        Location *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[Location class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testGetTransferServiceWebAvailableCars {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch available cars for Mykonos"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetTransferServiceWebAvailableCars:2 withBlock:^(NSArray *array) {
        XCTAssert(array.count>0,"not found available cars");
        Cars *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[Cars class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testGetTransferServicePartnerAvailableCars {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch available cars for Mykonos"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetTransferServicePartnerAvailableCars:2 withBlock:^(NSArray *array) {
        XCTAssert(array.count>0,"not found available cars");
        CarCategory *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[CarCategory class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testGetPublishableApiKey {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch api key for stripe"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api loginWithUsername:@"phisakel@gmail.com" andPassword:@"12345678" withTokenBlock:^(BOOL result) {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        [self.api GetStripePublishableApiKey:^(NSString *str) {
            XCTAssert(str.length>0,"not found available stripe api key");
            [expectation fulfill];
        }];
     }];
     [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testFindNearestCarkyDriverPositions {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch nearest carky drivers"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api loginWithUsername:@"phisakel@gmail.com" andPassword:@"12345678" withTokenBlock:^(BOOL result) {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        CarkyDriverPositionsRequest *request = [CarkyDriverPositionsRequest new];
        //CarkyCategoryId 1=Executive  2=Luxury  3=Suv
        request.carkyCategoryId = 1;
        request.position = [LatLng new]; request.position.lat = 37.445852; request.position.lng = 25.326315;
        [self.api FindNearestCarkyDriverPositions:request withBlock:^(NSArray *array) {
            XCTAssert(array.count>0,"not found available drivers");
            CarkyDriverPositionsResponse *c0 = array[0];
            XCTAssert([c0 isKindOfClass:[Cars class]], @"wrong class");
            [expectation fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

-(void)testGetStripeApiKeyFromInfoPList {
   NSString *apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"StripeApiKey"];
   XCTAssert(apiKey.length>0,"not found available api key");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
