//
//  Tehai.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/25.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "Tehai.h"

@implementation Tehai

@synthesize hai;
@synthesize used;

static NSArray* haiImageArray;

- (Tehai*)init {
    Tehai* tehai = [super init];
    tehai.hai = (int*)malloc(sizeof(int) * HAI_LENGTH);
    tehai.used = (BOOL*)malloc(sizeof(BOOL) * HAI_LENGTH * 4);
    return tehai;
}

- (void)haipai {
    [self haipai:NULL];
}

- (void)haipai:(int*)presethai {    
    [self shihai];

    int num = 0;
    
    if(presethai != NULL){
        for(int i=0;i<HAI_LENGTH;i++){
            hai[i] = presethai[i];
            num += presethai[i];
            for(int j=0;j<presethai[i];j++){
                used[i*4+j] = true;
            }
        }
    }
    
    for(int i=num;i<TEHAI_LENGTH;i++){
        while (TRUE) {
            int tsumo = rand()%36+4;
            if(used[tsumo] == false){
                hai[(int)(tsumo/4)]++;
                used[tsumo] = true;
                break;
            }
        }
    }
    
}

- (void)shihai {
    srand([[NSDate date] timeIntervalSinceReferenceDate]);
    
    for(int i=0;i<HAI_LENGTH;i++){
        hai[i] = 0;
    }
    for(int i=0;i<HAI_LENGTH*4;i++){
        used[i] = FALSE;
    }
}

- (void)putTehai:(int*)sourcehai {
    for (int i=0;i<HAI_LENGTH;i++) {
        hai[i] = sourcehai[i];
    }
}

- (Tehai*)copyTehai {
    Tehai* tehai = [[Tehai alloc] init];
    [tehai putTehai:hai];
    return tehai;
}

- (void)logTehai {
    NSMutableString* str = [NSMutableString string];
    for(int i=0;i<HAI_LENGTH;i++){
        for(int j=0;j<hai[i];j++){
            [str appendString:[NSString stringWithFormat:@"%d",i]];
//          NSLog(@"%d : %d",i,hai[i]);
        }
    }
    
    NSLog(@"%@",str);
}

+ (NSArray*)getHaiImageArray:(int)haitype {
    
    if( haiImageArray == NULL ){
        haiImageArray = [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@"",@"m1.gif",@"m2.gif",@"m3.gif",@"m4.gif",@"m5.gif",@"m6.gif",@"m7.gif",@"m8.gif",@"m9.gif",nil],
                         [NSArray arrayWithObjects:@"",@"p1.gif",@"p2.gif",@"p3.gif",@"p4.gif",@"p5.gif",@"p6.gif",@"p7.gif",@"p8.gif",@"p9.gif",nil],
                         [NSArray arrayWithObjects:@"",@"s1.gif",@"s2.gif",@"s3.gif",@"s4.gif",@"s5.gif",@"s6.gif",@"s7.gif",@"s8.gif",@"s9.gif",nil],
                         [NSArray arrayWithObjects:@"",@"j1.gif",@"j2.gif",@"j3.gif",@"j4.gif",@"j5.gif",@"j6.gif",@"j7.gif",nil],nil];
    }
    
    return [haiImageArray objectAtIndex:haitype];
}

@end
