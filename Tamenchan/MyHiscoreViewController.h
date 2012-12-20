//
//  MyHiscoreViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/24.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHiscoreViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIActivityIndicatorView* actIndView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *headerButton;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *rankLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *scoreLabels;

@property BOOL connecting;
@property BOOL messageShow;

// @property (weak, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)backButton:(id)sender;
- (IBAction)headerButton:(id)sender;
// - (IBAction)clearButton:(id)sender;
// - (IBAction)continueButton:(id)sender;
- (IBAction)registButton:(id)sender;

@end
