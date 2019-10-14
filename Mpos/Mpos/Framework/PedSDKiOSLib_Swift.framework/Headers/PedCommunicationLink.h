//
//  PedCommunicationLink.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 11/07/2018.
//  Copyright © 2018 SIBS. All rights reserved.
//


#import "PedCommunicationProvider.h"
#import "DeviceManagementProvider.h"

@protocol PedCommunicationLink <PedCommunicationProvider, DeviceManagementProvider>


@end
