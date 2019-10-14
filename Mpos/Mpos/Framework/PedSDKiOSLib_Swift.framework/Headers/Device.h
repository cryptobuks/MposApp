//
//  Device.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    PED_COMMUNICATION_TYPE_BLUETOOTH = 0,
    PED_COMMUNICATION_TYPE_WIFI,
} PED_COMMUNICATION_TYPE;



@interface Device : NSObject <NSCoding>

+(instancetype) createWiFiWithBrand:(NSString*)brand description:(NSString*)description hostname:(NSString*)hostname name:(NSString*)name identifier:(NSString*)identifier port:(NSUInteger)port;
+(instancetype) createBluetoothWithBrand:(NSString*)brand description:(NSString*)description name:(NSString*)name identifier:(NSString*)identifier connected:(bool)connected;

+(instancetype) deviceWithDevice:(Device*)device isDefault:(BOOL)isDefault connected:(BOOL)connected;



+(instancetype) create:(NSString*)deviceName identifier:(NSString*)identifier connected:(bool)connected communicationType:(PED_COMMUNICATION_TYPE)communicationType __attribute__((deprecated("in version 1.5.0, please use 'createBluetoothWithBrand or createWiFiWithBrand'")));

+(instancetype) createDefaultDeviceWithDevice:(Device*)device __attribute__((deprecated("in version 1.5.0, please use 'deviceWithDevice: isDefault: connected:'")));


-(NSString*) getBrand;
-(NSString*) getDescription;
-(NSString*) getDeviceName;
-(NSString*) getHostname;
-(NSUInteger) getPort;
-(bool) isConnected;
-(NSString*) getId;
-(bool)isDefault;
-(PED_COMMUNICATION_TYPE)communicationType;

@end
