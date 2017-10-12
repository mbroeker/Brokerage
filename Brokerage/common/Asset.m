//
//  Asset.m
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Asset.h"
#import "JSON.h"

@implementation Asset

/**
 *
 * @return NSArray*
 */
+ (NSArray *)initialAssets {
    NSDebug(@"Asset::initialAssets");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *assets = [defaults objectForKey:KEY_CURRENT_ASSETS];

    if (assets == nil) {
        #ifdef DEBUG
        NSLog(@"Creating inital assets");
        #endif
        assets = @[
            @[DASHBOARD, DASHBOARD],
            @[@"BTC", @"Bitcoin"],
            @[@"DASH", @"Digital Cash"],
            @[@"ETH", @"Ethereum"],
            @[@"XMR", @"Monero"],
            @[@"LTC", @"Litecoin"],
            @[@"DCR", @"Decred"],
            @[@"STRAT", @"Stratis"],
            @[@"GAME", @"GameCredits"],
            @[@"XRP", @"Ripple"],
            @[@"XEM", @"New Economy"],
        ];

        [defaults setObject:assets forKey:KEY_CURRENT_ASSETS];
        [defaults synchronize];
    }

    return assets;
}

/**
 *
 * @param row unsigned int
 * @param index unsigned int
 * @return NSString*
 */
+ (NSString *)assetString:(unsigned int)row withIndex:(unsigned)index {
    static NSArray *assets = nil;

    if (assets == nil) {
        assets = [Asset initialAssets];
    }

    return assets[row][index];
}

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
 * @param fromDate NSDate*
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
