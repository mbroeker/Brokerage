//
//  Crypto.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Crypto.h"
#import "Asset.h"

/**
 * Cryptographic Methods
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface Crypto : NSObject

/**
 * Compute a hmac hash from "plainText" with secret "secret"
 *
 * @param plainText NSString*
 * @param withSecret NSString*
 * @return NSString*
 */
+ (NSString *)hmac:(NSString *)plainText withSecret:(NSString *)secret;

/**
 * Compute a sha512 hash from input string
 *
 * @param input NSString*
 * @return NSString*
 */
+ (NSString *)sha512:(NSString *)input;
@end
