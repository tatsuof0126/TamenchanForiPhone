//
//  TenpaiChecker.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2012/11/25.
//  Copyright (c) 2012年 Tatsuo Fujiwara. All rights reserved.
//

#import "TenpaiChecker.h"
#import "Tehai.h"

@implementation TenpaiChecker

static NSArray* kotsuTargetArray;

- (BOOL*)checkMachihai:(Tehai*)targetTehai {
    BOOL* machi = (BOOL*)malloc(sizeof(BOOL) * HAI_LENGTH);
    machi[0] = false;
    
    // 受け取った１３枚に１〜９までの牌を１つずつ足して、上がりになるかをチェック
    for (int i=1; i<=9; i++) {
        Tehai* checkTargetTehai = [targetTehai copyTehai];
        checkTargetTehai.hai[i]++;
        
//        NSLog(@"チェックターゲット");
//        [checkTargetTehai logTehai];
        
        machi[i] = [self isAgari:checkTargetTehai];
    }
    
    return machi;
}

- (BOOL)isAgari:(Tehai*)checkTargetTehai {
    // まずは七対子型での上がりをチェック
    if([self checkChitoitsu:checkTargetTehai] == true){
        return true;
    }
    
    // 以降は面子型での上がりをチェックする
    // まず刻子になりうる牌を調べる
    NSMutableArray* kotsuArray = [NSMutableArray array];
    for(int i=0;i<HAI_LENGTH;i++){
        if(checkTargetTehai.hai[i] >= 3){
            [kotsuArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    // 刻子を刻子として見るか、順子・雀頭として見るかを切り替えて、それぞれチェックする
    // まず刻子の数に応じた切り替えパターン表を取得
    NSArray* kotsuTargetArray = [TenpaiChecker getKotsuTargetArray:[kotsuArray count]];
    
    for(int i=0;i<[kotsuTargetArray count];i++){
        Tehai* checkTargetTehaiCopy = [checkTargetTehai copyTehai];
        
        // 切り替えパターン表を元に刻子として見る牌を３枚はずす
        NSArray* kotsuTarget = [kotsuTargetArray objectAtIndex:i];
        for (int j=0;j<[kotsuTarget count];j++) {
            int target = [[kotsuTarget objectAtIndex:j] intValue];
            int targetHai = [[kotsuArray objectAtIndex:target] intValue];
            checkTargetTehaiCopy.hai[targetHai]-=3;
        }
        
//        [checkTargetTehaiCopy logTehai]; //LOG
        
        // その上で順子・雀頭の形なっているかをチェック、なっていれば上がり
        if([self checkToitsuShuntsu:checkTargetTehaiCopy] == true){
            return true;
        }
    }
    
    return false;
}

- (BOOL)checkChitoitsu:(Tehai*)checkTargetTehai {
    int toitsuNum = 0;
    
    for(int i=0;i<HAI_LENGTH;i++){
        if(checkTargetTehai.hai[i] == 2){
            toitsuNum++;
        }
    }
    
    if(toitsuNum == 7){
        return true;
    }
    
    return false;
}

- (BOOL)checkToitsuShuntsu:(Tehai*)checkTargetTehai {
    // 雀頭になりうる牌を調べ、その牌を雀頭にしたとき残りの牌が順子になるかチェック
    for(int i=0;i<HAI_LENGTH;i++){
        if(checkTargetTehai.hai[i] >= 2){
            Tehai* checkTargetTehaiCopy = [checkTargetTehai copyTehai];
            checkTargetTehaiCopy.hai[i]-=2;
            
            if([self checkShuntsu:checkTargetTehaiCopy] == true){
                return true;
            }
        }
    }
    
    return false;
}

- (BOOL)checkShuntsu:(Tehai*)checkTargetTehai {
    for(int i=1;i<=7;i++){
        while(checkTargetTehai.hai[i] >= 1
              && checkTargetTehai.hai[i+1] >= 1
              && checkTargetTehai.hai[i+2] >= 1){
            checkTargetTehai.hai[i]--;
            checkTargetTehai.hai[i+1]--;
            checkTargetTehai.hai[i+2]--;
        }
    }
    
    for(int i=0;i<HAI_LENGTH;i++){
        if(checkTargetTehai.hai[i]>=1){
            return false;
        }
    }
    
    return true;
}

+ (NSArray*)getKotsuTargetArray:(int)kotsuNum {
    if( kotsuTargetArray == NULL ){
        NSNumber* n0 = [NSNumber numberWithInt:0];
        NSNumber* n1 = [NSNumber numberWithInt:1];
        NSNumber* n2 = [NSNumber numberWithInt:2];
        NSNumber* n3 = [NSNumber numberWithInt:3];
        
        // 刻子が０個のときはすべてを順子・雀頭としてみるパターンのみ
        NSArray* array4kotsu0 = [NSArray arrayWithObjects:[NSArray array], nil];
        
        // 刻子が１個のときは、刻子なし・刻子１個の合計２パターン
        NSArray* array4kotsu1 = [NSArray arrayWithObjects:
                                 [NSArray array],
                                 [NSArray arrayWithObjects:n0, nil],
                                 nil];
        
        // 刻子が２個のときは、刻子なし・刻子１個（Ａ、Ｂ）・刻子２個（Ａ＆Ｂ）の合計４パターンパターン
        NSArray* array4kotsu2 = [NSArray arrayWithObjects:
                                 [NSArray array],
                                 [NSArray arrayWithObjects:n0, nil],
                                 [NSArray arrayWithObjects:n1, nil],
                                 [NSArray arrayWithObjects:n0, n1, nil],nil];
        
        // 刻子が３個のときは、刻子なし・刻子１個（Ａ、Ｂ、Ｃ）・刻子２個（Ａ＆Ｂ、Ａ＆Ｃ、Ｂ＆Ｃ）
        // 刻子３個（Ａ＆Ｂ＆Ｃ）の合計８パターン
        NSArray* array4kotsu3 = [NSArray arrayWithObjects:
                                 [NSArray array],
                                 [NSArray arrayWithObjects:n0, nil],
                                 [NSArray arrayWithObjects:n1, nil],
                                 [NSArray arrayWithObjects:n2, nil],
                                 [NSArray arrayWithObjects:n0, n1, nil],
                                 [NSArray arrayWithObjects:n0, n2, nil],
                                 [NSArray arrayWithObjects:n1, n2, nil],
                                 [NSArray arrayWithObjects:n0, n1, n2, nil],nil];
        
        // 刻子が４個のときは、刻子なし・刻子１個（Ａ、Ｂ、Ｃ、Ｄ）・刻子２個（Ａ＆Ｂ、Ａ＆Ｃ、Ａ＆Ｄ、Ｂ＆Ｃ、Ｂ＆Ｄ、Ｃ＆Ｄ）
        // 刻子３個（Ａ＆Ｂ＆Ｃ、Ａ＆Ｂ＆Ｄ、Ａ＆Ｃ＆Ｄ、Ｂ＆Ｃ＆Ｄ）・刻子４個（Ａ＆Ｂ＆Ｃ＆Ｄ）の合計１６パターン
        NSArray* array4kotsu4 = [NSArray arrayWithObjects:
                                 [NSArray array],
                                 [NSArray arrayWithObjects:n0, nil],
                                 [NSArray arrayWithObjects:n1, nil],
                                 [NSArray arrayWithObjects:n2, nil],
                                 [NSArray arrayWithObjects:n3, nil],
                                 [NSArray arrayWithObjects:n0, n1, nil],
                                 [NSArray arrayWithObjects:n0, n2, nil],
                                 [NSArray arrayWithObjects:n0, n3, nil],
                                 [NSArray arrayWithObjects:n1, n2, nil],
                                 [NSArray arrayWithObjects:n1, n3, nil],
                                 [NSArray arrayWithObjects:n2, n3, nil],
                                 [NSArray arrayWithObjects:n0, n1, n2, nil],
                                 [NSArray arrayWithObjects:n0, n1, n3, nil],
                                 [NSArray arrayWithObjects:n0, n2, n3, nil],
                                 [NSArray arrayWithObjects:n1, n2, n3, nil],
                                 [NSArray arrayWithObjects:n0, n1, n2, n3, nil],nil];
        
        kotsuTargetArray = [NSArray arrayWithObjects:array4kotsu0, array4kotsu1, array4kotsu2, array4kotsu3, array4kotsu4, nil];
    }
    
    return [kotsuTargetArray objectAtIndex:kotsuNum];
}

@end
