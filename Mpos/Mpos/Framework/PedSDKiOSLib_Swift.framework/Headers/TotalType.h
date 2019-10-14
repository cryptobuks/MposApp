//
//  TotalType.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 06/03/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#ifndef TotalType_h
#define TotalType_h

typedef NS_ENUM(NSInteger, TOTAL_TYPE) {
    TOTAL_TYPE_CREDIT,
    TOTAL_TYPE_CREDITREVERSE,
    TOTAL_TYPE_DEBIT,
    TOTAL_TYPE_DEBITREVERSE,
    TOTAL_TYPE_DECLINED,
    TOTAL_TYPE_FAILED,
    TOTAL_TYPE_MERCHANTTOTALS,
    TOTAL_TYPE_OPERATIONTOTALS,
    TOTAL_TYPE_COMMISSIONTOTALS,
    TOTAL_TYPE_FINANCIALTOTALS
};

#endif /* TotalType_h */
