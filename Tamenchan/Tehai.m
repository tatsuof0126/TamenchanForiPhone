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

- (void)toString {
    NSMutableString* str = [NSMutableString string];
    for(int i=0;i<HAI_LENGTH;i++){
        for(int j=0;j<hai[i];j++){
            [str appendString:[NSString stringWithFormat:@"%d",i]];
//          NSLog(@"%d : %d",i,hai[i]);
        }
    }
    
    NSLog(@"%@",str);
}

@end
