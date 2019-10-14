//
//  PaymentTransactionDetails.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "JSONModel.h"

@interface PaymentTransactionDetails : JSONModel

@property(assign, nonatomic) double amount;
@property(strong, nonatomic) NSString<Optional> *description;

@end
