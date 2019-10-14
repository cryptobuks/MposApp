//
//  PaymentCredentials.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface PaymentCredentials : JSONModel

@property(readonly) int merchantId;
@property(readonly) int terminalId;
@property(readonly) NSString *merchantAuthId;
@property(readonly) NSString *merchantAuthKey;

+(PaymentCredentials*) createWithMerchantId:(int)merchantId terminalId:(int)terminalId merchantAuthId:(NSString*)merchantAuthId merchantAuthKey:(NSString*)merchantAuthKey;

@end
