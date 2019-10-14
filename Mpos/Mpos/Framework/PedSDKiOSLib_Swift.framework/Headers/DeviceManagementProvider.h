//
//  DeviceManagementProvider.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/07/2018.
//  Copyright © 2018 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

typedef void(^ScanForAvailableDevicesCompletion)(NSError * __nullable error);

@protocol DeviceManagementProvider <NSObject>

-(NSArray<Device*>*_Nullable) getDevices;
-(void) setDevice:(Device*_Nonnull)device;
-(void)scanForAvailableDevices:(nullable ScanForAvailableDevicesCompletion)completion;;
-(void)notifyOnPedReconnection;

@end
