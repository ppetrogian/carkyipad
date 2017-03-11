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

- (void)testGetFleetLocations {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all fleet locations"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetFleetLocations:^(NSArray *array) {
        XCTAssert(array.count>0,"not found locations");
        FleetLocations *f0 = array[0];
        XCTAssert([f0 isKindOfClass:[FleetLocations class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testGetAllCarCategories {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all car categories"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetAllCarCategories:^(NSArray *array) {
        XCTAssert(array.count>0,"not found categories");
        CarCategory *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[CarCategory class]], @"wrong class");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20 handler:^(NSError * error) { }];
}

- (void)testGetExtrasPerCarType {
    // given
    XCTestExpectation *expectation = [self expectationWithDescription:@" fetch all car extras"];
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self.api GetExtrasPerCarType:^(NSArray *array) {
        XCTAssert(array.count>0,"not found car extras");
        CarExtra *c0 = array[0];
        XCTAssert([c0 isKindOfClass:[CarExtra class]], @"wrong class");
        [expectation fulfill];
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
