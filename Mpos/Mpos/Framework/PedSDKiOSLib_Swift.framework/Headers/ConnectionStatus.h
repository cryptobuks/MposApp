//
//  ConnectionStatus.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#ifndef ConnectionStatus_h
#define ConnectionStatus_h


#define connectionStatusString(enum) [@[@"Not connected",@"Connecting",@"Connected"] objectAtIndex:enum]


typedef NS_ENUM(NSInteger, CONNECTION_STATUS) {
    CONNECTION_STATUS_NOTCONNECTED,
    CONNECTION_STATUS_CONNECTING,
    CONNECTION_STATUS_CONNECTED,
};

    
    
#endif /* ConnectionStatus_h */
