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
#import "AppDelegate.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

@synthesize gamelevelLabel;
@synthesize haitypeLabel;
@synthesize haitypeImage;
@synthesize versionLabel;

@synthesize adView;
@synthesize bannerIsVisible;

@synthesize doingPurchase;
@synthesize actIndView;

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
    
    if([TamenchanSetting isRemoveAdsFlg] == YES){
        _removeadsButton.hidden = YES;
        _restoreButton.hidden = YES;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView*)banner{
    if (bannerIsVisible == NO && [TamenchanSetting isRemoveAdsFlg] == NO){
        banner.frame = CGRectMake(0, 44, banner.frame.size.width, banner.frame.size.height);
//        banner.frame = CGRectOffset(banner.frame, 320, 44);
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

- (IBAction)removeadsButton:(id)sender {
    // 購入処理中なら処理しない
    if(doingPurchase == YES){
        return;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    InAppPurchaseManager* purchaseManager = [delegate getInAppPurchaseManager];
    
    // アプリ内課金が許可されていない場合はダイアログを出す
    if(purchaseManager.canMakePurchases == NO){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@""
            message:@"アプリ内での購入が許可されていません。設定を確認してください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 購入処理開始
    doingPurchase = YES;
    
    // 自分自身の参照をセット
    purchaseManager.source = self;
    
    //ぐるぐるを出す
    actIndView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [actIndView setCenter:self.view.center];
    [actIndView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:actIndView];
    [actIndView startAnimating];
    
    // アプリ内課金を呼び出し
    [purchaseManager requestProductData:@"removeads"];
}

- (IBAction)restoreButton:(id)sender {
    // 購入処理中なら処理しない
    if(doingPurchase == YES){
        return;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    InAppPurchaseManager* purchaseManager = [delegate getInAppPurchaseManager];
    
    // アプリ内課金が許可されていない場合はダイアログを出す
    if(purchaseManager.canMakePurchases == NO){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@""
            message:@"アプリ内での購入が許可されていません。設定を確認してください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 購入処理開始
    doingPurchase = YES;
    
    // 自分自身の参照をセット
    purchaseManager.source = self;
    
    // アプリ内課金（リストア）を呼び出し
    [purchaseManager restoreProduct];
}

- (void)endConnecting {
    [actIndView stopAnimating];
}

- (void)endPurchase {
    doingPurchase = NO;
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
    [self setRemoveadsButton:nil];
    [self setRestoreButton:nil];
    [super viewDidUnload];
}

@end
