//
//  StatusInquiryInfo.h
//  PedSDKiOSLib
//
//  Created by Nelson João on 01/02/2018.
//  Copyright © 2018 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface StatusInquiryInfo: JSONModel

@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *dateTime;
@property(strong, nonatomic) NSString *recepientId;
@end
