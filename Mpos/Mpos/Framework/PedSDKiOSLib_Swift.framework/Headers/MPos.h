//
//  MPos.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 11/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PaymentProviderProtocol.h"
#import "Bluetooth.h"
#import "Tcp.h"
#import "PaymentCredentials.h"
#import "Constants.h"
#import "PedCommunicationLink.h"
#import "UpdateWiFiPEDDelegate.h"


@interface MPos : NSObject

+(BOOL)isRooted;

+(nullable id<Bluetooth>)bluetoothConnection __attribute__((deprecated("in version 1.5.0, please use 'pedCommunicationLink'")));
+(nullable id<Tcp>)wifiConnection __attribute__((deprecated("in version 1.5.0, please use 'pedCommunicationLink'")));
+(nullable id<PedCommunicationLink>)pedCommunicationLink;

+(nullable id<PaymentProviderProtocol>) createProviderMock;
+(nullable id<PaymentProviderProtocol>) createProviderTest;
+(nullable id<PaymentProviderProtocol>) createProviderLive;

+(void)setDefaultDevice:(nullable Device*)device;
+(nullable Device*)getDefaultDevice;

+(nullable NSArray<Device*>*)getConnectedDeviceList:(DEVICE_CONNECTION_TYPE)connectionsType;

+(void)scanForAvailableDevices:(nullable ScanForAvailableDevicesCompletion)completion;

+(void)setPEDSearchList:(NSArray<Device*>*)pedList;

+(void)updatePEDsOnNetwork:(nullable id<UpdatePEDDelegate>)delegate;

@end
