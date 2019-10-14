//
//  QRCodeInfoEvent.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 04/10/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "JSONModel.h"

@interface QRCodeInfoEvent : JSONModel

@property (readonly) NSString *QRCodeValue;

@end
