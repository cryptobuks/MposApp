//
//  PaymentStatus.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#ifndef PaymentStatus_h
#define PaymentStatus_h


#define paymentStatusString(enum) [@[@"CNFER",@"INTER",@"UNKDV",@"DEVER",@"APPR",@"DECL",@"COMER",@"USRCN",@"USRTO",@"MSCRD", @"PEDUP", @"NOGPS"] objectAtIndex:enum]


typedef NS_ENUM(NSInteger, PAYMENT_STATUS) {
    PAYMENT_STATUS_CONFIGURATIONERROR,
    PAYMENT_STATUS_INTERFACEERROR,
    PAYMENT_STATUS_UNKNOWNDEVICE,
    PAYMENT_STATUS_DEVICEERROR,
    PAYMENT_STATUS_SUCCESS,
    PAYMENT_STATUS_DECLINED,
    PAYMENT_STATUS_COMMERROR,
    PAYMENT_STATUS_USERCANCELLED,
    PAYMENT_STATUS_USERTIMEOUT,
    PAYMENT_STATUS_MISSINGCREDENTIALS,
    PAYMENT_STATUS_PEDUPDATING,
    PAYMENT_STATUS_NO_GPS_LOCATION
};

extern NSString* PaymentStatusString(int paymentStatus);

#endif /* PaymentStatus_h */
