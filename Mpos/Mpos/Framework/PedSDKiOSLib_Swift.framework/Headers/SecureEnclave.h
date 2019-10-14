//
//  SecureEnclave.h
//  mPOS
//
//  Created by Nuno Simoes on 14/07/2017.
//  Copyright © 2017 SIBS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecureEnclave : NSObject

+(BOOL)isSupported;

+(nullable NSString*)encryptDataToString:(nonnull NSData*)dataToEncrypt;
+(nullable NSData*)encryptData:(nonnull NSData*)dataToEncrypt;

+(nullable NSData*)decryptDataFromString:(nonnull NSString*)base64EncodedString;
+(nullable NSData*)decryptData:(nonnull NSData*)encryptedData;

@end
