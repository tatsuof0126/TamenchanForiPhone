//
//  HiScore.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/11.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "HiScore.h"

#define KEYTYPE_NAME  0
#define KEYTYPE_SCORE 1
#define KEYTYPE_DATE  2
#define KEYTYPE_REGID 3

@implementation HiScore

@synthesize name;
@synthesize score;
@synthesize date;
@synthesize registeredId;

static NSMutableArray* keyArray;

- (HiScore*)init {
    HiScore* hiScore = [super init];
    hiScore.name = @"No Name";
    hiScore.score = 0;
    hiScore.date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    hiScore.registeredId = DEFAULT_REGID;
    return hiScore;
}

+ (NSArray*)readHiScore:(int)gamelevel {
    NSMutableArray* hiScoreArray = [NSMutableArray array];
    
    NSArray* nameKeyArray  = [self getKey:KEYTYPE_NAME  gamelevel:gamelevel];
    NSArray* scoreKeyArray = [self getKey:KEYTYPE_SCORE gamelevel:gamelevel];
    NSArray* dateKeyArray  = [self getKey:KEYTYPE_DATE  gamelevel:gamelevel];
    NSArray* regidKeyArray = [self getKey:KEYTYPE_REGID gamelevel:gamelevel];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    for(int i=0;i<5;i++){
        HiScore* hiScore = [[HiScore alloc] init];
        hiScore.name  = [defaults stringForKey:[nameKeyArray objectAtIndex:i]];
        hiScore.score = [defaults integerForKey:[scoreKeyArray objectAtIndex:i]];
        hiScore.date  = [defaults objectForKey:[dateKeyArray objectAtIndex:i]];
        hiScore.registeredId = [defaults integerForKey:[regidKeyArray objectAtIndex:i]];
        
        if(hiScore.name == nil){
            [hiScore setDefault:gamelevel rank:i+1];
        }
        
//        [hiScore print]; // ログ
        
        [hiScoreArray addObject:hiScore];
    }
    
    return hiScoreArray;
}

+ (void)writeHiScore:(int)gamelevel hiScoreArray:(NSArray*)hiScoreArray {
    NSArray* nameKeyArray  = [self getKey:KEYTYPE_NAME  gamelevel:gamelevel];
    NSArray* scoreKeyArray = [self getKey:KEYTYPE_SCORE gamelevel:gamelevel];
    NSArray* dateKeyArray  = [self getKey:KEYTYPE_DATE  gamelevel:gamelevel];
    NSArray* regidKeyArray = [self getKey:KEYTYPE_REGID gamelevel:gamelevel];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    for(int i=0;i<5;i++){
        HiScore* hiScore = [hiScoreArray objectAtIndex:i];
        
        [hiScore print];
        
        [defaults setObject:hiScore.name forKey:[nameKeyArray objectAtIndex:i]];
        [defaults setInteger:hiScore.score forKey:[scoreKeyArray objectAtIndex:i]];
        [defaults setObject:hiScore.date forKey:[dateKeyArray objectAtIndex:i]];
        [defaults setInteger:hiScore.registeredId forKey:[regidKeyArray objectAtIndex:i]];
    }
    
    [defaults synchronize];
}

+ (void)clearHiScore:(int)gamelevel {
    NSMutableArray* defaultArray = [NSMutableArray array];
    
    for(int i=0;i<5;i++){
        HiScore* hiScore = [[HiScore alloc] init];
        [hiScore setDefault:gamelevel rank:i+1];
        [defaultArray addObject:hiScore];
    }
    
    [HiScore writeHiScore:gamelevel hiScoreArray:defaultArray];
}

+ (NSString*)getLastRegistName {
    NSString* lastRegistName = @"";
    NSDate* lastDate = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    for(int i=0;i<=2;i++){
        NSArray* nameKeyArray  = [self getKey:KEYTYPE_NAME  gamelevel:i];
        NSArray* dateKeyArray  = [self getKey:KEYTYPE_DATE  gamelevel:i];
        
        for(int j=0;j<5;j++){
            NSDate* tmpDate = [defaults objectForKey:[dateKeyArray objectAtIndex:j]];
            if([lastDate timeIntervalSince1970] < [tmpDate timeIntervalSince1970]){
                lastRegistName = [defaults stringForKey:[nameKeyArray objectAtIndex:j]];
                lastDate = tmpDate;
            }
        }
    }
    
    return lastRegistName;
}

+ (NSArray*)getKey:(int)keytype gamelevel:(int)gamelevel {
    if(keyArray == nil){
        keyArray = [NSMutableArray array];
        
        NSArray* keyTypeArray = [NSArray arrayWithObjects:@"name",@"score",@"date",@"regid",nil];
        
        for(int i=0;i<[keyTypeArray count];i++){
            NSMutableArray* keyArrayOfType = [NSMutableArray array];
            NSString* keyTypeString = [keyTypeArray objectAtIndex:i];
            for(int j=0;j<3;j++){
                NSMutableArray* keyArrayOfLevel = [NSMutableArray array];
                for(int k=1;k<=5;k++){
                    NSString* keyString = [NSString stringWithFormat:@"%@%d%d",keyTypeString,j,k];
                    [keyArrayOfLevel addObject:keyString];
                }
                [keyArrayOfType addObject:keyArrayOfLevel];
            }
            [keyArray addObject:keyArrayOfType];
        }
    }
    
    return [[keyArray objectAtIndex:keytype] objectAtIndex:gamelevel];
}

- (NSString*)getDateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSLog(@"date : %@",[formatter stringFromDate:date]);
    
    return [formatter stringFromDate:date];
}

- (void)setDefault:(int)gamelevel rank:(int)rank {
    name = @"No Name";
    if(gamelevel == 2){
        // 上級
        score = (6-rank)*2;
    } else {
        // 初級・中級
        score = (6-rank)*5;
    }
    date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    registeredId = DEFAULT_REGID;
}

- (void)print {
    NSLog(@"name : %@",name);
    NSLog(@"score : %d",score);
    NSLog(@"date : %@",date);
    NSLog(@"regid : %d",registeredId);
}

@end
