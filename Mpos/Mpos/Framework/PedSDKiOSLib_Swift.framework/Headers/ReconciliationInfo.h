//
//  ReconciliationInfo.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "MerchantAccount.h"
#import "JSONModel.h"


@interface ReconciliationInfo : JSONModel

@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *dateTime;
@property(strong, nonatomic) MerchantAccount *merchantAccount;

@end
