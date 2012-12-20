//
//  ConfigViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "ConfigViewController.h"
#import "SelectConfigViewController.h"
#import "TamenchanSetting.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

@synthesize gamelevelLabel;
@synthesize haitypeLabel;
@synthesize haitypeImage;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)configTwitter:(id)sender {
    NSLog(@"configTwitter");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString* segueStr = [segue identifier];
    
    SelectConfigViewController *viewController = [segue destinationViewController];
    if ([segueStr isEqualToString:@"level"] == YES) {
        viewController.selecttype = TYPE_LEVEL;
    } else if ([segueStr isEqualToString:@"haitype"] == YES) {
        viewController.selecttype = TYPE_HAITYPE;
    }
}

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    int haitype = [TamenchanSetting getHaiType];
    
    gamelevelLabel.text = [TamenchanSetting getGameLevelString];
    haitypeLabel.text = [[TamenchanSetting getHaiTypeStringArray] objectAtIndex:haitype];
    NSString* imageString = [[TamenchanSetting getHaiTypeImageStringArray] objectAtIndex:haitype];
    
    haitypeImage.image = [UIImage imageNamed:imageString];
}

- (void)viewDidUnload {
    [self setGamelevelLabel:nil];
    [self setHaitypeLabel:nil];
    [self setHaitypeImage:nil];
    [super viewDidUnload];
}
@end
