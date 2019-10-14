//
//  PaymentProvider.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 10/10/16.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentListener.h"
#import "PaymentInfo.h"
#import "PedCommunicationProvider.h"
#import "ProviderMode.h"
#import "PaymentCredentials.h"


@protocol PaymentProviderProtocol <NSObject>

-(void)setCredentials:(PaymentCredentials*)credentials;

-(void) processAsync:(id<PaymentListener>)listener info:(PaymentInfo*)info pedCommProvider:(id<PedCommunicationProvider>)pedCommProvider __attribute__((deprecated("in version 1.5.0, please use 'processAsync: info:'")));
-(void) processAsync:(id<PaymentListener>)listener info:(PaymentInfo*)info;

-(void) cancel;

-(BOOL)paymentInProgress;

-(void) deleteReversal:(id<PaymentListener>)listener withTransactionID:(NSString *)txId;
-(void) getReversals:(id<PaymentListener>)listener;

@end
