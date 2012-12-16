//
//  TamenchanSetting.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "TamenchanSetting.h"

@implementation TamenchanSetting

static NSArray* gameLevelStringArray;
static NSArray* haiTypeStringArray;
static NSArray* haiTypeImageStringArray;

+ (int)getGameLevel {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"GAMELEVEL"];
}

+ (void)setGameLevel:(int)level {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:level forKey:@"GAMELEVEL"];
    [defaults synchronize];
}

+ (NSArray*)getGameLevelStringArray {
    if( gameLevelStringArray == NULL ){
        gameLevelStringArray = [NSArray arrayWithObjects:@"初級",@"中級",@"上級",nil];
    }
    return gameLevelStringArray;
}


+ (int)getHaiType {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"HAITYPE"];
}

+ (void)setHaiType:(int)haitype {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:haitype forKey:@"HAITYPE"];
    [defaults synchronize];
}

+ (NSArray*)getHaiTypeStringArray {
    if( haiTypeStringArray == NULL ){
        haiTypeStringArray = [NSArray arrayWithObjects:@"萬子",@"筒子",@"索子",nil];
    }
    return haiTypeStringArray;
}

+ (NSArray*)getHaiTypeImageStringArray {
    if( haiTypeImageStringArray == NULL ){
        haiTypeImageStringArray = [NSArray arrayWithObjects:@"m1.gif",@"p1.gif",@"s1.gif",nil];
    }
    return haiTypeImageStringArray;
}

@end
