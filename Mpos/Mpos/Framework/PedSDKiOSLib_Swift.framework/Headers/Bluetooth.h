//
//  Bluetooth.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PedCommunicationLink.h"


typedef NS_ENUM(NSInteger, BluetoothStatus) {
    BluetoothStatusOK,
    BluetoothStatusCancelled,
    BluetoothStatusFailed
};


@protocol Bluetooth <PedCommunicationLink>

@end
