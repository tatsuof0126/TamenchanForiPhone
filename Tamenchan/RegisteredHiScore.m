//
//  RegisteredHiScore.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/16.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "RegisteredHiScore.h"

@implementation RegisteredHiScore

@synthesize registeredId;
@synthesize name;
@synthesize devId;
@synthesize rank;
@synthesize score;
@synthesize date;

+ (RegisteredHiScore*)makeRegisteredHiScore:(NSDictionary*)dictionary {
    RegisteredHiScore* hiScore = [[RegisteredHiScore alloc] init];
    
    hiScore.registeredId = [[dictionary objectForKey:@"id"] intValue];
    hiScore.name = [dictionary objectForKey:@"name"];
    hiScore.devId = [dictionary objectForKey:@"devid"];
    hiScore.rank = [[dictionary objectForKey:@"rank"] intValue];
    hiScore.score = [[dictionary objectForKey:@"score"] intValue];
    
    NSString* dateStr = [dictionary objectForKey:@"achieved_date"];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    hiScore.date = [inputFormatter dateFromString:dateStr];
    
    return hiScore;
}

@end
