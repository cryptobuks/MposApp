//
//  PaymentResult.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentStatus.h"
#import "PaymentType.h"
#import "FinancialResult.h"
#import "ReconciliationResult.h"
#import "PaymentInfo.h"
#import "PaymentEntryMode.h"
#import "PaymentTransaction.h"
#import "JSONModel.h"




@interface PaymentResult : JSONModel

@property (assign, nonatomic) PAYMENT_STATUS status;
@property (assign, nonatomic) int error;
@property (strong, nonatomic) NSString<Optional> *errorCode;
@property (assign, nonatomic) PAYMENT_TYPE type;
@property (strong, nonatomic) PaymentTransaction<Optional> *appTx;
@property (strong, nonatomic) FinancialResult<Optional> *financial;
@property (strong, nonatomic) ReconciliationResult<Optional> *reconciliation;


//+(PaymentResult*) Success:(PaymentInfo*)paymentInfo recipientTxId:(NSString*)recipientTxId dateTime:(NSDate*)dateTime;
//+(PaymentResult*) Declined:(PaymentInfo*)paymentInfo recipientTxId:(NSString*)recipientTxId dateTime:(NSDate*)dateTime;
+(PaymentResult*) Error:(PaymentInfo*)paymentInfo status:(PAYMENT_STATUS)status;

@end
