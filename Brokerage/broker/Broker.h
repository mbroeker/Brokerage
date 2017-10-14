//
//  Broker.h
//  Brokerage
//
//  Created by Markus Bröker on 13.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Broker : NSObject

/**
 *
 */
- (void)addExchange:(NSString *)key exchange:(id)exchange;

/**
 *
 */
- (void)removeExchange:(NSString *)key;

/**
 *
 */
- (id)exchange:(NSString *)key;

@end
