//
//  DeviceDiscoveryStatus.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#ifndef DeviceDiscoveryStatus_h
#define DeviceDiscoveryStatus_h


#define deviceDiscoveryStatusString(enum) [@[@"Not Available",@"Not enabled",@"No device detected", @"Invalid device index"] objectAtIndex:enum]


typedef NS_ENUM(NSInteger, DEVICE_DISCOVERY_STATUS) {
    DEVICE_DISCOVERY_STATUS_BLUETOOTHNOTAVAILABLE,
    DEVICE_DISCOVERY_STATUS_BLUETOOTHNOTENABLE,
    DEVICE_DISCOVERY_STATUS_NODEVICEDETECTED,
    DEVICE_DISCOVERY_STATUS_INVALIDDEVICEINDEX,
};



#endif /* DeviceDiscoveryStatus_h */
