//
//  MBWAYInfo.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "PaymentTransaction.h"
#import "MBToken.h"
#import "PaymentTransactionLinked.h"
#import "JSONModel.h"



@interface MBWAYInfo : JSONModel

@property(strong, nonatomic) PaymentTransaction *appTx;
@property(strong, nonatomic) MBToken *token;
@property(strong, nonatomic) PaymentTransactionLinked<Optional> *oriTx;

@end
