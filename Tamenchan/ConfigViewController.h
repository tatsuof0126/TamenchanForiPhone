//
//  ConfigViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "InAppPurchaseProtocol.h"

@interface ConfigViewController : UIViewController <ADBannerViewDelegate, InAppPurchaseProtocol>

@property (weak, nonatomic) IBOutlet UILabel *gamelevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *haitypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *haitypeImage;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (strong, nonatomic) IBOutlet UIButton *removeadsButton;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;

- (IBAction)backButton:(id)sender;

- (IBAction)removeadsButton:(id)sender;

- (IBAction)restoreButton:(id)sender;

@property (strong, nonatomic) ADBannerView *adView;
@property BOOL bannerIsVisible;

@property BOOL doingPurchase;
@property (strong, nonatomic) UIActivityIndicatorView* actIndView;

@end
