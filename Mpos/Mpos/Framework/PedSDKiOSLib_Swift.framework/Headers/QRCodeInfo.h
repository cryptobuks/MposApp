//
//  QRCodeInfo.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 04/10/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "JSONModel.h"
#import "PaymentTransaction.h"
#import "PaymentTransactionLinked.h"

@interface QRCodeInfo : JSONModel

@property(strong, nonatomic) PaymentTransaction *appTx;
@property(strong, nonatomic) PaymentTransactionLinked *oriTx;

@end
