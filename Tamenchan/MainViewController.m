//
//  ViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/10/20.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "MainViewController.h"
#import "HiScoreTabController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( [[segue identifier] isEqualToString:@"hiscoresegue"] ) {
        HiScoreTabController* controller = [segue destinationViewController];
        controller.seguetype = SEGUE_TYPE_MENU;
    }
}

@end
