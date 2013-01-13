//
//  ResultViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/11.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "ResultViewController.h"
#import "HiscoreTabController.h"
#import "UIControlAddComparator.h"
#import "TamenchanSetting.h"
#import "HiScore.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize score;
@synthesize rank;
@synthesize myNameField;
@synthesize scrollView;
@synthesize showScoreLabel;
@synthesize showRankLabel;
@synthesize tweeted;

@synthesize hiScoreArray;
@synthesize nameLabels;
@synthesize scoreLabels;

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
    
    // nameLabels,scoreLabelsを正しい順番に並び替え
    nameLabels = [nameLabels sortedArrayUsingSelector:@selector(compare:)];
    scoreLabels = [scoreLabels sortedArrayUsingSelector:@selector(compare:)];
    
    // 順位を初期化
    rank = OUT_OF_RANK;
    tweeted = NO;
    
    int gamelevel = [TamenchanSetting getGameLevel];
    hiScoreArray = [NSMutableArray arrayWithArray:[HiScore readHiScore:gamelevel]];
    
    // 何位かをチェック
    for(int i=0;i<[hiScoreArray count];i++){
        HiScore* hiScore = [hiScoreArray objectAtIndex:i];
        if(hiScore.score < score){
            rank = i+1;
            HiScore* myHiScore = [[HiScore alloc] init];
            myHiScore.name = [HiScore getLastRegistName];
            myHiScore.score = score;
            myHiScore.date = [NSDate date];
            
            [hiScoreArray insertObject:myHiScore atIndex:i];
            [hiScoreArray removeLastObject];
            break;
        }
    }
    
    // 得点と順位を表示
    showScoreLabel.text = [NSString stringWithFormat:@"得点は%d点でした",score];
    showRankLabel.text = [NSString stringWithFormat:@"%d位になりました",rank];
    
    // ハイスコアを表示
    for(int i=0;i<[hiScoreArray count];i++){
        HiScore* hiScore = [hiScoreArray objectAtIndex:i];
        UILabel* nameLabel = [nameLabels objectAtIndex:i];
        UILabel* scoreLabel = [scoreLabels objectAtIndex:i];
        nameLabel.text = hiScore.name;
        scoreLabel.text = [NSString stringWithFormat:@"%d点",hiScore.score];
        
        if(i == (rank-1)){
            myNameField = [[UITextField alloc] initWithFrame:CGRectMake(70, 145+i*30, 170, 30)];
            myNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            myNameField.borderStyle = UITextBorderStyleRoundedRect;
            myNameField.returnKeyType = UIReturnKeyDone;
            myNameField.text = hiScore.name;
            myNameField.delegate = self;
            
            [scrollView addSubview:myNameField];
            nameLabel.hidden = YES;
        }
    }
    scrollView.contentSize = CGSizeMake(320, 500);
    
    // 初めて中級で50点を超えた場合は上級を選択できるようにする
    if(gamelevel == GAMELEVEL_NORMAL && score >= 50 && [TamenchanSetting canSelectHard] == NO){
        [TamenchanSetting setSelectHard:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"おめでとうございます"
            message:@"中級で50点以上獲得したため、上級が選択できるようになりました。\nぜひチャレンジしてください。"
            delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButton:(id)sender {
    if ([myNameField.text isEqualToString:@""] == YES) {
        return;
    }
    
    [self save];
    
    [self performSegueWithIdentifier:@"savedsegue" sender:self];
}

- (IBAction)saveandtweetButton:(id)sender {
    if ([myNameField.text isEqualToString:@""] == YES) {
        return;
    }
    
    NSString* gameLevelString = [TamenchanSetting getGameLevelString];
    
    TWTweetComposeViewController* controller = [[TWTweetComposeViewController alloc] init];
    [controller setInitialText:[NSString stringWithFormat:@"%@さんの得点<%@>は%d点でした。 #ためんちゃん http://bit.ly/UIlcpn ",myNameField.text,gameLevelString,score]];
    TWTweetComposeViewControllerCompletionHandler completionHandler
            = ^(TWTweetComposeViewControllerResult result) {
        switch (result) {
            case TWTweetComposeViewControllerResultDone:
                tweeted = YES;
                [self save];
                break;
            case TWTweetComposeViewControllerResultCancelled:
                break;
            default:
                break;
        }
                
        [self dismissViewControllerAnimated:YES completion:^{
            if( tweeted == YES ){
                [self performSegueWithIdentifier:@"savedsegue" sender:self];
            }
        }];
        
//        [self dismissModalViewControllerAnimated:YES];
 };
    [controller setCompletionHandler:completionHandler];
    [self presentModalViewController:controller animated:YES];
}

- (void)save {
    HiScore* hiScore = [hiScoreArray objectAtIndex:rank-1];
    hiScore.name = myNameField.text;
    
    // 保存処理
    [HiScore writeHiScore:[TamenchanSetting getGameLevel] hiScoreArray:hiScoreArray];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( [[segue identifier] isEqualToString:@"savedsegue"] ) {
        HiScoreTabController* controller = [segue destinationViewController];
        controller.seguetype = SEGUE_TYPE_RESULT;
        controller.score = score;
        controller.rank = rank;
        controller.tweeted = tweeted;
    }
}


- (void)viewDidUnload {
    [self setNameLabels:nil];
    [self setScoreLabels:nil];
    [self setShowScoreLabel:nil];
    [self setShowRankLabel:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    [scrollView setContentOffset:CGPointMake(0.0f, 140.0f) animated:YES];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    [myNameField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string {
	NSMutableString* text = [myNameField.text mutableCopy];
	[text replaceCharactersInRange:range withString:string];
	return [text length] <= MAX_LENGTH_NAME;
}

@end
