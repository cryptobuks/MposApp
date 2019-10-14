//
//  PaymentType.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#ifndef PaymentType_h
#define PaymentType_h

typedef NS_ENUM(NSInteger, PAYMENT_TYPE) {
    PAYMENT_TYPE_PT_AUTHORISATION,
    PAYMENT_TYPE_PT_AUTHORISATION_WITH_CAPTURE,
    PAYMENT_TYPE_PT_CAPTURE,
    PAYMENT_TYPE_PT_AUTHORISATION_CANCELLATION,
    PAYMENT_TYPE_PT_REFUND,
    PAYMENT_TYPE_PT_RECONCILIATION,
    PAYMENT_TYPE_PT_REVERSAL,
    PAYMENT_TYPE_PT_STATUS_INQUIRY,
};

#endif /* PaymentType_h */
