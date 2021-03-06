//
//  InAppPurchaseManager.h
//  Tamenchan
//
//  Created by 藤原 達郎 on 2013/03/11.
//  Copyright (c) 2013年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "InAppPurchaseProtocol.h"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest* myProductRequest;
}

@property (strong, nonatomic) id<InAppPurchaseProtocol> source;

- (BOOL)canMakePurchases;

- (void)requestProductData:(NSString*)pID;

- (void)restoreProduct;

@end
