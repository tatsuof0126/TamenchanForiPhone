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
        
        NSLog(@"doInBackground");
        
        /*
        // SubViewを一旦全削除
        for (UIView *view in [[scrollView subviews] reverseObjectEnumerator]) {
            [view removeFromSuperview];
        }
         
        // SubViewを一旦全削除
        NSArray* subviewArray = [NSArray arrayWithArray:[scrollView subviews]];
        for (UIView *view in subviewArray){
            [view removeFromSuperview];
        }
        
        NSArray* subViewArray = [scrollView subviews];
        for(int i=0;i<[subViewArray count];i++){
            UIView* view = [subViewArray objectAtIndex:i];
            [view removeFromSuperview];
        }
         
         NSLog(@"subview deleted");
         */
        
        
        HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
        int viewgamelevel = controller.viewgamelevel;
        
        // URLリクエストを準備
        NSString* urlStr = [NSString stringWithFormat:@"%@%@?gamelevel=%d",
            [TamenchanDefine getServerHost],[TamenchanDefine getServerPath],viewgamelevel];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        // URLからJSONデータを取得(NSData)
        NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSLog(@"response received");
        
        NSArray* regHiScoreArray;
        NSError* error;
        if (response != nil) {
            regHiScoreArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
        } else {
            regHiScoreArray = [NSArray array];
        }
        
        NSLog(@"error : %@",error);
        
        [self updateOurHiScores:regHiScoreArray];
        
        // スクロールを最上部に
        [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];

        // ぐるぐる終了
        [actIndView stopAnimating];
        
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
    
    for(int i=0;i<[registeredHiScoreArray count];i++){
        RegisteredHiScore* regHiScore = [registeredHiScoreArray objectAtIndex:i];
        
        UILabel* rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, i*30, 45, 21)];
        rankLabel.textAlignment = UITextAlignmentCenter;
        rankLabel.text = [NSString stringWithFormat:@"%d位",regHiScore.rank];
        
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, i*30, 170, 21)];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.text = regHiScore.name;

        UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, i*30, 50, 21)];
        scoreLabel.textAlignment = UITextAlignmentRight;
        scoreLabel.text = [NSString stringWithFormat:@"%d点",regHiScore.score];
        
        [scrollView addSubview:rankLabel];
        [scrollView addSubview:nameLabel];
        [scrollView addSubview:scoreLabel];
    }
    
    CGSize size = CGSizeMake(320, 45+[registeredHiScoreArray count]*30);
    scrollView.contentSize = size;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* segueStr = [segue identifier];
    SelectConfigViewController *viewController = [segue destinationViewController];
    if ([segueStr isEqualToString:@"level"] == true) {
        viewController.selecttype = TYPE_VIEW_LEVEL;
    }
}

- (void)updateTitle {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    int viewgamelevel = controller.viewgamelevel;
    
    NSArray* array = [TamenchanSetting getGameLevelStringArray];
    titleLabel.text = [NSString stringWithFormat:@"みんなのハイスコア  ＜%@＞",[array objectAtIndex:viewgamelevel]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setActIndView:nil];
    [self setScrollView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
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
