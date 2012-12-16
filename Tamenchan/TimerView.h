//
//  TimerView.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/09.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView

@property int remainingTime;

- (void)updateTimerView:(int)time;

@end
