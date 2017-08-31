//
//  NSString+UrlTemplates.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 01/09/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "NSString+UrlTemplates.h"

@implementation NSString (UrlTemplates)
//{media} : web | tablet | mobile |... για εσας ipad
//{active} : active | inactive
//
//θα κάνετε replace το {media} με web και το {active} με active ή inactive
-(NSString *)replaceForIpad:(BOOL)isActive {
    NSString *str = self;
    str = [str stringByReplacingOccurrencesOfString:@"{media}" withString:@"ipad"];
    str = [str stringByReplacingOccurrencesOfString:@"{active}" withString:isActive ? @"active" : @"inactive"];
    return str;
}

@end
