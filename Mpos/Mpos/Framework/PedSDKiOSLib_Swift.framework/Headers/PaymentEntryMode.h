//
//  PaymentEntryMode.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 07/03/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#ifndef PaymentEntryMode_h
#define PaymentEntryMode_h

#define paymentEntryModeString(enum) [@[@"NONE",@"MBWAY",@"CARD_MAGSTRIPE",@"CARD_CHIP_CONTACT",@"CARD_CHIP_CONTACTLESS"] objectAtIndex:enum]


typedef NS_ENUM(NSInteger, PAYMENT_ENTRY_MODE) {
    PAYMENT_ENTRY_MODE_NONE,
    PAYMENT_ENTRY_MODE_MBWAY,
    PAYMENT_ENTRY_MODE_CARD_MAGSTRIPE,
    PAYMENT_ENTRY_MODE_CARD_CHIP_CONTACT,
    PAYMENT_ENTRY_MODE_CARD_CHIP_CONTACTLESS,
    PAYMENT_ENTRY_MODE_QRCODE

};

extern NSString* PaymentEntryModeString(int paymentEntryMode);

#endif /* PaymentEntryMode_h */
