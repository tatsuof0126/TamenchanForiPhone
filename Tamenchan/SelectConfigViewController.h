//
//  SelectConfigViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/01.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYPE_LEVEL      1
#define TYPE_HAITYPE    2
#define TYPE_VIEW_LEVEL 3

@interface SelectConfigViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;

@property (weak, nonatomic) IBOutlet UITableView *selectTableView;

@property int selecttype;

@property NSArray* selectArray;

- (IBAction)backButton:(id)sender;

@end
