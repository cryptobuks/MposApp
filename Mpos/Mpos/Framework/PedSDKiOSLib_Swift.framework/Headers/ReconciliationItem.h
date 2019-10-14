//
//  ReconciliationItem.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "PaymentMethod.h"
#import "TotalType.h"
#import "JSONModel.h"


@interface ReconciliationItem : JSONModel

@property(readonly) TOTAL_TYPE type;
@property(readonly) NSString *descriptionShort;
@property(readonly) NSString *description;
@property(readonly) NSString *descriptionLong;
@property(readonly) NSString *currency;
@property(readonly) double totalNumber;
@property(readonly) double cumulativeAmount;
@property(readonly) NSString *numberDeferredDays;
@property(readonly) NSString *paymentModality;
@property(readonly) NSString *agreementType;
@property(readonly) NSString *financialProduct;
@property(readonly) NSString *totalType;

@end
