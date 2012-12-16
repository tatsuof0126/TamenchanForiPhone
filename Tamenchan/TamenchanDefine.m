//
//  TamenchanDefine.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/09.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "TamenchanDefine.h"

@implementation TamenchanDefine

static NSArray* targetMachiNumArray;
static NSArray* bonusScoreArray;

+ (int)getTargetMachiNum {
    if(targetMachiNumArray == nil){
        NSNumber* n0 = [NSNumber numberWithInt:0];
        NSNumber* n1 = [NSNumber numberWithInt:1];
        NSNumber* n2 = [NSNumber numberWithInt:2];
        NSNumber* n3 = [NSNumber numberWithInt:3];
        NSNumber* n4 = [NSNumber numberWithInt:4];
        NSNumber* n5 = [NSNumber numberWithInt:5];
        NSNumber* n6 = [NSNumber numberWithInt:6];
        
        targetMachiNumArray = [NSArray arrayWithObjects:
                               n0,n0,n0,n1,n1,n1,n1,n1,n1,n1,
                               n1,n1,n1,n1,n1,n1,n1,n1,n1,n1,
                               n1,n1,n1,n1,n1,n2,n2,n2,n2,n2,
                               n2,n2,n2,n2,n2,n2,n2,n2,n2,n2,
                               n2,n2,n2,n2,n2,n2,n2,n2,n2,n2,
                               n3,n3,n3,n3,n3,n3,n3,n3,n3,n3,
                               n3,n3,n3,n3,n3,n3,n3,n3,n3,n3,
                               n3,n3,n3,n3,n3,n4,n4,n4,n4,n4,
                               n4,n4,n4,n4,n4,n4,n4,n4,n4,n4,
                               n5,n5,n5,n5,n5,n5,n5,n6,n6,n6,nil];
    }
    
    int target = rand() % 100;
    return [[targetMachiNumArray objectAtIndex:target] intValue];
}

+ (int)getBonusScore:(int)machiNum {
    if(bonusScoreArray == nil){
        NSNumber* n0 = [NSNumber numberWithInt:0];
        NSNumber* n3 = [NSNumber numberWithInt:3];
        NSNumber* n5 = [NSNumber numberWithInt:5];
        NSNumber* n7 = [NSNumber numberWithInt:7];
        NSNumber* n10 = [NSNumber numberWithInt:10];
        NSNumber* n15 = [NSNumber numberWithInt:15];
        NSNumber* n20 = [NSNumber numberWithInt:20];
        
        bonusScoreArray = [NSArray arrayWithObjects:
                           n0,n0,n0,n3,n5,n7,n10,n10,n15,n20,nil];
    }
    
    return [[bonusScoreArray objectAtIndex:machiNum] intValue];    
}

+ (NSString*)getServerHost {
    return @"http://tamenchanserver.herokuapp.com/";
}

+ (NSString*)getServerPath {
    return @"hiscorelist";
}

@end
