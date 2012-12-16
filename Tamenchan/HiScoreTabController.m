//
//  HiScoreTabController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/15.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "HiScoreTabController.h"
#import "TamenchanSetting.h"

@interface HiScoreTabController ()

@end

@implementation HiScoreTabController

@synthesize seguetype;
@synthesize score;
@synthesize rank;
@synthesize viewgamelevel;

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
    
    // 初期表示するゲームレベルを取得
    viewgamelevel = [TamenchanSetting getGameLevel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segueBack {
    if (seguetype == SEGUE_TYPE_MENU){
        [self dismissModalViewControllerAnimated:YES];
    } else if(seguetype == SEGUE_TYPE_GAME){
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } else if(seguetype == SEGUE_TYPE_RESULT){
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
