//
//  GameViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "GameViewController.h"
#import "UIControlAddComparator.h"
#import "Tehai.h"
#import "TenpaiChecker.h"

#define CHOICE_HAI_TAG_BASE 100

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize choiceHaiImage;
@synthesize tehaiImage;
@synthesize choice;

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
    
    choiceHaiImage = [choiceHaiImage sortedArrayUsingSelector:@selector(compare:)];
    tehaiImage = [tehaiImage sortedArrayUsingSelector:@selector(compare:)];
    
    choice = (BOOL*)malloc(sizeof(BOOL) * HAI_LENGTH);
    for(int i=0;i<HAI_LENGTH;i++){
        choice[i] = false;
    }
    
    Tehai* tehai = [[Tehai alloc] init];
    [tehai haipai];
    
    TenpaiChecker* checker = [[TenpaiChecker alloc] init];
    BOOL* machi = [checker checkMachihai:tehai];
    
    
    [tehai logTehai];
    for(int i=0;i<HAI_LENGTH;i++){
        if(machi[i] == true){
            NSLog(@"待ち牌：%d",i);
        }
    }
    
    
    [self initChoiceHai];
    
    [self viewTehai:tehai];
    
    
}

- (void)initChoiceHai {
    NSArray* haiImageArray = [Tehai getHaiImageArray:HAI_TYPE_SOUZU];

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
        
        if(choice[i+1]==true){
            choiceHaiImageView.alpha = 1;
        } else {
            choiceHaiImageView.alpha = 0.4;
        }
    }
}

- (void)viewTehai:(Tehai*)tehai {
    NSArray* haiImageArray = [Tehai getHaiImageArray:HAI_TYPE_MANZU];
    NSArray* jihaiImageArray = [Tehai getHaiImageArray:HAI_TYPE_JIHAI];
    
    int num = 0;
    for (int i=1;i<=9;i++) {
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [[event allTouches] anyObject];
    int tag = touch.view.tag;
    
    if( tag > CHOICE_HAI_TAG_BASE && tag <= CHOICE_HAI_TAG_BASE + 9){
        int touchNum = tag - CHOICE_HAI_TAG_BASE;
        if(choice[touchNum] == true){
            choice[touchNum] = false;
        } else {
            choice[touchNum] = true;
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
    [super viewDidUnload];
}
- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)judgeButton:(id)sender {
    
    NSLog(@"judge button");
    
    
}
@end
