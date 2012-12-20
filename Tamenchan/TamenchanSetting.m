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

+ (NSString*)getGameLevelString {
    return [TamenchanSetting getGameLevelString:[TamenchanSetting getGameLevel]];
}

+ (NSString*)getGameLevelString:(int)gamelevel {
    NSArray* array = [TamenchanSetting getGameLevelStringArray];
    return [array objectAtIndex:gamelevel];
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

+ (NSString*)getDeviceId {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* deviceId = [defaults objectForKey:@"DEVICEID"];
    
    if(deviceId == nil || [deviceId isEqualToString:@""]){
        // UUIDを作成
        CFUUIDRef uuidObj = CFUUIDCreate(nil);
        deviceId = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
        CFRelease(uuidObj);
        
        [defaults setObject:deviceId forKey:@"DEVICEID"];
        [defaults synchronize];
    }
    
//    NSLog(@"deviceId : %@",deviceId);
    
    return deviceId;
}

+ (void)clearDeviceId {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"DEVICEID"];
    [defaults synchronize];
}

+ (BOOL)canSelectHard {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"SELECTHARDFLG"];
}

+ (void)setSelectHard:(BOOL)selectHard {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:selectHard forKey:@"SELECTHARDFLG"];
    [defaults synchronize];
}

@end
