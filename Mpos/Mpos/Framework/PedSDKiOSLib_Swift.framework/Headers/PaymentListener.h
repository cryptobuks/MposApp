//
//  PaymentListener.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionStatus.h"
#import "DeviceDiscoveryStatus.h"
#import "BatteryEvent.h"
#import "PaymentResult.h"
#import "DeviceEvent.h"
#import "CardEvent.h"
#import "KeyEvent.h"
#import "InfoEvent.h"
#import "QRCodeInfoEvent.h"
#import "DeleteReversalEnum.h"
#import "ReversalInfo.h"
#import "Device.h"

@protocol PaymentListener <NSObject>

-(void) onComplete:(nonnull PaymentResult*)result;

@optional

-(void) chooseDeviceFromList:(nonnull NSArray<NSString*>*)deviceNames onCompletion:(void (^ __nonnull)(NSInteger selectedDevice))completion;

-(void) selectDevice:(nonnull NSArray<Device*>*)devices onCompletion:(void (^ __nonnull)(Device *selectedDevice))completion;

-(void) OnStartDeviceConnectionStateChanged:(CONNECTION_STATUS)event;

-(void) onDeviceDetectionError:(DEVICE_DISCOVERY_STATUS)event;

-(void) OnBatteryStatusChange:(nonnull BatteryEvent*)batteryStatus;

-(void) OnDeviceStatusChange:(nonnull DeviceEvent*)event;

-(void) OnCardStatusChange:(nonnull CardEvent*)event;

-(void) OnKeyStatusChange:(nonnull KeyEvent*) event;

-(void) OnInfo:(nonnull InfoEvent*)event;

-(void) OnQRCodeInfo:(nonnull QRCodeInfoEvent*)event;

-(void) OnAuthorisationProcessing;

-(void) OnAllReversals:(NSMutableArray<ReversalInfo *>*)reversalInfo;

-(void) OnDeleteReversals:(DELETE_REVERSAL_ENUM)resultStatus;

@end
