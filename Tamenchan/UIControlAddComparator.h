//
//  UIControlAddComparator.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/25.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (sorted)

- (NSComparisonResult)compare:(UIView*)target;

@end
