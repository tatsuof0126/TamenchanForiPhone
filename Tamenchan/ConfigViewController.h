//
//  ConfigViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *gamelevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *haitypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *haitypeImage;

- (IBAction)configTwitter:(id)sender;

- (IBAction)backButton:(id)sender;

@end
