//
//  Validation.h
//  TheRxApp
//
//  Created by Rahul Mistry on 26/12/14.
//  Copyright (c) 2014 Rajesh Deshmukh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validation : NSObject
-(BOOL)charZipCode:(NSString *)zipCode;
-(BOOL)charValidation:(NSString *)NameValidate;
-(BOOL)emailValidation:(NSString *)emailvalid;
- (BOOL)mobileNumberValidate:(NSString*)number;
-(NSString *)phoneParsing:(NSString *)phoneNo;
-(NSString*)formatNumber:(NSString*)mobileNumber;
-(int)getLength:(NSString*)mobileNumber;
-(NSMutableString *)phoneProcessing :(NSString *)input;
-(BOOL)isDigit:(NSString*)string;
-(BOOL)checkNet;
-(BOOL)netWorkStatus;
- (BOOL)isAlphaNumeric:(NSString *)zipCode;
@end
