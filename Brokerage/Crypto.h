//
//  JSON+Crypto.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Crypto.h"
#import "Brokerage.h"

@interface Crypto : NSObject
+ (NSString *)hmac:(NSString *)plainText withSecret:(NSString *)secret;

+ (NSString *)sha512:(NSString *)input;
@end
