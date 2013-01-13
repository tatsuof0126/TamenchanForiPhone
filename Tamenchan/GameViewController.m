//
//  GameViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "GameViewController.h"
#import "ResultViewController.h"
#import "HiScoreTabController.h"
#import "UIControlAddComparator.h"
#import "TenpaiChecker.h"
#import "TamenchanSetting.h"
#import "TamenchanDefine.h"
#import "TimerView.h"
#import "HiScore.h"

#define CHOICE_HAI_TAG_BASE 100
#define MAX_QUESTION 5
#define RARE_MACHI 7

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize choiceHaiImage;
@synthesize tehaiImage;
@synthesize questionTehai;
@synthesize choice;
@synthesize remainingTime;
@synthesize showTimer;
@synthesize questionTimer;
@synthesize timerBar;
@synthesize questionLabel;
@synthesize scoreLabel;
@synthesize question;
@synthesize score;

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
    
    // 乱数を初期化
    srand([[NSDate date] timeIntervalSinceReferenceDate]);
    
    // 牌のImageViewを正しい順番に並び替え
    choiceHaiImage = [choiceHaiImage sortedArrayUsingSelector:@selector(compare:)];
    tehaiImage = [tehaiImage sortedArrayUsingSelector:@selector(compare:)];
    
    // 選択状態を示す変数のメモリを確保
    choice = (BOOL*)malloc(sizeof(BOOL) * HAI_LENGTH);
    
    // ゲームを初期化して開始
    [self initGame];
    
}

- (void)initGame {
    question = 0;
    score = 0;
    
    [self makeQuestion];
}

- (void)makeQuestion {
    question++;
    remainingTime = 20000;
    
    // 問題を初期化
    questionTehai = [[Tehai alloc] init];
    TenpaiChecker* checker = [[TenpaiChecker alloc] init];
    int targetMachiNum = [TamenchanDefine getTargetMachiNum];
    int haipaiCount = 0;
    
    while (YES) {
        // 配牌
        if([TamenchanSetting getGameLevel] == GAMELEVEL_EASY){
            // 初級の場合は字牌の暗刻を入れる
            [questionTehai haipai:[Tehai getPresetJihai3]];
        } else {
            [questionTehai haipai];
        }
        haipaiCount++;
        
        // 配牌の待ち数を数える
        BOOL* machi = [checker checkMachihai:questionTehai];
        int machiNum = 0;
        for(int i=0;i<HAI_LENGTH;i++){
            if(machi[i] == YES){
                machiNum++;
            }
        }
        
        
//        [questionTehai logTehai];
//        NSLog(@"targetMachiNum : %d  machiNum : %d  haipaiCount : %d", targetMachiNum, machiNum, haipaiCount);
        
        
        // 待ち数が狙い通りまたはレア待ちの場合はそれを問題にする
        if(machiNum == targetMachiNum || machiNum >= RARE_MACHI){
            break;
        }
        // 10回以上繰り返して狙い通りの待ち数が出なかったら待ち数が１以上のものを問題にする
        if(haipaiCount >= 11 && machiNum >= 1){
            break;
        }
    }
    
    // 画面を表示
    [self updateHeader];
    [self initChoiceHai];
    [self showUrahai];
    [timerBar updateTimerView:remainingTime];
    
    [self startShowTimer];
}

- (void)showUrahai {
    for(int i=0;i<13;i++){
        UIImageView* tehaiImageView = [tehaiImage objectAtIndex:i];
        tehaiImageView.image = [UIImage imageNamed:@"bk.gif"];
    }
}

- (void)startShowTimer {
    showTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                    target:self selector:@selector(startQuestion:) userInfo:nil repeats:NO];
}

- (void)startQuestion:(NSTimer*)timer {
    // 手牌を表示
    [self showTehai:questionTehai];
    
    // タイマースタート
    questionTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                        target:self selector:@selector(reduceTimer:) userInfo:nil repeats:YES];
}

- (void)reduceTimer:(NSTimer*)timer {
    remainingTime -= 200;
    
    [timerBar updateTimerView:remainingTime];
    
    if(remainingTime <= 0){
        [questionTimer invalidate];
        
        TenpaiChecker* checker = [[TenpaiChecker alloc] init];
        BOOL* machi = [checker checkMachihai:questionTehai];
        
        NSString* titleStr = @"時間切れ．．．";
        NSString* messageStr = [NSString stringWithFormat:@"正解は「%@」です",[self makeMachiStr:machi]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr
                                delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

- (void)updateHeader {
    questionLabel.text = [NSString stringWithFormat:@"<%@>   問題  %d / %d",
                          [TamenchanSetting getGameLevelString], question, MAX_QUESTION];
    scoreLabel.text = [NSString stringWithFormat:@"得点 : %d",score];
}

- (void)showTehai:(Tehai*)tehai {
    NSArray* haiImageArray = [Tehai getHaiImageArray:[TamenchanSetting getHaiType]];
    NSArray* jihaiImageArray = [Tehai getHaiImageArray:HAI_TYPE_JIHAI];
    
    if([TamenchanSetting getGameLevel] != GAMELEVEL_HARD){
        // 初級・中級
        int num = 0;
        for(int i=1;i<=9;i++) {
            for(int j=0;j<tehai.hai[i];j++){
                UIImageView* tehaiImageView = [tehaiImage objectAtIndex:num];
                tehaiImageView.image = [UIImage imageNamed:[haiImageArray objectAtIndex:i]];
                num++;
            }
        }
    
        int jihaiType = rand() % 7 + 1;
        for(int i=0;i<tehai.hai[0];i++){
            UIImageView* tehaiImageView = [tehaiImage objectAtIndex:num];
            tehaiImageView.image = [UIImage imageNamed:[jihaiImageArray objectAtIndex:jihaiType]];
            num++;
        }
    } else {
        // 上級（理牌せずに表示）
        NSArray* array = [tehai getRamdomHaiArray];
        for(int i=0;i<[array count];i++){
            int number = [[array objectAtIndex:i] intValue];
            UIImageView* tehaiImageView = [tehaiImage objectAtIndex:i];
            tehaiImageView.image = [UIImage imageNamed:[haiImageArray objectAtIndex:number]];
        }
    }
}

- (void)initChoiceHai {
    // 選択状態を初期化
    for(int i=0;i<HAI_LENGTH;i++){
        choice[i] = NO;
    }
    
    NSArray* haiImageArray = [Tehai getHaiImageArray:[TamenchanSetting getHaiType]];
    
    for (int i=0;i<9;i++) {
        UIImageView* choiceHaiImageView = [choiceHaiImage objectAtIndex:i];
        choiceHaiImageView.image = [UIImage imageNamed:[haiImageArray objectAtIndex:i+1]];
        // タッチイベント用
        choiceHaiImageView.userInteractionEnabled = YES;
    }
    
    [self updateChoiceHai];
}

- (void)updateChoiceHai {
    for (int i=0;i<9;i++) {
        UIImageView* choiceHaiImageView = [choiceHaiImage objectAtIndex:i];
        
        if(choice[i+1]==YES){
            choiceHaiImageView.alpha = 1;
        } else {
            choiceHaiImageView.alpha = 0.4;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [[event allTouches] anyObject];
    int tag = touch.view.tag;
    
    if( tag > CHOICE_HAI_TAG_BASE && tag <= CHOICE_HAI_TAG_BASE + 9){
        int touchNum = tag - CHOICE_HAI_TAG_BASE;
        if(choice[touchNum] == YES){
            choice[touchNum] = NO;
        } else {
            choice[touchNum] = YES;
        }
        [self updateChoiceHai];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setChoiceHaiImage:nil];
    [self setTehaiImage:nil];
    [self setQuestionLabel:nil];
    [self setScoreLabel:nil];
    [self setShowTimer:nil];
    [self setQuestionTimer:nil];
    [self setTimerBar:nil];
    [super viewDidUnload];
}

- (void)replayGame {
    // ゲームを初期化して開始
    [self initGame];
}

- (IBAction)backButton:(id)sender {
    [showTimer invalidate];
    [questionTimer invalidate];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)judgeButton:(id)sender {
    if([showTimer isValid]){
        return;
    }
    
    [questionTimer invalidate];
    
    TenpaiChecker* checker = [[TenpaiChecker alloc] init];
    BOOL* machi = [checker checkMachihai:questionTehai];
    int machiNum = 0;
    
    bool judge = YES;
    for(int i=1;i<=9;i++){
        if(machi[i]!=choice[i]){
            judge = NO;
        }
        
        if(machi[i]==YES){
            machiNum++;
        }
    }
    
    NSString* titleStr;
    NSString* messageStr;
    
    if(judge == YES){
        int addScore = remainingTime / 1000 + 1;
        int bonus = [TamenchanDefine getBonusScore:machiNum];
        score += addScore + bonus;
        
        titleStr = @"ためんちゃん！";
        if( bonus == 0 ){
            messageStr = [NSString stringWithFormat:@"正解です！　%d点獲得", addScore];
        } else {
            messageStr = [NSString stringWithFormat:@"正解です！　%d点獲得\nためんちゃんボーナス　+%d点", addScore,bonus];
        }
    } else {
        titleStr = @"だめじゃん．．．";
        messageStr = [NSString stringWithFormat:@"正しくは「%@」です\nあなたの回答「%@」"
                      ,[self makeMachiStr:machi],[self makeMachiStr:choice]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr
        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(question == MAX_QUESTION){
        
        NSArray* hiScoreArray = [NSMutableArray arrayWithArray:[HiScore readHiScore:[TamenchanSetting getGameLevel]]];
        BOOL rankin = NO;
        
        for(int i=0;i<[hiScoreArray count];i++){
            HiScore* hiScore = [hiScoreArray objectAtIndex:i];
            if(hiScore.score < score){
                rankin = YES;
                break;
            }
        }
        
        if(rankin == YES){
            [self performSegueWithIdentifier:@"resultsegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"gamesegue" sender:self];
        }
        
    } else {
        [self makeQuestion];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( [[segue identifier] isEqualToString:@"resultsegue"] ) {
        ResultViewController* controller = [segue destinationViewController];
        controller.score = score;
    } else if ( [[segue identifier] isEqualToString:@"gamesegue"] ) {
        HiScoreTabController* controller = [segue destinationViewController];
        controller.seguetype = SEGUE_TYPE_GAME;
        controller.score = score;
        controller.rank = OUT_OF_RANK;
    }
}

- (NSString*)makeMachiStr:(BOOL*)machi {
    NSMutableString* machiStr = [NSMutableString string];
    
    for(int i=0;i<HAI_LENGTH;i++){
        if(machi[i]==YES){
            [machiStr appendString:[NSString stringWithFormat:@",%d",i]];
        }
    }
    
    if([machiStr isEqualToString:@""]){
        return @"待ちなし";
    } else {
        [machiStr appendString:@"待ち"];
        return [machiStr substringFromIndex:1];
    }
}

@end
