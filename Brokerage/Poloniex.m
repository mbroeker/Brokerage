//
//  Poloniex.m
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Poloniex.h"
#import "Bitstamp.h"

@implementation Poloniex

/**
 *
 * @param assetsArray NSArray*
 * @param fiatCurrencies NSArray*
 * @return NSDictionary*
 */
+ (NSDictionary *)ticker:(NSArray *)assetsArray forFiatCurrencies:(NSArray *)fiatCurrencies {
    NSString *jsonURL = @"https://poloniex.com/public?command=returnTicker";

    if (![JSON isInternetConnection]) {
        return nil;
    }

    NSMutableDictionary *ticker = [[JSON jsonRequest:jsonURL] mutableCopy];

    if (!ticker[@"BTC_XMR"]) {
        return nil;
    }

    NSDictionary *asset1Ticker = [Bitstamp ticker:assetsArray forFiatCurrencies:fiatCurrencies];

    if (!asset1Ticker) {
        return nil;
    }

    NSNumber *exchangeRate = [Broker fiatExchangeRate:fiatCurrencies];

    if (!exchangeRate) {
        return nil;
    }

    NSString *asset1Fiat = [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), fiatCurrencies[0]];
    ticker[asset1Fiat] = asset1Ticker;
    ticker[fiatCurrencies[1]] = @([exchangeRate doubleValue]);

    return ticker;
}

/**
 * Request the balance from Poloniex via API-Key
 *
 * @param apiKey NSDictionary*
 * @param secret NSString*
 * @return NSDictionary*
 */
+ (NSDictionary *)balance:(NSDictionary *)apiKey {

    if (apiKey == nil) {
        return nil;
    }

    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apiKey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"returnCompleteBalances";
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Crypto hmac:[JSON urlEncode:payload] withSecret:apiKey[SECRET]];

    NSDictionary *data = [JSON jsonRequest:jsonURL withPayload:payload andHeader:header];

    if (data == nil) {
        return @{
            DEFAULT_ERROR: @"API-ERROR: Cannot fetch Data from Poloniex"
        };
    }

    return data;
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

    if (apiKey == nil) {
        return nil;
    }

    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apiKey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"buy";
    payload[@"currencyPair"] = currencyPair;
    payload[@"rate"] = [NSNumber numberWithDouble:rate];
    payload[@"amount"] = [NSNumber numberWithDouble:amount];
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Crypto hmac:[JSON urlEncode:payload] withSecret:apiKey[SECRET]];

    return [JSON jsonRequest:jsonURL withPayload:payload andHeader:header];
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

    if (apiKey == nil) {
        return nil;
    }

    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apiKey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"sell";
    payload[@"currencyPair"] = currencyPair;
    payload[@"rate"] = [NSNumber numberWithDouble:rate];
    payload[@"amount"] = [NSNumber numberWithDouble:amount];
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Crypto hmac:[JSON urlEncode:payload] withSecret:apiKey[SECRET]];

    return [JSON jsonRequest:jsonURL withPayload:payload andHeader:header];
}

/**
 * openOrder via API-KEY
 *
 * @param apikey NSDictionary*
 * @return NSArray*
 */
+ (NSArray *)openOrder:(NSDictionary *)apiKey {

    if (apiKey == nil) {
        return nil;
    }

    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apiKey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"returnOpenOrders";
    payload[@"currencyPair"] = @"all";
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Crypto hmac:[JSON urlEncode:payload] withSecret:apiKey[SECRET]];

    NSDictionary *response = [JSON jsonRequest:jsonURL withPayload:payload andHeader:header];

    if (response[DEFAULT_ERROR]) {
        NSLog(@"ERROR: %@", response[DEFAULT_ERROR]);
        return nil;
    }

    NSMutableArray *orders = [[NSMutableArray alloc] init];

    int i = 0;
    for (id key in response) {
        NSString *assetPair = key;
        NSDictionary *data = response[key];

        if (data.count > 0) {
            /**
             * ORDER-ID
             * DATE
             * PAIR
             * AMOUNT
             * RATE
             */
            orders[i++] = @[
                data[DEFAULT_ORDER_NUMBER],
                @"---",
                assetPair,
                data[@"amount"],
                data[@"rate"]
            ];
        }
    }

    return orders;
}

/**
 * Cancel via API-KEY
 *
 * @param apiKey NSDictionary*
 * @param orderId NSString*
 * @return BOOL
 */
+ (BOOL)cancelOrder:(NSDictionary *)apiKey orderId:(NSString *)orderId {

    if (apiKey == nil) {
        return NO;
    }

    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apiKey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"cancelOrder";
    payload[@"orderId"] = orderId;
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Crypto hmac:[JSON urlEncode:payload] withSecret:apiKey[SECRET]];

    NSDictionary *response = [JSON jsonRequest:jsonURL withPayload:payload andHeader:header];

    if (response[DEFAULT_ERROR]) {
        NSLog(@"ERROR: %@", response[DEFAULT_ERROR]);
        return NO;
    }

    return [response[@"success"] isEqualToString:@"true"];
}

@end
