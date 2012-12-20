//
//  MyHiscoreViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "MyHiscoreViewController.h"
#import "HiScoreTabController.h"
#import "SelectConfigViewController.h"
#import "GameViewController.h"
#import "TamenchanSetting.h"
#import "TamenchanDefine.h"
#import "HiScore.h"

#define ALERT_CLEAR    1
#define ALERT_REGISTED 2
#define ALERT_REGISTED_TWEET 3

#define HEADER_BUTTON_CLEAR    1
#define HEADER_BUTTON_CONTINUE 2

@interface MyHiscoreViewController ()

@end

@implementation MyHiscoreViewController

@synthesize messageLabel;
@synthesize titleLabel;
@synthesize rankLabels;
@synthesize nameLabels;
@synthesize scoreLabels;
@synthesize messageShow;
@synthesize headerButton;
// @synthesize continueButton;
@synthesize connecting;
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
    
    messageShow = YES;
    
    // rankLabels,nameLabels,scoreLabelsを正しい順番に並び替え
    rankLabels = [rankLabels sortedArrayUsingSelector:@selector(compare:)];
    nameLabels = [nameLabels sortedArrayUsingSelector:@selector(compare:)];
    scoreLabels = [scoreLabels sortedArrayUsingSelector:@selector(compare:)];
    
    [self updateMessage];
    [self updateTitle];
    [self updateHiScoreLabels];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueButton:(id)sender {
    HiScoreTabController* tabController = (HiScoreTabController*)self.parentViewController;
    int seguetype = tabController.seguetype;
    
    GameViewController* gameController;
    if(seguetype == SEGUE_TYPE_GAME){
        gameController = (GameViewController*)tabController.presentingViewController;
    } else if(seguetype == SEGUE_TYPE_RESULT){
        gameController = (GameViewController*)tabController.presentingViewController.presentingViewController;
    }
    
    [gameController replayGame];
    [gameController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)backButton:(id)sender {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    [controller segueBack];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // メッセージを固定文言にする
    messageShow = NO;
    
    NSString* segueStr = [segue identifier];    
    SelectConfigViewController *viewController = [segue destinationViewController];
    if ([segueStr isEqualToString:@"level"] == YES) {
        viewController.selecttype = TYPE_VIEW_LEVEL;
    }
}

- (IBAction)headerButton:(id)sender {
    if (headerButton.tag == HEADER_BUTTON_CLEAR) {
        // クリアボタン押下
        HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
        int viewgamelevel = controller.viewgamelevel;
        
//        NSArray* array = [TamenchanSetting getGameLevelStringArray];
        NSString* messageStr = [NSString stringWithFormat:@"私のハイスコア＜%@＞を\n削除します。よろしいですか？",
                                [TamenchanSetting getGameLevelString:viewgamelevel]];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ハイスコアの削除"
                                                        message:messageStr delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
        [alert setTag:ALERT_CLEAR];
        [alert show];
    } else if (headerButton.tag == HEADER_BUTTON_CONTINUE) {
        // 再プレイボタン押下
        HiScoreTabController* tabController = (HiScoreTabController*)self.parentViewController;
        int seguetype = tabController.seguetype;
        
        GameViewController* gameController;
        if(seguetype == SEGUE_TYPE_GAME){
            gameController = (GameViewController*)tabController.presentingViewController;
        } else if(seguetype == SEGUE_TYPE_RESULT){
            gameController = (GameViewController*)tabController.presentingViewController.presentingViewController;
        }
        
        [gameController replayGame];
        [gameController dismissViewControllerAnimated:YES completion:NULL];
    }
}

/*
- (IBAction)clearButton:(id)sender {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    int viewgamelevel = controller.viewgamelevel;
    
    NSArray* array = [TamenchanSetting getGameLevelStringArray];
    NSString* messageStr = [NSString stringWithFormat:@"私のハイスコア＜%@＞を\n削除します。よろしいですか？",[array objectAtIndex:viewgamelevel]];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ハイスコアの削除"
        message:messageStr delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    [alert setTag:ALERT_CLEAR];
    [alert show];
}
*/
 
- (IBAction)registButton:(id)sender {
    //ぐるぐるを出す
    actIndView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [actIndView setCenter:self.view.center];
    [actIndView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:actIndView];
    [actIndView startAnimating];
    
    // 通信処理
    [self performSelectorInBackground:@selector(doInBackground) withObject:nil];
}

- (void)doInBackground {
	@autoreleasepool {
        HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
        int viewgamelevel = controller.viewgamelevel;
    
        NSString* urlStr = [NSString stringWithFormat:@"%@%@?gamelevel=%d",
                            [TamenchanDefine getServerHost],[TamenchanDefine getServerPath],viewgamelevel];
        // Mutableなインスタンスを作成し、インスタンスの内容を変更できるようにする
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
        request.HTTPMethod = @"POST";
        
        NSMutableString* bodyStr = [NSMutableString string];
        
        NSArray* hiScoreArray = [HiScore readHiScore:controller.viewgamelevel];
        for(int i=0;i<[hiScoreArray count];i++){
            HiScore* hiScore = [hiScoreArray objectAtIndex:i];
        
            if(hiScore.registeredId != DEFAULT_REGID){
                [bodyStr appendString:[NSString stringWithFormat:@"id%d=%d&",i,hiScore.registeredId]];
            }
            [bodyStr appendString:[NSString stringWithFormat:@"devid%d=%@&",i,[TamenchanSetting getDeviceId]]];
            [bodyStr appendString:[NSString stringWithFormat:@"name%d=%@&",i,hiScore.name]];
            [bodyStr appendString:[NSString stringWithFormat:@"score%d=%d&",i,hiScore.score]];
            [bodyStr appendString:[NSString stringWithFormat:@"date%d=%@&",i,[hiScore getDateStr]]];
        }
        
        request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"body : %@",bodyStr);
        
        NSURLResponse* response;
        NSError* error;
        NSData* retData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response error:&error];
    
        NSArray* retArray;
        NSError* jsonError;
        if (retData != nil) {
            retArray = [NSJSONSerialization JSONObjectWithData:retData
                            options:NSJSONReadingMutableContainers error:&jsonError];
        } else {
            retArray = [NSArray array];
        }
        
        NSLog(@"error : %@",jsonError);
        NSLog(@"retArray : %@",retArray);
        
        if ([hiScoreArray count] == [retArray count]){
            for(int i=0;i<[hiScoreArray count];i++){
                HiScore* hiScore = [hiScoreArray objectAtIndex:i];
                NSDictionary* hiScoreDic = [retArray objectAtIndex:i];
                hiScore.registeredId = [[hiScoreDic objectForKey:@"id"] intValue];
            }
            [HiScore writeHiScore:viewgamelevel hiScoreArray:hiScoreArray];
        }
        
        // ぐるぐる終了
        [actIndView stopAnimating];
        connecting = NO;
        
        // みんなのランキングへの登録件数を確認
        int rankingNum = 0;
        int topRank = 999;
        for(int i=0;i<[retArray count];i++){
            NSDictionary* hiScoreDic = [retArray objectAtIndex:i];
            int rank = [[hiScoreDic objectForKey:@"rank"] intValue];
            if(rank <= 100){
                rankingNum++;
                if(topRank > rank){
                    topRank = rank;
                }
            }
        }
        
        // ダイアログ表示
        UIAlertView* alert;
        if(rankingNum >= 1){
            alert = [[UIAlertView alloc] initWithTitle:@"登録されました"
                message:[NSString stringWithFormat:@"みんなのハイスコアに %d件 \nランクインしています。\n最高位は %d位 です。",rankingNum,topRank]
                delegate:self cancelButtonTitle:nil otherButtonTitles:@"つぶやく",@"OK",nil];
            [alert setTag:ALERT_REGISTED_TWEET];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@"登録されました"
                message:@"みんなのハイスコアへのランクインはありません。"
                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:ALERT_REGISTED];
        }
        
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_CLEAR:
            if(buttonIndex == 1){
                [self clearHiScore];
            }
            break;
        case ALERT_REGISTED_TWEET:
            NSLog(@"ALERT_REGISTED_TWEET : %d", buttonIndex);
            if(buttonIndex == 0){
                NSLog(@"TWEET");
            }
            break;
        default:
            break;
    }
}

- (void)clearHiScore {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    int viewgamelevel = controller.viewgamelevel;

    [HiScore clearHiScore:viewgamelevel];
//    [TamenchanSetting clearDeviceId];
    
    [self updateHiScoreLabels];
}

- (void)updateHeaderButton {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    int seguetype = controller.seguetype;
    
    if(seguetype == SEGUE_TYPE_MENU){
        headerButton.title = @"クリア";
        headerButton.tag = HEADER_BUTTON_CLEAR;
    } else {
        headerButton.title = @"再プレイ";
        headerButton.tag = HEADER_BUTTON_CONTINUE;
    }
}

- (void)updateMessage {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    int score = controller.score;
    int seguetype = controller.seguetype;
    
    NSString* messageStr = @"";
    if(messageShow == YES){
        if(seguetype == SEGUE_TYPE_RESULT){
            messageStr = @"登録されました";
        } else if (seguetype == SEGUE_TYPE_GAME){
            messageStr = [NSString stringWithFormat:@"得点は%d点でした",score];
        } else if (seguetype == SEGUE_TYPE_MENU){
            messageStr = @"ハイスコアは以下の通りです";
            // continueButton.hidden = YES;
        }
    } else {
        messageStr = @"ハイスコアは以下の通りです";
        // continueButton.hidden = YES;
    }
    
    messageLabel.text = messageStr;
    
}

- (void)updateTitle {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    titleLabel.text = [NSString stringWithFormat:@"私のハイスコア  ＜%@＞",
                       [TamenchanSetting getGameLevelString:controller.viewgamelevel]];
}

- (void)updateHiScoreLabels {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    
    NSArray* hiScoreArray = [HiScore readHiScore:controller.viewgamelevel];
    
    for(int i=0;i<[hiScoreArray count];i++){
        HiScore* hiScore = [hiScoreArray objectAtIndex:i];
        UILabel* nameLabel = [nameLabels objectAtIndex:i];
        UILabel* scoreLabel = [scoreLabels objectAtIndex:i];
        nameLabel.text = hiScore.name;
        scoreLabel.text = [NSString stringWithFormat:@"%d点",hiScore.score];
        
        if(messageShow == YES && controller.rank == (i+1)){
            UILabel* rankLabel = [rankLabels objectAtIndex:i];
            rankLabel.textColor = [UIColor redColor];
            nameLabel.textColor = [UIColor redColor];
            scoreLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)viewDidUnload {
    [self setRankLabels:nil];
    [self setNameLabels:nil];
    [self setScoreLabels:nil];
    [self setMessageLabel:nil];
    [self setTitleLabel:nil];
//     [self setContinueButton:nil];
    [self setHeaderButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateHeaderButton];
    [self updateMessage];
    [self updateTitle];
    [self updateHiScoreLabels];
}

@end
