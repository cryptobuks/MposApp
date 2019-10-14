//
//  DeviceEvent.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 14/10/2016.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger, STATUS_EVENT) {
    STATUS_EVENT_POWER_ON           = 0x001,
    STATUS_EVENT_PIN_ENTRY_EVENT    = 0x002,
    STATUS_EVENT_EMV_APP_SELECTION  = 0x004,
    STATUS_EVENT_POWER_OFF          = 0x008,
    STATUS_EVENT_REBOOTING          = 0x010,
    STATUS_EVENT_RESTARTING         = 0x020,
    STATUS_EVENT_SEE_PHONE          = 0x040,
    STATUS_EVENT_SUCCESS_BEEP       = 0x080,
    STATUS_EVENT_ERROR_BEEP         = 0x100,
    STATUS_EVENT_ERROR_PROTO        = 0x200
};



@interface DeviceEvent : JSONModel

@property(readonly) int status;

@end
