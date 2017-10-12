//
//  Bitstamp.m
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Bitstamp.h"

@implementation Bitstamp

/**
 *
 * @param assetsArray NSArray*
 * @param fiatCurrencies NSArray*
 * @return NSDictionary*
 */
+ (NSDictionary *)ticker:(NSArray *)assetsArray forFiatCurrencies:(NSArray *)fiatCurrencies {
    NSString *jsonURL = [NSString stringWithFormat:@"https://www.bitstamp.net/api/v2/ticker/%@%@/", [ASSET_KEY(1) lowercaseString], [fiatCurrencies[0] lowercaseString]];

    NSDictionary *theirData = [JSON jsonRequest:jsonURL];

    if (!theirData[@"last"]) {
        NSLog(@"API-ERROR: Cannot retrieve exchange rates for %@/%@", ASSET_KEY(1), fiatCurrencies[0]);

        return nil;
    }

    // aktuelle Anfragen und Käufe
    double ask = 1 / [theirData[@"ask"] doubleValue];
    double bid = 1 / [theirData[@"bid"] doubleValue];

    // 24h Change
    double high24 = 1 / [theirData[@"high"] doubleValue];
    double low24 = 1 / [theirData[@"low"] doubleValue];

    // aktueller Kurs
    double last = 1 / [theirData[@"last"] doubleValue];

    // Heutiger Eröffnungskurs
    double open = 1 / [theirData[@"open"] doubleValue];
    double percent = 0;

    if (open != 0) {
        percent = (last / open) - 1;
    }

    NSMutableDictionary *poloniexData = [[NSMutableDictionary alloc] init];

    // High is Low and Low is HIGH
    poloniexData[DEFAULT_HIGH24] = @(low24);
    poloniexData[DEFAULT_LOW24] = @(high24);
    poloniexData[DEFAULT_ASK] = @(ask);
    poloniexData[DEFAULT_BID] = @(bid);
    poloniexData[DEFAULT_LAST] = @(last);
    poloniexData[DEFAULT_BASE_VOLUME] = @(0);
    poloniexData[DEFAULT_QUOTE_VOLUME] = @(0);

    // Poloniex liefert ausgerechnete Werte (50% sind halt 50 / 100 = 0.5)
    poloniexData[DEFAULT_PERCENT] = @(percent);

    return poloniexData;
}

/**
 * BALANCE via API-KEY
 *
 * @param apiKey NSDictionary*
 * @return NSDictionary*
 */
+ (NSDictionary *)balance:(NSDictionary *)apiKey {
    return nil;
}

/**
 * BUY via API-KEY
 *
 * @param apiKey NSDictionary*
 * @param currencyPair NSSstring*
 * @param rate double
 * @param amount double
 * @return NSDictionary*
 */
+ (NSDictionary *)buy:(NSDictionary *)apiKey currencyPair:(NSString *)currencyPair amount:(double)amount rate:(double)rate {
    return nil;
}

/**
 * SELL via API-KEY
 *
 * @param apiKey NSDictionary*
 * @param currencyPair NSSstring*
 * @param rate double
 * @param amount double
 * @return NSDictionary*
 */
+ (NSDictionary *)sell:(NSDictionary *)apiKey currencyPair:(NSString *)currencyPair amount:(double)amount rate:(double)rate {
    return nil;
}

/**
 * OPEN_ORDERS via API-KEY
 *
 * @param apiKey NSDictionary*
 * @param orderId NSString*
 * @return BOOL
 */
+ (NSArray *)openOrder:(NSDictionary *)apiKey {
    return nil;
}

/**
 * CANCEL via API-KEY
 *
 * @param apiKey NSDictionary*
 * @param orderId NSString*
 * @return BOOL
 */
+ (BOOL)cancelOrder:(NSDictionary *)apiKey orderId:(NSString *)orderId {
    return false;
}

@end
