//
//  ConfigViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ConfigViewController : UIViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *gamelevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *haitypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *haitypeImage;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)backButton:(id)sender;

@property (strong, nonatomic) ADBannerView *adView;
@property BOOL bannerIsVisible;

@end
