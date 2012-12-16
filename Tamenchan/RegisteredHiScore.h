//
//  RegisteredHiScore.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/16.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisteredHiScore : NSObject

@property int registeredId;
@property NSString* name;
@property NSString* devId;
@property int rank;
@property int score;
@property NSDate* date;

+ (RegisteredHiScore*)makeRegisteredHiScore:(NSDictionary*)dictionary;

@end
