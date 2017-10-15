//
//  AssetConstants.h
//  Brokerage
//
//  Created by Markus Bröker on 11.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#ifndef AssetConstants_h
#define AssetConstants_h

#ifdef DEBUG
    #define NSDebug(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
    #define NSDebug(...)
#endif

#define ASSET_KEY(row) [Asset assetString:row withIndex:0]
#define ASSET_DESC(row) [Asset assetString:row withIndex:1]

// Definition der verfügbaren Börsen
#define EXCHANGE_BITSTAMP @"BITSTAMP_EXCHANGE"
#define EXCHANGE_BITTREX @"BITTREX_EXCHANGE"
#define EXCHANGE_POLONIEX @"POLONIEX_EXCHANGE"

#define KEY @"Key"
#define SECRET @"Secret"

#define DEFAULT_EXCHANGE @"defaultExchange"

#define DEFAULT_ASK @"lowestAsk"
#define DEFAULT_BID @"highestBid"
#define DEFAULT_LOW24 @"low24hr"
#define DEFAULT_HIGH24 @"high24hr"
#define DEFAULT_QUOTE_VOLUME @"quoteVolume"
#define DEFAULT_BASE_VOLUME @"baseVolume"
#define DEFAULT_PERCENT @"percentChange"
#define DEFAULT_LAST @"last"

#define DEFAULT_AVAILABLE @"available"
#define DEFAULT_ON_ORDERS @"onOrders"

#define DEFAULT_ORDER_NUMBER @"orderNumber"
#define DEFAULT_ERROR @"error"

// ASSET DESCRIPTION KEYS
#define DASHBOARD @"Dashboard"

// SHARED USER DEFAULTS KEYS
#define KEY_DEFAULT_EXCHANGE @"defaultExchange"
#define KEY_CURRENT_ASSETS @"currentAssets"

#endif /* AssetConstants_h */
