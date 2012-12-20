//
//  SelectConfigViewController.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/01.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "SelectConfigViewController.h"
#import "TamenchanSetting.h"
#import "HiScoreTabController.h"

@interface SelectConfigViewController ()

@end

@implementation SelectConfigViewController

@synthesize selecttype;
@synthesize selectArray;

@synthesize titleItem;
@synthesize selectTableView;

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
    
    [self setTitleString];
    [self makeSelectArray];
}

- (void)setTitleString {
    NSString* str = @"";
    if (selecttype == TYPE_LEVEL || selecttype == TYPE_VIEW_LEVEL){
        str = @"ゲームレベル";
    } else if (selecttype == TYPE_HAITYPE) {
        str = @"牌の種類";
    }
    
    titleItem.title = str;
}

- (void)makeSelectArray {
    if (selecttype == TYPE_LEVEL || selecttype == TYPE_VIEW_LEVEL){
        selectArray = [TamenchanSetting getGameLevelStringArray];
    } else if (selecttype == TYPE_HAITYPE) {
        selectArray = [TamenchanSetting getHaiTypeStringArray];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return selectArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectInputCell"];
    cell.textLabel.text = [selectArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"Selected %d-%d",indexPath.section, indexPath.row);
    
    // レベル選択で上級を選択した場合は、選択させてよいかをチェックする
    if ((selecttype == TYPE_LEVEL || selecttype == TYPE_VIEW_LEVEL) &&
        indexPath.row == 2 && [TamenchanSetting canSelectHard] == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
            message:@"上級は、中級で50点以上のスコアを出すと選択できるようになります。"
            delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (selecttype == TYPE_LEVEL){
        [TamenchanSetting setGameLevel:indexPath.row];
    } else if (selecttype == TYPE_HAITYPE) {
        [TamenchanSetting setHaiType:indexPath.row];
    } else if (selecttype == TYPE_VIEW_LEVEL) {
        HiScoreTabController* controller = (HiScoreTabController*)self.presentingViewController;
        controller.viewgamelevel = indexPath.row;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setSelectTableView:nil];
    [self setTitleItem:nil];
    [super viewDidUnload];
}

@end
