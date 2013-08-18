//
//  InAppPurchaseManager.m
//  Tamenchan
//
//  Created by 藤原 達郎 on 2013/03/11.
//  Copyright (c) 2013年 Tatsuo Fujiwara. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "TamenchanSetting.h"

@implementation InAppPurchaseManager

@synthesize source;

- (InAppPurchaseManager*)init {
    InAppPurchaseManager* manager = [super init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return manager;
}

- (BOOL)canMakePurchases {
    if([SKPaymentQueue canMakePayments]){
        return YES;
    } else {
        return NO;
    }
}

- (void)requestProductData:(NSString*)pID {
//    NSLog(@"−−− requestProductData −−−");
    
    myProductRequest= [[SKProductsRequest alloc]
                       initWithProductIdentifiers: [NSSet setWithObject: pID]];
    myProductRequest.delegate = self;
    [myProductRequest start];
}

- (void)productsRequest:(SKProductsRequest*)request
     didReceiveResponse:(SKProductsResponse*)response {
//    NSLog(@"−−− productsRequest −−−");
    
    // ぐるぐる終了
    [source endConnecting];
    
    if (response == nil) {
        return;
    }
    
    // 確認できなかったidentifierをログに記録
//    for (NSString *identifier in response.invalidProductIdentifiers) {
//        NSLog(@"invalid product identifier: %@", identifier);
//    }
    
    for (SKProduct *product in response.products ) {
//        NSLog(@"valid product identifier: %@", product.productIdentifier);
//        NSLog(@"%@",[product productIdentifier]);
//        NSLog(@"%@",[product localizedTitle]);
//        NSLog(@"%@",[product localizedDescription]);
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)restoreProduct {
//    NSLog(@"−−− restoreProduct −−−");
        
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
//    NSLog(@"--- paymentQueue ---");
    
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                // 購入処理中。基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
//                NSLog(@"購入処理中・・・");
                break;
            case SKPaymentTransactionStatePurchased:
                // 購入処理成功
//                NSLog(@"購入処理成功！");
//                NSLog(@"productID : %@",transaction.payment.productIdentifier);
                
                // 広告非表示フラグを立てる
                if([transaction.originalTransaction.payment.productIdentifier isEqualToString:@"removeads"] == YES){
                    [self showAlert:@"購入しました" message:@"次回起動時より広告が表示されなくなります。"];
                    [TamenchanSetting setRemoveAdsFlg:YES];
                }
                
                [queue finishTransaction: transaction];
                [source endPurchase];
                source = nil;
                break;
            case SKPaymentTransactionStateFailed:
                // 購入処理失敗。ユーザが購入処理をキャンセルした場合もここ
                if (transaction.error.code != SKErrorPaymentCancelled){
                    [self showAlert:@"購入に失敗しました" message:[transaction.error localizedDescription]];
//                    NSLog(@"購入処理失敗");
                } else {
//                    NSLog(@"購入キャンセル");
                }
//                NSLog(@"error : %@",[transaction.error localizedDescription]);
                
                [queue finishTransaction:transaction];
                [source endPurchase];
                source = nil;
                break;
            case SKPaymentTransactionStateRestored:
                //リストア処理開始
//                NSLog(@"リストア処理");
//                NSLog(@"productID : %@",transaction.originalTransaction.payment.productIdentifier);
                
                // 広告非表示フラグを立てる
                if([transaction.originalTransaction.payment.productIdentifier isEqualToString:@"removeads"] == YES){
                    [self showAlert:@"リストアしました" message:@"次回起動時より広告が表示されなくなります。"];
                    [TamenchanSetting setRemoveAdsFlg:YES];
                }
                
                [queue finishTransaction:transaction];
                [source endPurchase];
                source = nil;
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
//    NSLog(@"--- paymentQueueRestoreCompletedTransactionsFinished ---");
    if([TamenchanSetting isRemoveAdsFlg] == NO){
        [self showAlert:@"リストアしました" message:@"広告を非表示にするには[広告を非表示にする]ボタンからアドオンを購入してください。"];
    }
    
    [source endPurchase];
    source = nil;
}

- (void)paymentQueue:(SKPaymentQueue *)queue
    restoreCompletedTransactionsFailedWithError:(NSError *)error {
//    NSLog(@"--- restoreCompletedTransactionsFailedWithError ---");
    [source endPurchase];
    source = nil;
}

- (void)showAlert:(NSString*)message {
    [self showAlert:@"" message:message];
}

- (void)showAlert:(NSString*)title message:(NSString*)message {
    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:title
        message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
