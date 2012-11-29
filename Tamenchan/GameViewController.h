//
//  GameViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tehaiImage;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *choiceHaiImage;











- (IBAction)backButton:(id)sender;
- (IBAction)judgeButton:(id)sender;

@end
