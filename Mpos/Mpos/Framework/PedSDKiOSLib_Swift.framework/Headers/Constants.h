//
//  Constants.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 09/03/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#endif /* Constants_h */


// enums

typedef enum
{
    DEVICE_CONNECTION_TYPE_ALL = 0,
    DEVICE_CONNECTION_TYPE_BLUETOOTH,
    DEVICE_CONNECTION_TYPE_WIFI,
} DEVICE_CONNECTION_TYPE;


//CGD notifications

#define NOTIFICATION_PED_DID_CONNECT                                         @"sibs.mpos.pedDidConnect"
#define NOTIFICATION_PED_DID_DISCONNECT                                      @"sibs.mpos.pedDidDisconnect"
