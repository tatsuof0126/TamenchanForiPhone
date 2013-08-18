//
//  AppDelegate.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/10/20.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) InAppPurchaseManager* purchaseManager;

+ (void)adjustForiPhone5:(UIView*)view;

- (InAppPurchaseManager*)getInAppPurchaseManager;

@end
