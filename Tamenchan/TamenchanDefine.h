//
//  TamenchanDefine.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/09.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TamenchanDefine : NSObject

+ (int)getTargetMachiNum;
+ (int)getBonusScore:(int)machiNum;

+ (NSString*)getServerHost;
+ (NSString*)getServerPath;

@end
