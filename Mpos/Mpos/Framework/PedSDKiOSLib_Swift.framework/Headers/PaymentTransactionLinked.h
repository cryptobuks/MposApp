//
//  PaymentTransactionLinked.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "PaymentType.h"
#import "JSONModel.h"


@interface PaymentTransactionLinked : JSONModel

@property(assign, nonatomic)  PAYMENT_TYPE type;
@property(strong, nonatomic)  NSString *id;
@property(strong, nonatomic)  NSString *dateTime;
@property(strong, nonatomic)  NSString<Optional> *recepientId;

@end
