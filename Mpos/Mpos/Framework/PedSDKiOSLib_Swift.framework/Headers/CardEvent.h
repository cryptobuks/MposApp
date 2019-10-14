//
//  CardEvent.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 14/10/2016.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import "JSONModel.h"

@interface CardEvent : JSONModel

@property(readonly)  bool present;
@property(readonly)  bool chip;
@property(readonly)  bool magStripe;

@end
