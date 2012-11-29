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

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize choiceHaiImage;
@synthesize tehaiImage;

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
    
    Tehai* tehai = [[Tehai alloc] init];
    
//    [tehai initialhai];
    [tehai haipai];
//    [tehai toString];

    Tehai* tehai2 = [tehai copyTehai];
//    [tehai2 toString];
    [tehai2 haipai];
    [tehai2 toString];
    
    TenpaiChecker* checker = [[TenpaiChecker alloc] init];
    BOOL* machi = [checker checkMachihai:tehai2];
    
    [tehai2 toString];
    for(int i=0;i<HAI_LENGTH;i++){
        if(machi[i] == true){
            NSLog(@"待ち牌：%d",i);
        }
    }
    
    
    UIImageView* imageView = [choiceHaiImage objectAtIndex:0];
    imageView.image = [UIImage imageNamed:@"s1.gif"];

    UIImageView* imageView2 = [choiceHaiImage objectAtIndex:5];
    imageView2.image = [UIImage imageNamed:@"s6.gif"];
    
    UIImageView* imageView3 = [tehaiImage objectAtIndex:5];
    imageView3.image = [UIImage imageNamed:@"p4.gif"];

    UIImageView* imageView4 = [tehaiImage objectAtIndex:12];
    imageView4.image = [UIImage imageNamed:@"j6.gif"];
    
    
    
    
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
