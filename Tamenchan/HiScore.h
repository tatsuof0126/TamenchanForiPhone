//
//  HiScore.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/11.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_LENGTH_NAME 10

@interface HiScore : NSObject

@property NSString* name;
@property int score;
@property long date;
@property int registeredId;

+ (NSArray*)readHiScore:(int)gamelevel;
+ (void)writeHiScore:(int)gamelevel hiScoreArray:(NSArray*)hiScoreArray;
+ (void)clearHiScore:(int)gamelevel;

+ (NSString*)getLastRegistName;

@end
