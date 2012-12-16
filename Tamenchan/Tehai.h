//
//  Tehai.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/25.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HAI_LENGTH 10
#define TEHAI_LENGTH 13

#define HAI_TYPE_MANZU 0
#define HAI_TYPE_PINZU 1
#define HAI_TYPE_SOUZU 2
#define HAI_TYPE_JIHAI 3

@interface Tehai : NSObject

@property NSMutableArray* hai2;
@property NSMutableArray* used2;

@property int* hai;
@property BOOL* used;

- (void)haipai;
- (void)haipai:(int*)presenthai;
- (void)shihai;
- (void)putTehai:(int*)targethai;
- (Tehai*)copyTehai;
- (NSArray*)getRamdomHaiArray;

- (void)logTehai;

+ (NSArray*)getHaiImageArray:(int)haitype;

+ (int*)getPresetJihai3;

@end
