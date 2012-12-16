//
//  ResultViewController.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/11.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OUT_OF_RANK 0

@interface ResultViewController : UIViewController <UITextFieldDelegate>

@property int score;
@property int rank;
@property NSMutableArray* hiScoreArray;
@property UITextField* myNameField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *showScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *showRankLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *scoreLabels;

- (IBAction)saveButton:(id)sender;
- (IBAction)saveandtweetButton:(id)sender;

@end
