//
//  CardReceiptData.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 20/03/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "JSONModel.h"


@interface CardReceiptData : JSONModel

@property(readonly) NSString<Optional> *cardholderName;
@property(readonly) NSString<Optional> *appId;
@property(readonly) NSString<Optional> *appLabel;
@property(readonly) NSString<Optional> *maskedPAN;

@end
