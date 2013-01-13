//
//  ConfigViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "ConfigViewController.h"
#import "SelectConfigViewController.h"
#import "TamenchanSetting.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

@synthesize gamelevelLabel;
@synthesize haitypeLabel;
@synthesize haitypeImage;
@synthesize versionLabel;

@synthesize adView;
@synthesize bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"ためんちゃん  version%@",version];
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, -320, 0);
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    [self.view addSubview:adView];
    adView.delegate = self;
    bannerIsVisible = NO;
}

- (void)bannerViewDidLoadAd:(ADBannerView*)banner{
    if (bannerIsVisible == NO){
        banner.frame = CGRectOffset(banner.frame, 320, 44);
        [self.view addSubview:banner];
        bannerIsVisible = YES;
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError*)error{
    if (bannerIsVisible == YES){
        banner.frame = CGRectOffset(banner.frame, -320, 0);
        bannerIsVisible = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString* segueStr = [segue identifier];
    
    SelectConfigViewController *viewController = [segue destinationViewController];
    if ([segueStr isEqualToString:@"level"] == YES) {
        viewController.selecttype = TYPE_LEVEL;
    } else if ([segueStr isEqualToString:@"haitype"] == YES) {
        viewController.selecttype = TYPE_HAITYPE;
    }
}

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    int haitype = [TamenchanSetting getHaiType];
    
    gamelevelLabel.text = [TamenchanSetting getGameLevelString];
    haitypeLabel.text = [[TamenchanSetting getHaiTypeStringArray] objectAtIndex:haitype];
    NSString* imageString = [[TamenchanSetting getHaiTypeImageStringArray] objectAtIndex:haitype];
    
    haitypeImage.image = [UIImage imageNamed:imageString];
}

- (void)viewDidUnload {
    [self setGamelevelLabel:nil];
    [self setHaitypeLabel:nil];
    [self setHaitypeImage:nil];
    [self setVersionLabel:nil];
    [super viewDidUnload];
}

@end
