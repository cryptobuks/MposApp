//
//  ReconciliationResult.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "ReconciliationItem.h"
#import "MerchantAccount.h"
#import "JSONModel.h"


@protocol ReconciliationItem;


@interface ReconciliationResult : JSONModel

@property(readonly) NSString *id;
@property(readonly) NSString *dateTime;
@property(readonly) NSString<Optional> *recipientId;
@property(readonly) MerchantAccount<Optional> *merchantAccount;
@property(readonly) NSMutableArray<ReconciliationItem, Optional> *items;

@end
