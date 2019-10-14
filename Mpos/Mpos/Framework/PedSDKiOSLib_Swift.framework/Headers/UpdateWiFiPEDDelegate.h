//
//  UpdateWiFiPEDDelegate.h
//  PedSDKiOSLib
//
//  Created by Nuno Simoes on 25/07/2018.
//  Copyright © 2018 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdatePEDDelegate <NSObject>

// percentage value between 0 and 100
-(void) updatePEDProgess:(NSInteger)percentage;
-(void) updatePEDComplete;

@end
