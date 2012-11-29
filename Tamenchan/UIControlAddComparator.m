//
//  UIControlAddComparator.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/25.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "UIControlAddComparator.h"

@implementation UIView (sorted)

- (NSComparisonResult)compare:(UIView*)target
{
    return self.tag == target.tag ? NSOrderedSame :
        (self.tag < target.tag ? NSOrderedAscending : NSOrderedDescending);
}

@end

