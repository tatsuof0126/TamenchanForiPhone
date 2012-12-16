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
    
//    NSLog(@"score : %d",score);
    
    rank = OUT_OF_RANK; // 順位を初期化
    
    hiScoreArray = [NSMutableArray arrayWithArray:[HiScore readHiScore:[TamenchanSetting getGameLevel]]];
    
    for(int i=0;i<[hiScoreArray count];i++){
        HiScore* hiScore = [hiScoreArray objectAtIndex:i];
        if(hiScore.score < score){
            rank = i+1;
            HiScore* myHiScore = [[HiScore alloc] init];
            myHiScore.name = [HiScore getLastRegistName];
            myHiScore.score = score;
            myHiScore.date = [[NSDate date] timeIntervalSince1970];
            
            [hiScoreArray insertObject:myHiScore atIndex:i];
            [hiScoreArray removeLastObject];
            
//            NSLog(@"%ld",myHiScore.date);
            
            break;
        }
    }
    
    showScoreLabel.text = [NSString stringWithFormat:@"得点は%d点でした",score];
    showRankLabel.text = [NSString stringWithFormat:@"%d位になりました",rank];
    
    scrollView.contentSize = CGSizeMake(320, 500);
    
    
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
    
    
    NSLog(@"hogehoge");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButton:(id)sender {
    HiScore* hiScore = [hiScoreArray objectAtIndex:rank-1];
    hiScore.name = myNameField.text;
    
    // 保存処理
    [HiScore writeHiScore:[TamenchanSetting getGameLevel] hiScoreArray:hiScoreArray];
    
    [self performSegueWithIdentifier:@"savedsegue" sender:self];
}

- (IBAction)saveandtweetButton:(id)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    
    /*
    戻りたいとこのViewController(その例の場合画面A)にdismissを送る
    と、APIドキュメントの
dismissViewControllerAnimated:completion:
dismissModalViewControllerAnimated:
    の説明のところに書いてある
     */

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( [[segue identifier] isEqualToString:@"savedsegue"] ) {
        HiScoreTabController* controller = [segue destinationViewController];
        controller.seguetype = SEGUE_TYPE_RESULT;
        controller.score = score;
        controller.rank = rank;
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
