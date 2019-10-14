//
//  InfoEvent.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 19/10/2016.
//  Copyright © 2016 SIBS. All rights reserved.
//

#import "JSONModel.h"


#define infoTypeString(enum) [@[@"Wait card inserted",@"Wait card removed",@"Wait activate contactless",@"Wait ped updating"] objectAtIndex:enum]


typedef NS_ENUM(NSInteger, INFO_TYPE) {
    INFO_TYPE_WAIT_CARD_INSERTED,
    INFO_TYPE_WAIT_CARD_REMOVED,
    INFO_TYPE_WAIT_ACTIVATE_CONTACTLESS,
    INFO_TYPE_PED_UPDATING,
};


@interface InfoEvent : JSONModel

@property(readonly) INFO_TYPE type;

@end
