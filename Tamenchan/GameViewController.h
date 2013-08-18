//
//  GameViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tehai.h"
#import "TimerView.h"
#import "GADBannerView.h"

@interface GameViewController : UIViewController <GADBannerViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tehaiImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *choiceHaiImage;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet TimerView *timerBar;

@property NSTimer* showTimer;
@property NSTimer* questionTimer;

@property Tehai* questionTehai;
@property BOOL* choice;
@property int remainingTime;

@property int question;
@property int score;

- (IBAction)backButton:(id)sender;
- (IBAction)judgeButton:(id)sender;

- (void)replayGame;

@end
