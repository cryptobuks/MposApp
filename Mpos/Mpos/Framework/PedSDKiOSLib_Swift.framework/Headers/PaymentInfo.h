//
//  PaymentInfo.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentType.h"
#import "PaymentMethod.h"
#import "CardInfo.h"
#import "MBWAYInfo.h"
#import "ReconciliationInfo.h"
#import "JSONModel.h"
#import "QRCodeInfo.h"
#import "StatusInquiryInfo.h"

@interface PaymentInfo : JSONModel

@property (strong, nonatomic) NSString *txId;
@property (assign, nonatomic) PAYMENT_TYPE type;
@property (assign, nonatomic) PAYMENT_METHOD method;
@property (strong, nonatomic) CardInfo<Optional> *card;
@property (strong, nonatomic) MBWAYInfo<Optional> *mbway;
@property (strong, nonatomic) ReconciliationInfo<Optional> *reconciliation;
@property (strong, nonatomic) QRCodeInfo<Optional> *qrCode;
@property (strong, nonatomic) StatusInquiryInfo<Optional> *statusInquiry;


+(PaymentInfo*) buildCardPurchaseInfo:(NSString*)txId amount:(double)amount description:(NSString*)description;

+(PaymentInfo*) buildCardRefundPurchase:(NSString*)appTxId amount:(double)amount description:(NSString*)description oriTxId:(NSString*)oriTxId oriTxDatetime:(NSDate*) oriTxDatetime resultTxId:(NSString*)resultTxId;

+(PaymentInfo*) buildCardRefundInfo:(NSString*)appTxId amount:(double)amount description:(NSString*)description oriTxId:(NSString*)oriTxId oriTxDatetime:(NSDate*) oriTxDatetime resultTxId:(NSString*)resultTxId originalType:(PAYMENT_TYPE)originalType __attribute__((deprecated("in version 1.5.0, please use 'buildCardRefundPurchase: amount: description: oriTxId: oriTxDatetime: resultTxId:'")));



+(PaymentInfo*) buildMBWAYPurchaseInfo:(NSString*)txId amount:(double)amount description:(NSString*)description alias:(NSString*)alias aliasType:(TOKEN_TYPE)aliasType;

+(PaymentInfo*) buildMBWAYRefundPurchase:(NSString*)appTxId amount:(double)amount description:(NSString*)description alias:(NSString*)alias aliasType:(TOKEN_TYPE)aliasType oriTxId:(NSString*)oriTxId oriTxDatetime:(NSDate*)oriTxDatetime resultTxId:(NSString*)resultTxId;
                                                                                                                                                                                                                                                                                                                                           
+(PaymentInfo*) buildMBWAYRefundInfo:(NSString*)appTxId amount:(double)amount description:(NSString*)description alias:(NSString*)alias aliasType:(TOKEN_TYPE)aliasType oriTxId:(NSString*)oriTxId oriTxDatetime:(NSDate*)oriTxDatetime resultTxId:(NSString*)resultTxId originalType:(PAYMENT_TYPE)originalType __attribute__((deprecated("in version 1.5.0, please use 'buildMBWAYRefundPurchase: amount: description: alias: aliasType: oriTxId: oriTxDatetime: resultTxId:'")));



+(PaymentInfo*) buildReconciliationInfo:(NSString*)txId merchantAccount:(MerchantAccount*)merchantAccount;

+(PaymentInfo*) buildMBWAYCancellationPurchase:(NSString*)appTxId amount:(double) amount description:(NSString*)description oriTxId:(NSString*)oriTxId oriTxDatetime: (NSDate*)oriTxDatetime resultTxId:(NSString*)resultTxId;

+(PaymentInfo*) buildMBWAYCancellationInfo:(NSString*)appTxId amount:(double) amount description:(NSString*)description oriTxId:(NSString*)oriTxId oriTxDatetime:(NSDate*)oriTxDatetime resultTxId:(NSString*)resultTxId originalType:(PAYMENT_TYPE)originalType __attribute__((deprecated("in version 1.5.0, please use buildMBWAYCancellationPurchase: amount: description: oriTxId: oriTxDatetime: resultTxId:")));



+(PaymentInfo*) buildTransactionStatusInquiry:(NSString *)oriTxId oriTxDatetime:(NSDate*)oriTxDatetime;



+(PaymentInfo*) buildQRCodePurchaseInfo:(NSString*)appTxId amount:(double)amount description:(NSString*)description;

+(PaymentInfo*) buildQRCodeRefundPurchase:(NSString*)appTxId amount:(double)amount description:(NSString*)description oriTxId:(NSString*)oriTxId oriTxDatetime:(NSDate*)oriTxDatetime resultTxId:(NSString*)resultTxId;

+(PaymentInfo*) buildQRCodeRefundInfo:(NSString*)appTxId amount:(double)amount description:(NSString*)description oriTxId:(NSString*)oriTxId oriTxDatetime:(NSDate*)oriTxDatetime resultTxId:(NSString*)resultTxId originalType:(PAYMENT_TYPE)originalType __attribute__((deprecated("in version 1.5.0, please use 'buildQRCodeRefundPurchase: amount: description: oriTxId: oriTxDatetime: resultTxId:'")));

@end
