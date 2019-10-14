//
//  PaymentTransaction.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "PaymentTransactionDetails.h"
#import "JSONModel.h"


@interface PaymentTransaction : JSONModel

@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *dateTime;
@property(strong, nonatomic) PaymentTransactionDetails<Optional> *details;

@end
