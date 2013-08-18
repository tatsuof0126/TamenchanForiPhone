//
//  TamenchanDefine.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/09.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MY_BANNER_UNIT_ID	@"a15210c066d36c4"

@interface TamenchanDefine : NSObject

+ (int)getTargetMachiNum;
+ (int)getBonusScore:(int)machiNum;

+ (NSString*)getServerHost;
+ (NSString*)getServerPath;

@end
