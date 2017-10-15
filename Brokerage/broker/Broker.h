//
//  Broker.h
//  Brokerage
//
//  Created by Markus Bröker on 13.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeProtocol.h"

/**
 * A common Broker for various exchanges...
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface Broker : NSObject

/**
 * Add a static class, eg a class which implements the ExchangeProtocol Delegate
 *
 * @param key
 * @param exchange
 */
- (void)addExchange:(NSString *)key exchange:(id <ExchangeProtocol>)exchange;

/**
 * Remove a static class by name
 *
 * @param key
 */
- (void)removeExchange:(NSString *)key;

/**
 * Get the implementation of an exchange as a static class
 *
 * @param key
 * @return id
 */
- (id <ExchangeProtocol>)exchange:(NSString *)key;

@end
