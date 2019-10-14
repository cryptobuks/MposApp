//
//  MerchantAccount.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 06/03/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "AccountNumberType.h"
#import "JSONModel.h"


@interface MerchantAccount : JSONModel

@property (readonly) NSString *number;
@property (readonly) ACCOUNT_NUMBER_TYPE type;

+(instancetype) buildNone;
+(instancetype) buildBBAN:(NSString*)bban;
+(instancetype) buildIBAN:(NSString*)iban;

@end
