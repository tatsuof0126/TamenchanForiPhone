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
#import "TamenchanSetting.h"
#import "HiScore.h"

#define ALERT_CLEAR 1

@interface MyHiscoreViewController ()

@end

@implementation MyHiscoreViewController

@synthesize messageLabel;
@synthesize titleLabel;
@synthesize nameLabels;
@synthesize scoreLabels;
@synthesize messageShow;

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
    
    // nameLabels,scoreLabelsを正しい順番に並び替え
    nameLabels = [nameLabels sortedArrayUsingSelector:@selector(compare:)];
    scoreLabels = [scoreLabels sortedArrayUsingSelector:@selector(compare:)];
    
    [self updateMessage];
    [self updateTitle];
    [self updateHiScoreLabels];

    
//    NSLog(@"%d, %d, %d",seguetype,score,rank);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    [controller segueBack];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    messageShow = NO;
    
    NSString* segueStr = [segue identifier];    
    SelectConfigViewController *viewController = [segue destinationViewController];
    if ([segueStr isEqualToString:@"level"] == true) {
        viewController.selecttype = TYPE_VIEW_LEVEL;
    }
}


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

- (IBAction)registButton:(id)sender {
    
    
    NSLog(@"registButton"); // 仮実装
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_CLEAR:
            if(buttonIndex == 1){
                [self clearHiScore];
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
    
    [self updateHiScoreLabels];
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
        }
    } else {
        messageStr = @"ハイスコアは以下の通りです";
    }
    
    messageLabel.text = messageStr;
    
}

- (void)updateTitle {
    HiScoreTabController* controller = (HiScoreTabController*)self.parentViewController;
    int viewgamelevel = controller.viewgamelevel;
    
    NSArray* array = [TamenchanSetting getGameLevelStringArray];
    titleLabel.text = [NSString stringWithFormat:@"私のハイスコア  ＜%@＞",[array objectAtIndex:viewgamelevel]];
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
    }
}

- (void)viewDidUnload {
    [self setNameLabels:nil];
    [self setScoreLabels:nil];
    [self setMessageLabel:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateMessage];
    [self updateTitle];
    [self updateHiScoreLabels];
}

@end
