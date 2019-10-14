//
//  MBToken.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 08/02/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import "TokenType.h"
#import "JSONModel.h"


@interface MBToken : JSONModel

@property(strong, nonatomic) NSString *id;
@property(assign, nonatomic) TOKEN_TYPE type;

@end
