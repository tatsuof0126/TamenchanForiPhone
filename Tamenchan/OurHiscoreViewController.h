//
//  OurHiscoreViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OurHiscoreViewController : UIViewController

@property BOOL connecting;

@property (strong, nonatomic) UIActivityIndicatorView* actIndView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)reloadButton:(id)sender;

- (IBAction)backButton:(id)sender;

@end
