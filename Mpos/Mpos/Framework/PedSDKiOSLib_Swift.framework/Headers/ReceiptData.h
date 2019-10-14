//
//  ReceiptData.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 20/03/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "CardReceiptData.h"
#import "JSONModel.h"


@interface ReceiptData : JSONModel

@property(readonly) CardReceiptData<Optional> *cardData;
@property(readonly) NSString<Optional> *acquirerText;
@property(readonly) NSString<Optional> *issuerName;
@property(readonly) NSString<Optional> *financialProductDescShort;
@property(readonly) NSString<Optional> *financialProductDescMedium;
@property(readonly) NSString<Optional> *financialProductDescLong;
@property(readonly) NSString<Optional> *authId;
@property(readonly) NSString<Optional> *discountFee;
@property(readonly) NSString<Optional> *clientFee;
@property(readonly) NSString<Optional> *clientFeeCurrency;

@end
