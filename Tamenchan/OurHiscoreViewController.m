//
//  OurHiscoreViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "OurHiscoreViewController.h"
#import "HiScoreTabController.h"
#import "SelectConfigViewController.h"
#import "AppDelegate.h"
#import "RegisteredHiScore.h"
#import "TamenchanSetting.h"
#import "TamenchanDefine.h"

@interface OurHiscoreViewController ()

@end

@implementation OurHiscoreViewController

@synthesize scrollView;
@synthesize actIndView;
@synthesize titleLabel;
@synthesize connecting;

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
    
    // iPhone5対応
    [AppDelegate adjustForiPhone5:scrollView];
    
//    [self updateTitle];
//    [self getOurHiScore];
    
}

- (void)getOurHiScore {
    // 通信中なら処理しない
    if(connecting == YES){
        return;
    }
    
    //ぐるぐるを出す
    actIndView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [actIndView setCenter:self.view.center];
    [actIndView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:actIndView];
    [actIndView startAnimating];
    
    [self performSelectorInBackground:@selector(doInBackground) withObject:nil];
}

- (void)doInBackground {
	@autoreleasepool {
        connecting = YES;
        
        HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
        int viewgamelevel = controller.viewgamelevel;
        
        // URLリクエストを準備
        NSString* urlStr = [NSString stringWithFormat:@"%@%@?gamelevel=%d",
            [TamenchanDefine getServerHost],[TamenchanDefine getServerPath],viewgamelevel];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        // URLからJSONデータを取得(NSData)
        NSURLResponse* response;
        NSError* error;
        NSData* retData = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:&response error:&error];
        
        NSArray* regHiScoreArray;
        NSError* jsonError;
        if (retData != nil) {
            regHiScoreArray = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:&jsonError];
        } else {
            regHiScoreArray = [NSArray array];
        }
        
//        NSLog(@"error : %@",error);
//        NSLog(@"jsonError : %@",jsonError);
        
        // ぐるぐる終了
        [actIndView stopAnimating];
        if( [regHiScoreArray count] >= 1){
            [self updateOurHiScores:regHiScoreArray];
        } else {
            NSString* errorMsg = [NSString stringWithFormat:
                                  @"しばらくしてから再度お試しください。\n%@ %d", error.domain, error.code];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"取得に失敗しました"
                message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        // スクロールを最上部に
        [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];

        connecting = NO;
	}
}

- (void)updateOurHiScores:(NSArray*)hiScoreArray {
    for (UIView *view in [[scrollView subviews] reverseObjectEnumerator]) {
        [view removeFromSuperview];
    }
    
    NSMutableArray* registeredHiScoreArray = [NSMutableArray array];

    for(int i=0;i<[hiScoreArray count];i++){
        NSDictionary* hiScoreDic = [hiScoreArray objectAtIndex:i];
        RegisteredHiScore* hiScore = [RegisteredHiScore makeRegisteredHiScore:hiScoreDic];
        [registeredHiScoreArray addObject:hiScore];
    }

    NSString* deviceId = [TamenchanSetting getDeviceId];
    
    for(int i=0;i<[registeredHiScoreArray count];i++){
        RegisteredHiScore* regHiScore = [registeredHiScoreArray objectAtIndex:i];
        
        UILabel* rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, i*30, 45, 21)];
        rankLabel.textAlignment = UITextAlignmentCenter;
        rankLabel.text = [NSString stringWithFormat:@"%d位",regHiScore.rank];
        rankLabel.backgroundColor = self.view.backgroundColor;

        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, i*30, 170, 21)];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.text = regHiScore.name;
        nameLabel.backgroundColor = self.view.backgroundColor;
        
        UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, i*30, 50, 21)];
        scoreLabel.textAlignment = UITextAlignmentRight;
        scoreLabel.text = [NSString stringWithFormat:@"%d点",regHiScore.score];
        scoreLabel.backgroundColor = self.view.backgroundColor;
        
        if([regHiScore.devId isEqualToString:deviceId] == YES){
            rankLabel.textColor  = [UIColor redColor];
            nameLabel.textColor  = [UIColor redColor];
            scoreLabel.textColor = [UIColor redColor];
        }
        
        [scrollView addSubview:rankLabel];
        [scrollView addSubview:nameLabel];
        [scrollView addSubview:scoreLabel];
    }
    
    CGSize size = CGSizeMake(320, 45+[registeredHiScoreArray count]*30);
    scrollView.contentSize = size;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 私のハイスコアのメッセージを固定文言にする
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    controller.messageShow = NO;
    
    NSString* segueStr = [segue identifier];
    SelectConfigViewController *viewController = [segue destinationViewController];
    if ([segueStr isEqualToString:@"level"] == YES) {
        viewController.selecttype = TYPE_VIEW_LEVEL;
    }
}

- (void)updateTitle {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    titleLabel.text = [NSString stringWithFormat:@"みんなのハイスコア  ＜%@＞",
                       [TamenchanSetting getGameLevelString:controller.viewgamelevel]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setActIndView:nil];
    [self setScrollView:nil];
    [self setTitleLabel:nil];
}

- (IBAction)reloadButton:(id)sender {
    [self getOurHiScore];
}

- (IBAction)backButton:(id)sender {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    [controller segueBack];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTitle];
    [self getOurHiScore];
}

@end
