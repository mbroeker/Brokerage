//
//  Broker.m
//  Brokerage
//
//  Created by Markus Bröker on 13.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Broker.h"
#import "Bittrex.h"
#import "Bitstamp.h"
#import "Poloniex.h"

@implementation Broker {
    NSMutableDictionary *exchanges;
}

- (id)init {
    return [self initWithExchanges:@{
        EXCHANGE_BITTREX: [Bittrex class],
        EXCHANGE_BITSTAMP: [Bitstamp class],
        EXCHANGE_POLONIEX: [Poloniex class],
    }];
}

/**
 *
 * @param initialExchanges (NSDictionary*)
 */
- (id)initWithExchanges:(NSDictionary *)initialExchanges {
    if (self = [super init]) {
        exchanges = [initialExchanges mutableCopy];
    }

    return self;
}

/**
 * @param key (NSString*)
 * @param exchange (id)
 */
- (void)addExchange:(NSString *)key exchange:(id)exchange {
    exchanges[key] = exchange;
}

/**
 * @param key (NSString*)
 */
- (void)removeExchange:(NSString *)key {
    [exchanges removeObjectForKey:key];
}

/**
 * @param key
 */
- (id)exchange:(NSString *)key {
    return exchanges[key];
}

@end
