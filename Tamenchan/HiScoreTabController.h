//
//  HiScoreTabController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/15.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEGUE_TYPE_MENU   1
#define SEGUE_TYPE_GAME   2
#define SEGUE_TYPE_RESULT 3

@interface HiScoreTabController : UITabBarController

@property int seguetype;
@property bool tweeted;

@property int score;
@property int rank;
@property int viewgamelevel;

- (void)segueBack;

@end
