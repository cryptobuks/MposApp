//
//  CommunicationProvider.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PedCommunicationProvider <NSObject>

-(bool) connect;
-(void) disconnect;
-(bool) isConnected;

-(int) write:(NSData*)data;
-(NSData*) read:(int)length;

@end
