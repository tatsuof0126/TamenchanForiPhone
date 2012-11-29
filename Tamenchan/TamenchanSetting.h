//
//  TamenchanSetting.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GAMELEVEL_EASY   0
#define GAMELEVEL_NORMAL 1
#define GAMELEVEL_HARD   2

#define HAITYPE_MANZU    0
#define HAITYPE_PINZU    1
#define HAITYPE_SOUZU    2

@interface TamenchanSetting : NSObject

- (int)getGameLevel;

- (int)getHaiType;

@end
