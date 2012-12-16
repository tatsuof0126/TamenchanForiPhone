//
//  TimerView.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/12/09.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "TimerView.h"

@implementation TimerView

@synthesize remainingTime;

- (id)initWithFrame:(CGRect)frame
{
    remainingTime = 20000;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int barlength = remainingTime * 280 / 20000;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 30.0);
    
    if( barlength >= 140 ){
        CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
        CGContextMoveToPoint(context, 2, 20);
        CGContextAddLineToPoint(context, 2+70, 20);
        CGContextStrokePath(context);

        CGContextSetStrokeColorWithColor(context, UIColor.yellowColor.CGColor);
        CGContextMoveToPoint(context, 2+70, 20);
        CGContextAddLineToPoint(context, 2+140, 20);
        CGContextStrokePath(context);

        CGContextSetStrokeColorWithColor(context, UIColor.blueColor.CGColor);
        CGContextMoveToPoint(context, 2+140, 20);
        CGContextAddLineToPoint(context, 2+barlength, 20);
        CGContextStrokePath(context);
    } else if( barlength >= 70 ){
        CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
        CGContextMoveToPoint(context, 2, 20);
        CGContextAddLineToPoint(context, 2+70, 20);
        CGContextStrokePath(context);

        CGContextSetStrokeColorWithColor(context, UIColor.yellowColor.CGColor);
        CGContextMoveToPoint(context, 2+70, 20);
        CGContextAddLineToPoint(context, 2+barlength, 20);
        CGContextStrokePath(context);
    } else {
        CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
        CGContextMoveToPoint(context, 2, 20);
        CGContextAddLineToPoint(context, 2+barlength, 20);
        CGContextStrokePath(context);
    }
    
    // 左端の黒線
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, UIColor.blackColor.CGColor);

    CGContextMoveToPoint(context, 1, 0);
    CGContextAddLineToPoint(context, 1, 40);
    CGContextStrokePath(context);
}

- (void)updateTimerView:(int)time {
    remainingTime = time;
    
    // 再描画
    [self setNeedsDisplay];
}

@end
