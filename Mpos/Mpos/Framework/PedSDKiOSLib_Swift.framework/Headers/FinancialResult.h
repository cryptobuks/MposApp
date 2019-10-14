//
//  FinancialResult.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "PaymentTransaction.h"
#import "PaymentEntryMode.h"
#import "ReceiptData.h"
#import "JSONModel.h"


@interface FinancialResult : JSONModel

@property(assign, nonatomic) PAYMENT_ENTRY_MODE entryMode;
@property(strong, nonatomic) ReceiptData<Optional> *receiptData;
@property(strong, nonatomic) PaymentTransaction *tx;
@property(strong, nonatomic) PaymentTransaction<Optional> *recipientTx;
@property(assign, nonatomic) BOOL handwrittenSignatureRequired;

@end
