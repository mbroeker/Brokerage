//
//  Bittrex.m
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Bittrex.h"
#import "Bitstamp.h"

@implementation Bittrex

/**
 *
 * @param fiatCurrencies NSArray*
 * @return NSDictionary*
 */
+ (NSDictionary *)ticker:(NSArray *)fiatCurrencies {

    if (![JSON isInternetConnection]) {
        return nil;
    }

    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/public/getmarketsummaries"];
    NSMutableDictionary *innerTicker = [[JSON jsonRequest:jsonURL] mutableCopy];

    NSMutableDictionary *ticker = [[NSMutableDictionary alloc] init];

    if (!innerTicker[@"result"]) {
        return nil;
    }

    NSDictionary *result = innerTicker[@"result"];

    for (id data in result) {
        NSString *marketName = data[@"MarketName"];

        marketName = [marketName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];

        double percent = ([data[@"Last"] doubleValue] / [data[@"PrevDay"] doubleValue]) - 1;

        ticker[marketName] = @{
            DEFAULT_HIGH24: data[@"High"],
            DEFAULT_LOW24: data[@"Low"],
            DEFAULT_ASK: data[@"Ask"],
            DEFAULT_BID: data[@"Bid"],
            DEFAULT_LAST: data[@"Last"],
            DEFAULT_BASE_VOLUME: data[@"BaseVolume"],
            DEFAULT_QUOTE_VOLUME: data[@"Volume"],
            DEFAULT_PERCENT: @(percent)
        };
    }

    NSDictionary *asset1Ticker = [Bitstamp ticker:fiatCurrencies];

    if (!asset1Ticker) {
        return nil;
    }

    NSString *asset1Fiat = [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), fiatCurrencies[0]];
    ticker[asset1Fiat] = asset1Ticker[asset1Fiat];

    return ticker;
}

/**
 * Request the balance from Bittrex via API-Key
 *
 * @param apiKey NSDictionary*
 * @param secret NSString*
 * @return NSDictionary*
 */
+ (NSDictionary *)balance:(NSDictionary *)apikey {

    if (apikey == nil) {
        return nil;
    }

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];

    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/account/getbalances?apikey=%@&nonce=%@", apikey[KEY], nonce];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Crypto hmac:[JSON urlStringEncode:jsonURL] withSecret:apikey[SECRET]];

    NSDictionary *data = [JSON jsonRequest:jsonURL withPayload:nil andHeader:header];

    if (data == nil) {
        return @{
            DEFAULT_ERROR: @"API-ERROR: Cannot fetch Data from Bittrex"
        };
    }

    if ([data[@"success"] intValue] == 0) {
        return @{
            DEFAULT_ERROR: data[@"message"]
        };
    }

    NSArray *dataRows = data[@"result"];

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    for (NSDictionary *row in dataRows) {
        NSString *asset = row[@"Currency"];

        double available = [row[@"Available"] doubleValue];
        double onOrders = [row[@"Balance"] doubleValue] - available;

        result[asset] = @{
            DEFAULT_AVAILABLE: @(available),
            DEFAULT_ON_ORDERS: @(onOrders)
        };
    }

    return result;
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

    NSString *bittrexCurrencyPair = [currencyPair stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *bittrexRate = [NSString stringWithFormat:@"%.8f", rate];
    NSString *bittrexAmount = [NSString stringWithFormat:@"%.8f", amount];

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/buylimit?apikey=%@&market=%@&quantity=%@&rate=%@&nonce=%@",
        apiKey[KEY],
        bittrexCurrencyPair,
        bittrexAmount,
        bittrexRate,
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Crypto hmac:[JSON urlStringEncode:jsonURL] withSecret:apiKey[SECRET]];

    NSDictionary *response = [JSON jsonRequest:jsonURL withPayload:nil andHeader:header];

    if ([response[@"success"] integerValue] == 1) {
        NSDictionary *result = response[@"result"];

        return @{
            DEFAULT_ORDER_NUMBER: result[@"uuid"]
        };
    } else {
        return @{
            DEFAULT_ERROR: [NSString stringWithFormat:@"BUY-LIMIT: %@", response[@"message"]]
        };
    }

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

    if (apiKey == nil) {
        return nil;
    }

    NSString *bittrexCurrencyPair = [currencyPair stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *bittrexRate = [NSString stringWithFormat:@"%.8f", rate];
    NSString *bittrexAmount = [NSString stringWithFormat:@"%.8f", amount];

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/selllimit?apikey=%@&market=%@&quantity=%@&rate=%@&nonce=%@",
        apiKey[KEY],
        bittrexCurrencyPair,
        bittrexAmount,
        bittrexRate,
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Crypto hmac:[JSON urlStringEncode:jsonURL] withSecret:apiKey[SECRET]];

    NSDictionary *response = [JSON jsonRequest:jsonURL withPayload:nil andHeader:header];

    if ([response[@"success"] integerValue] == 1) {
        NSDictionary *result = response[@"result"];

        return @{
            DEFAULT_ORDER_NUMBER: result[@"uuid"]
        };
    } else {
        return @{
            DEFAULT_ERROR: [NSString stringWithFormat:@"SELL-LIMIT: %@", response[@"message"]]
        };
    }

    return nil;
}

/**
 * openOrder via API-KEY
 *
 * @param apikey NSDictionary*
 * @return NSArray*
 */
+ (NSArray *)openOrders:(NSDictionary *)apiKey {
    if (apiKey == nil) {
        return nil;
    }

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/getopenorders?apikey=%@&nonce=%@",
        apiKey[KEY],
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Crypto hmac:[JSON urlStringEncode:jsonURL] withSecret:apiKey[SECRET]];

    NSDictionary *response = [JSON jsonRequest:jsonURL withPayload:nil andHeader:header];

    NSMutableArray *orders = [[NSMutableArray alloc] init];
    if ([response[@"success"] integerValue] == 1) {
        NSArray *result = response[@"result"];

        int i = 0;
        for (NSDictionary *element in result) {
            /**
             * ORDER-ID
             * DATE
             * PAIR
             * AMOUNT
             * RATE
             */
            orders[i++] = @[
                element[@"OrderUuid"],
                element[@"Opened"],
                element[@"Exchange"],
                element[@"Quantity"],
                element[@"Limit"]
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

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/cancel?apikey=%@&uuid=%@&nonce=%@",
        apiKey[KEY],
        orderId,
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Crypto hmac:[JSON urlStringEncode:jsonURL] withSecret:apiKey[SECRET]];

    NSDictionary *response = [JSON jsonRequest:jsonURL withPayload:nil andHeader:header];

    return ([response[@"success"] integerValue] == 1);
}

@end
