//
//  BatteryEvent.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 14/10/2016.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import "JSONModel.h"


#define batteryEventString(enum) [@[@"On batttery",@"Charging",@"Charged", @"Battery low"] objectAtIndex:enum]


typedef NS_ENUM(NSInteger, BATTERY_STATE) {
    BATTERY_STATE_ON_BATTERY,
    BATTERY_STATE_CHARGING,
    BATTERY_STATE_CHARGED,
    BATTERY_STATE_BATTERY_LOW
};

@interface BatteryEvent : JSONModel

@property(readonly) BATTERY_STATE state;
@property(readonly)  int level;

@end
