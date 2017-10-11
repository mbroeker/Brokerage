//
//  Broker.m
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Broker.h"

@implementation Broker

/**
 * Besorge den Umrechnungsfaktor EUR/USD
 * 
 * @param fiatCurrencies NSArray*
 * @return NSNumber*
 */
+ (NSNumber *)fiatExchangeRate:(NSArray *)fiatCurrencies {
    NSDebug(@"Broker::fiatExchangeRate");

    NSString *jsonURL =
        [NSString stringWithFormat:@"https://min-api.cryptocompare.com/data/pricemulti?fsyms=%@&tsyms=%@&extraParams=de.4customers.iBroker", fiatCurrencies[0], fiatCurrencies[1]];

    NSDictionary *data = [JSON jsonRequest:jsonURL];

    if (!data[fiatCurrencies[0]]) {
        NSLog(@"API-ERROR: Cannot retrieve exchange rates for %@/%@", fiatCurrencies[0], fiatCurrencies[1]);

        return nil;
    }

    return @([data[fiatCurrencies[0]][fiatCurrencies[1]] doubleValue]);
}

/**
 * Retrieve historical data from quandl
 *
 * @param key NSString*
 * @param asset NSString*
 * @param baseAsset NSString*
 * @return NSDictionary*
 */
+ (NSDictionary *)historicalData:(NSString *)key forAsset:(NSString *)asset withBaseAsset:(NSString *)baseAsset fromDate:(NSString *)fromDate {
    NSDebug(@"Broker::historicalData");

    NSString *queryUrl = [NSString stringWithFormat:@"https://www.quandl.com/api/v3/datasets/BTER/%@%@.json?api_key=%@&start_date=%@", asset, baseAsset, key, fromDate];

    NSDictionary *response = [JSON jsonRequest:queryUrl];
    NSDictionary *dataset = response[@"dataset"];
    NSArray *data = dataset[@"data"];

    if (data.count == 0) {
        return nil;
    }

    NSMutableDictionary *historicalData = [[NSMutableDictionary alloc] init];

    for (id value in data) {
        NSDictionary *row = @{
            @"high": value[1],
            @"low": value[2],
            @"last": value[3],
        };

        historicalData[value[0]] = row;
    }

    return historicalData;
}

@end
