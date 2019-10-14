//
//  ReversalInfo.h
//  PedSDKiOSLib
//
//  Created by Nelson João on 30/01/2018.
//  Copyright © 2018 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "FinancialResult.h"

@interface ReversalInfo : JSONModel

@property(readonly) FinancialResult * financialResult;
@property(readonly) NSString *internalTxId;

@end
