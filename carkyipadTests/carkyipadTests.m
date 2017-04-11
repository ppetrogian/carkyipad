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

- (void)testGetFleetLocationsFull {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all fleet locations"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetFleetLocationsFull:^(NSArray *array) {
        XCTAssert(array.count>0,"not found locations");
        FleetLocations *f0 = array[0];
        XCTAssert([f0 isKindOfClass:[FleetLocations class]], @"wrong class");
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

- (void)testGetExtrasPerCarType {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all car extras"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetCarExtras:^(NSArray *array) {
        XCTAssert(array.count>0,"not found car extras");
        CarExtra *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[CarExtra class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testGetAllCarInsurances {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all car insurances"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetAllCarInsurances:^(NSArray *array) {
        XCTAssert(array.count>0,"not found car insurances");
        CarInsurance *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[CarInsurance class]], @"wrong class");
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

- (void)testGetTransferServiceAvailableCars {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch available cars for Mykonos"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetTransferServiceAvailableCars:2 withBlock:^(NSArray *array) {
        XCTAssert(array.count>0,"not found available cars");
        Cars *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[Cars class]], @"wrong class");
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
            XCTAssert(str.length>0,"not found available locations");
            [expectation fulfill];
        }];
     }];
     [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
